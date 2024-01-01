use std::collections::{BTreeMap, HashMap};
use std::collections::BinaryHeap;
use std::env;
use std::io::Write;
use std::sync::Mutex;
use std::time::Instant;

use anyhow::Result;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use once_cell::sync::{Lazy, OnceCell};
use parking_lot::RwLock;
use rkyv::{AlignedVec, Deserialize};
use wordshk_tools::dict::{clause_to_string, EntryId};
use wordshk_tools::english_index::{ArchivedEnglishIndex, EnglishIndex, EnglishSearchRank};
pub use wordshk_tools::jyutping::Romanization;
use wordshk_tools::lean_rich_dict::to_lean_rich_entry;
use wordshk_tools::pr_index::PrIndices;
use wordshk_tools::rich_dict::{RichDict, RichEntry, RichLine};
use wordshk_tools::rich_dict::ArchivedRichDict;
use wordshk_tools::search;
use wordshk_tools::search::{CombinedSearchRank, VariantsMap};
pub use wordshk_tools::search::{MatchedSegment, MatchedVariant, Script};
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
    pub variant: String,
    pub matched_pr: Vec<MatchedSegment>,
    pub yues: Vec<String>,
    pub engs: Vec<String>,
}

#[frb(mirror(MatchedVariant))]
pub struct _MatchedVariant {
    prefix: String,
    query: String,
    suffix: String,
}

pub struct VariantSearchResult {
    pub id: u32,
    pub matched_variant: MatchedVariant,
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
    pub eg: String,
}

pub struct SpotlightEntrySummary {
    pub id: u32,
    pub variants: Vec<String>,
    pub variants_simp: Vec<String>,
    pub jyutpings: Vec<String>,
    pub yales: Vec<String>,
    pub def: String,
    pub def_simp: String,
    pub def_en: String,
}

pub struct EntrySummary {
    pub variant: String,
    pub defs: Vec<(String, String)>,
}

pub struct WordshkApi {
    dict_data: AlignedVec,
    english_index_data: AlignedVec,
    pr_indices: Option<PrIndices>,
    variants_map: VariantsMap,
    word_list: HashMap<String, Vec<String>>,
}

lazy_static! { static ref log_stream_sink: RwLock<Option<StreamSink<String>>> = RwLock::new(None); }

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
static SENTRY_GUARD: OnceCell<sentry::ClientInitGuard> = OnceCell::new();

pub fn init_api(dict_data: Vec<u8>, english_index_data: Vec<u8>) -> () {
    env::set_var("RUST_BACKTRACE", "1");
    let mut api = API.lock().unwrap();

    let mut t = Instant::now();
    let mut aligned_dict_data = AlignedVec::with_capacity(dict_data.len());
    aligned_dict_data.extend_from_slice(&dict_data);
    log!(t, "Copied dict_data to aligned_dict_data");

    api.variants_map = search::rich_dict_to_variants_map(&dict(&aligned_dict_data));
    log!(t, "Constructed variants_map");

    api.dict_data = aligned_dict_data;
    log!(t, "Initialized api.dict_data");

    let mut aligned_english_index_data = AlignedVec::with_capacity(english_index_data.len());
    aligned_english_index_data.extend_from_slice(&english_index_data);
    log!(t, "Copied english_index_data to aligned_english_index_data");

    api.english_index_data = aligned_english_index_data;

    log_stream_sink.write().as_ref().unwrap().add("Initialized API".to_string());
}

impl WordshkApi {
    fn new() -> WordshkApi {
        let guard = sentry::init((include_str!("../../sentry_dsn.txt"), sentry::ClientOptions {
            release: sentry::release_name!(),
            ..Default::default()
        }));
        let _ = SENTRY_GUARD.set(guard);

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
            dict_data: AlignedVec::default(),
            english_index_data: AlignedVec::default(),
            pr_indices: None,
            variants_map: BTreeMap::default(),
            word_list,
        }
    }
}

