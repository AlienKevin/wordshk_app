use std::collections::{BTreeMap, HashMap};
use std::collections::BinaryHeap;
use std::sync::Mutex;
use std::time::Instant;

use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use once_cell::sync::Lazy;
use parking_lot::RwLock;
use rkyv::Deserialize;
use wordshk_tools::dict::{clause_to_string, EntryId};
use wordshk_tools::english_index::{ArchivedEnglishIndex, EnglishIndex, EnglishSearchRank};
pub use wordshk_tools::jyutping::Romanization;
use wordshk_tools::lean_rich_dict::to_lean_rich_entry;
use wordshk_tools::pr_index::FstPrIndices;
use wordshk_tools::rich_dict::ArchivedRichDict;
use wordshk_tools::rich_dict::RichDict;
use wordshk_tools::search;
use wordshk_tools::search::{CombinedSearchRank, VariantsMap};
pub use wordshk_tools::search::{MatchedInfix, MatchedSegment, Script};
use wordshk_tools::unicode::is_cjk;

use crate::frb_generated::StreamSink;

pub struct CombinedSearchResults {
    pub variant_results: Vec<VariantSearchResult>,
    pub pr_results: Vec<PrSearchResult>,
    pub english_results: Vec<EnglishSearchResult>,
}

#[frb(mirror(Script))]
pub enum _Script {
    Simplified,
    Traditional,
}

#[frb(mirror(Romanization))]
pub enum _Romanization {
    Jyutping,
    Yale,
}

#[frb(mirror(MatchedSegment))]
pub struct _MatchedSegment {
    segment: String,
    matched: bool,
}

pub struct PrSearchResult {
    pub id: u32,
    pub variants: Vec<String>,
    pub matched_pr: Vec<MatchedSegment>,
    pub yues: Vec<String>,
    pub engs: Vec<String>,
}

#[frb(mirror(MatchedInfix))]
pub struct _MatchedInfix {
    prefix: String,
    query: String,
    suffix: String,
}

pub struct VariantSearchResult {
    pub id: u32,
    pub matched_variant: MatchedInfix,
    pub yues: Vec<String>,
    pub engs: Vec<String>,
}

pub struct EnglishSearchResult {
    pub id: u32,
    pub def_index: u32,
    pub variant: String,
    pub pr: String,
    pub matched_eng: Vec<MatchedSegment>,
}

pub struct EgSearchResult {
    pub id: u32,
    pub def_index: u32,
    pub eg_index: u32,
    pub matched_eg: MatchedInfix,
}

pub struct EntrySummary {
    pub variant: String,
    pub defs: Vec<(String, String)>,
}

#[repr(align(8))]
struct Align8<T: ?Sized>(pub T);

pub struct WordshkApi {
    pr_indices: Option<FstPrIndices>,
    variants_map: VariantsMap,
    word_list: HashMap<String, Vec<String>>,
}

const dict_data: &Align8<[u8]> = &Align8(*include_bytes!("../../data/dict.rkyv"));
const english_index_data: &Align8<[u8]> = &Align8(*include_bytes!("../../data/english_index.rkyv"));

lazy_static! {
    static ref log_stream_sink: RwLock<Option<StreamSink<String>>> = RwLock::new(None);
}

pub fn create_log_stream(s: StreamSink<String>) {
    *log_stream_sink.write() = Some(s);
}

macro_rules! log {
    ($t:expr, $msg:expr $(, $args:expr)*) => {{
        let message = format!($msg $(, $args)*);
        let elapsed_time = $t.elapsed().as_micros();
        let log_message = format!("{} ({}µs)", message, elapsed_time);
        log_stream_sink.write().as_ref().unwrap().add(log_message);
        // Update time
        $t = Instant::now();
    }};
}

static API: Lazy<Mutex<WordshkApi>> = Lazy::new(|| Mutex::new(WordshkApi::new()));

#[frb(init)]
pub fn init_utils() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

pub fn init_api() -> () {
    let mut api = API.lock().unwrap();

    let mut t = Instant::now();

    api.variants_map = search::rich_dict_to_variants_map(&dict());
    log!(t, "Constructed variants_map");

    log_stream_sink.write().as_ref().unwrap().add("Initialized API".to_string());
}