fn dict(dict_data: &AlignedVec) -> &ArchivedRichDict {
    unsafe { rkyv::archived_root::<RichDict>(dict_data) }
}

fn english_index(english_index_data: &AlignedVec) -> &ArchivedEnglishIndex {
    unsafe { rkyv::archived_root::<EnglishIndex>(english_index_data) }
}

pub fn get_entry_summaries(entry_ids: Vec<u32>, script: Script) -> Result<Vec<EntrySummary>> {
    let summaries = entry_ids.into_iter().map(|entry_id| {
        let api = API.lock().unwrap();
        let entry = api.variants_map.get(&entry_id).unwrap().first().unwrap();
        let variant = match script {
            Script::Traditional => entry.word_trad.clone(),
            Script::Simplified => entry.word_simp.clone(),
        };
        let defs = get_entry_defs(entry_id, dict(&api.dict_data), script);
        EntrySummary { variant, defs }
    }).collect();
    Ok(summaries)
}

pub fn generate_pr_indices(romanization: Romanization) -> Result<()> {
    let pr_indices = wordshk_tools::pr_index::generate_pr_indices( dict(&API.lock().unwrap().dict_data), romanization);
    API.lock().unwrap().pr_indices = Some(pr_indices);
    Ok(())
}

pub fn pr_search(capacity: u32, query: String, script: Script, romanization: Romanization) -> Vec<PrSearchResult> {
    let api = API.lock().unwrap();
    // Wait for pr_indices to be updated
    match &api.pr_indices {
        None => vec![],
        Some(pr_indices) => {
            let mut ranks = search::pr_search(pr_indices, dict(&api.dict_data), &query, romanization);
            let results = pr_ranks_to_results(&mut ranks, &api.variants_map, dict(&api.dict_data), script, capacity);
            results
        }
    }
}

pub fn variant_search(capacity: u32, query: String, script: Script) -> Vec<VariantSearchResult> {
    let api = API.lock().unwrap();
    let mut ranks = search::variant_search(&api.variants_map, &query, script);
    variant_ranks_to_results(&mut ranks, &api.variants_map, dict(&api.dict_data), script, capacity)
}

pub fn combined_search(capacity: u32, query: String, script: Script, romanization: Romanization) -> CombinedSearchResults {
    let api = API.lock().unwrap();
    match &mut search::combined_search(&api.variants_map, api.pr_indices.as_ref(), english_index(&api.english_index_data), dict(&api.dict_data), &query, script, romanization) {
        CombinedSearchRank::Variant(variant_ranks) =>
            CombinedSearchResults {
                variant_results: variant_ranks_to_results(variant_ranks, &api.variants_map, dict(&api.dict_data), script, capacity),
                pr_results: vec![],
                english_results: vec![]
            },
        CombinedSearchRank::Pr(pr_ranks) =>
            CombinedSearchResults {
                variant_results: vec![],
                pr_results: pr_ranks_to_results(pr_ranks, &api.variants_map,  dict(&api.dict_data),script, capacity),
                english_results: vec![]
            },
        CombinedSearchRank::All(variant_ranks, pr_ranks, english_ranks) =>
            CombinedSearchResults {
                variant_results: variant_ranks_to_results(variant_ranks, &api.variants_map, dict(&api.dict_data), script, capacity),
                pr_results: pr_ranks_to_results(pr_ranks, &api.variants_map, dict(&api.dict_data), script, capacity),
                english_results: english_ranks_to_results(english_ranks, &api.variants_map, script, capacity)
            }
    }
}

pub fn english_search(capacity: u32, query: String, script: Script) -> Vec<EnglishSearchResult> {
    let api = API.lock().unwrap();
    let english_ranks = search::english_search(english_index(&api.english_index_data), dict(&api.dict_data), &query);
    english_ranks_to_results(&english_ranks, &api.variants_map, script, capacity)
}

pub fn eg_search(capacity: u32, max_first_index_in_eg: u32, query: String, script: Script) -> (Option<String>, Vec<EgSearchResult>) {
    let api = API.lock().unwrap();
    let (query_found, mut ranks) = search::eg_search(&api.variants_map, dict(&api.dict_data), &query, max_first_index_in_eg as usize, script);
    let mut results = vec![];
    let mut i = 0;
    while ranks.len() > 0 && i < capacity {
        let search::EgSearchRank {
            id, def_index, eg_index, ..
        } = ranks.pop().unwrap();
        results.push(EgSearchResult {
            id: id as u32,
            def_index: def_index as u32,
            eg_index: eg_index as u32,
            eg: match script {
                Script::Traditional => {
                    let line: RichLine = dict(&api.dict_data)[&id].defs[def_index].egs[eg_index].yue.as_ref().unwrap().deserialize(&mut rkyv::Infallible).unwrap();
                    line.to_string()
                },
                Script::Simplified => dict(&api.dict_data)[&id].defs[def_index].egs[eg_index].yue_simp.as_ref().unwrap().to_string(),
            }
        });
        i += 1;
    }
    (query_found, results)
}

pub fn get_splotlight_summaries() -> Vec<SpotlightEntrySummary> {
    // Create the final EntrySummary list
    let api = API.lock().unwrap();
    let summaries: Vec<SpotlightEntrySummary> = dict(&api.dict_data).iter()
        .map(|(id, entry)| {
            let entry: RichEntry = entry.deserialize(&mut rkyv::Infallible).unwrap();
            SpotlightEntrySummary {
                id: *id,
                variants: entry.variants.to_words().iter().map(|word| word.to_string()).collect(),
                variants_simp: entry.variants_simp.clone(),
                jyutpings: entry.variants.0.iter().map(|variant| variant.prs.0[0].to_string()).collect(),
                yales: entry.variants.0.iter().map(|variant| variant.prs.0[0].to_yale()).collect(),
                def: clause_to_string(&entry.defs[0].yue),
                def_simp: clause_to_string(&entry.defs[0].yue_simp),
                def_en: entry.defs[0].eng.as_ref().map(|c| clause_to_string(c)).unwrap_or("".to_string()),
            }
        })
        .collect();

    summaries
}

pub fn get_entry_json(id: u32) -> String {
    let rich_entry = dict(&API.lock().unwrap().dict_data).get(&id).unwrap().deserialize(&mut rkyv::Infallible).unwrap();
    serde_json::to_string(&to_lean_rich_entry(&rich_entry)).unwrap()
}

pub fn get_entry_group_json(id: u32) -> Vec<String> {
    let api = API.lock().unwrap();
    let rich_entry_group = search::get_entry_group(&api.variants_map, dict(&api.dict_data), id);
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
    while variant_ranks.len() > 0 && i < capacity {
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
    while pr_ranks.len() > 0 && i < capacity {
        let search::PrSearchRank {
            id, variant_index, matched_pr,  ..
        } = pr_ranks.pop().unwrap();
        let variant = &search::pick_variants(variants_map.get(&id).unwrap(), script).0[variant_index];
        let defs = get_entry_defs(id, dict, script);
        let (yues, engs) = defs.into_iter().unzip();
        pr_search_results.push(PrSearchResult {
            id: id as u32,
            variant: variant.word.clone(),
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

fn english_ranks_to_results(english_ranks: &Vec<EnglishSearchRank>, variants_map: &VariantsMap, script: Script, capacity: u32) -> Vec<EnglishSearchResult> {
    english_ranks[..std::cmp::min(capacity as usize, english_ranks.len())]
        .iter()
        .map(|entry| {
            let variant = &search::pick_variants(&variants_map.get(&entry.entry_id).unwrap(), script).0[0];
            EnglishSearchResult {
                id: entry.entry_id as u32,
                def_index: entry.def_index as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[0].to_string(),
                matched_eng: entry.matched_eng.clone(),
            }
        })
        .collect()
}