impl WordshkApi {
    fn new() -> WordshkApi {
        let mut t = Instant::now();

        let word_list = include_str!("../../data/word_list.tsv");
        log!(t, "Loaded word_list");

        let mut rdr = csv::ReaderBuilder::new()
            .has_headers(false)
            .delimiter(b'\t')
            .from_reader(word_list.as_bytes());
        log!(t, "Read word_list");
        let mut word_list = HashMap::new();
        for result in rdr.records() {
            let record = result.unwrap();
            let trad = record[0].to_string();
            let simp = record[1].to_string();
            let pr = record[2].to_string();
            // push simplified variant if it's different from the traditional
            if simp != trad {
                word_list.entry(simp).or_insert(vec![]).push(pr.clone());
            }
            // push traditional variant
            word_list.entry(trad).or_insert(vec![]).push(pr);
        }
        log!(t, "Loaded word_list");

        WordshkApi {
            pr_indices: None,
            variants_map: BTreeMap::default(),
            word_list,
        }
    }
}

fn dict() -> &'static ArchivedRichDict {
    unsafe { rkyv::archived_root::<RichDict>(&dict_data.0) }
}

fn english_index() -> &'static ArchivedEnglishIndex {
    unsafe { rkyv::archived_root::<EnglishIndex>(&english_index_data.0) }
}

pub fn get_entry_summaries(entry_ids: Vec<u32>, script: Script) -> Vec<EntrySummary> {
    let summaries = entry_ids.into_iter().map(|entry_id| {
        let api = API.lock().unwrap();
        let entry = api.variants_map.get(&entry_id).unwrap().first().unwrap();
        let variant = match script {
            Script::Traditional => entry.word_trad.clone(),
            Script::Simplified => entry.word_simp.clone(),
        };
        let defs = get_entry_defs(entry_id, dict(), script);
        EntrySummary { variant, defs }
    }).collect();
    summaries
}

pub fn generate_pr_indices(romanization: Romanization) {
    let pr_indices = wordshk_tools::pr_index::generate_pr_indices( dict(), romanization);
    API.lock().unwrap().pr_indices = Some(wordshk_tools::pr_index::pr_indices_into_fst(pr_indices));
}

pub fn combined_search(capacity: u32, query: String, script: Script, romanization: Romanization) -> CombinedSearchResults {
    let api = API.lock().unwrap();
    match &mut search::combined_search(&api.variants_map, api.pr_indices.as_ref(), english_index(), dict(), &query, script, romanization) {
        CombinedSearchRank::Variant(variant_ranks) =>
            CombinedSearchResults {
                variant_results: variant_ranks_to_results(variant_ranks, &api.variants_map, dict(), script, capacity),
                pr_results: vec![],
                english_results: vec![]
            },
        CombinedSearchRank::Pr(pr_ranks) =>
            CombinedSearchResults {
                variant_results: vec![],
                pr_results: pr_ranks_to_results(pr_ranks, &api.variants_map,  dict(),script, capacity),
                english_results: vec![]
            },
        CombinedSearchRank::All(variant_ranks, pr_ranks, english_ranks) =>
            CombinedSearchResults {
                variant_results: variant_ranks_to_results(variant_ranks, &api.variants_map, dict(), script, capacity),
                pr_results: pr_ranks_to_results(pr_ranks, &api.variants_map, dict(), script, capacity),
                english_results: english_ranks_to_results(english_ranks, &api.variants_map, script, capacity)
            }
    }
}

pub fn eg_search(capacity: u32, max_first_index_in_eg: u32, query: String, script: Script) -> Vec<EgSearchResult> {
    let api = API.lock().unwrap();
    let mut ranks = search::eg_search(&api.variants_map, dict(), &query, max_first_index_in_eg as usize, script);
    let mut results = vec![];
    let mut i = 0;
    while ranks.len() > 0 && i < capacity {
        let search::EgSearchRank {
            id, def_index, eg_index, matched_eg, ..
        } = ranks.pop().unwrap();
        results.push(EgSearchResult {
            id: id as u32,
            def_index: def_index as u32,
            eg_index: eg_index as u32,
            matched_eg,
        });
        i += 1;
    }
    results
}

pub fn get_entry_json(id: u32) -> String {
    let rich_entry = dict().get(&id).unwrap().deserialize(&mut rkyv::Infallible).unwrap();
    serde_json::to_string(&to_lean_rich_entry(&rich_entry)).unwrap()
}

pub fn get_entry_group_json(id: u32) -> Vec<String> {
    let api = API.lock().unwrap();
    let rich_entry_group = search::get_entry_group(&api.variants_map, dict(), id);
    rich_entry_group
        .iter()
        .map(|entry| serde_json::to_string(&to_lean_rich_entry(entry)).unwrap())
        .collect()
}

pub fn get_entry_id(query: String, script: Script) -> Option<u32> {
    search::get_entry_id(&API.lock().unwrap().variants_map, &query, script).map(|id| id as u32)
}

pub fn get_jyutping(query: String) -> Vec<String> {
    let query_normalized: String = query.chars().filter(|&c| is_cjk(c)).collect();
    if query_normalized.chars().count() == 1 {
        search::get_char_jyutpings(query_normalized.chars().next().unwrap()).unwrap_or(vec![])
    } else {
        API.lock().unwrap().word_list.get(&query_normalized).unwrap_or(&vec![]).clone()
    }
}

fn variant_ranks_to_results(variant_ranks: &mut BinaryHeap<search::VariantSearchRank>, variants_map: &VariantsMap, dict: &ArchivedRichDict, script: Script, capacity: u32) -> Vec<VariantSearchResult> {
    let mut variant_search_results = vec![];
    let mut i = 0;
    while !variant_ranks.is_empty() && i < capacity {
        let search::VariantSearchRank {
            id, matched_variant, ..
        } = variant_ranks.pop().unwrap();
        let defs = get_entry_defs(id, dict, script);
        let (yues, engs) = defs.into_iter().unzip();
        variant_search_results.push(VariantSearchResult {
            id: id as u32,
            matched_variant: matched_variant.clone(),
            yues,
            engs,
        });
        i += 1;
    }
    variant_search_results
}

fn pr_ranks_to_results(pr_ranks: &mut BinaryHeap<search::PrSearchRank>, variants_map: &VariantsMap, dict: &ArchivedRichDict, script: Script, capacity: u32) -> Vec<PrSearchResult> {
    let mut pr_search_results = vec![];
    let mut i = 0;
    while !pr_ranks.is_empty() && i < capacity {
        let search::PrSearchRank {
            id, variants, matched_pr,  ..
        } = pr_ranks.pop().unwrap();
        let defs = get_entry_defs(id, dict, script);
        let (yues, engs) = defs.into_iter().unzip();
        pr_search_results.push(PrSearchResult {
            id: id as u32,
            variants,
            matched_pr,
            yues,
            engs,
        });
        i += 1;
    }
    pr_search_results
}

fn get_entry_defs(id: EntryId, dict: &ArchivedRichDict, script: Script) -> Vec<(String, String)> {
    let defs = &dict.get(&id).unwrap().defs;
    defs.iter().filter_map(|def|
        def.eng.as_ref().map(|def| {
            let result = clause_to_string(&def.deserialize(&mut rkyv::Infallible).unwrap());
            result
        }).map(|eng|
            (clause_to_string(&match script {
                Script::Simplified => def.yue_simp.deserialize(&mut rkyv::Infallible).unwrap(),
                Script::Traditional => def.yue.deserialize(&mut rkyv::Infallible).unwrap(), }),
             eng,
            )
        )).collect()
}

fn english_ranks_to_results(english_ranks: &mut BinaryHeap<EnglishSearchRank>, variants_map: &VariantsMap, script: Script, capacity: u32) -> Vec<EnglishSearchResult> {
    let mut english_search_results = vec![];
    let mut i = 0;
    while !english_ranks.is_empty() && i < capacity {
        let entry = english_ranks.pop().unwrap();
        let variant = &search::pick_variants(&variants_map.get(&entry.entry_id).unwrap(), script).0[0];
        english_search_results.push(EnglishSearchResult {
            id: entry.entry_id as u32,
            def_index: entry.def_index as u32,
            variant: variant.word.clone(),
            pr: variant.prs.0[0].to_string(),
            matched_eng: entry.matched_eng.clone(),
        });
        i += 1;
    }
    english_search_results
}
