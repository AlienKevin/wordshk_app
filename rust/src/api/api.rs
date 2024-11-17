use std::collections::BinaryHeap;
use std::io::Cursor;
use std::time::Instant;

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use itertools::Itertools;
use lazy_static::lazy_static;
use once_cell::sync::Lazy;
use parking_lot::RwLock;
use wordshk_tools::dict::{clause_to_string, EntryId};
use wordshk_tools::english_index::EnglishSearchRank;
use wordshk_tools::entry_group_index;
use wordshk_tools::jyutping::LaxJyutPing;
pub use wordshk_tools::jyutping::Romanization;
use wordshk_tools::lean_rich_dict::to_lean_rich_entry;
use wordshk_tools::rich_dict::RichVariants;
use wordshk_tools::search::VariantMapLike;
use wordshk_tools::search::{self, CombinedSearchRank, RichDictLike};
pub use wordshk_tools::search::{MatchedInfix, MatchedSegment, Script};
use wordshk_tools::sqlite_db::SqliteDb;

pub struct CombinedSearchResults {
    // First Option<usize> is the score
    pub variant_results: (Option<u32>, Vec<VariantSearchResult>),
    pub pr_results: (Option<u32>, Vec<PrSearchResult>),
    pub english_results: (Option<u32>, Vec<EnglishSearchResult>),
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
    pub prs: Vec<String>,
    pub yues: Vec<String>,
    pub engs: Vec<String>,
}

pub struct EnglishSearchResult {
    pub id: u32,
    pub def_index: u32,
    pub variants: Vec<(String, String)>,
    pub matched_eng: Vec<MatchedSegment>,
}

pub struct EgSearchResult {
    pub id: u32,
    pub def_index: u32,
    pub eg_index: u32,
    pub matched_eg: MatchedInfix,
}

pub struct EntrySummary {
    pub variant_trad: String,
    pub variant_simp: String,
    pub defs: Vec<EntryDef>,
}

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

static API: Lazy<RwLock<Option<SqliteDb>>> = Lazy::new(|| RwLock::new(None));

#[frb(init)]
pub fn init_utils() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

pub fn init_api(dict_path: String, dict_zip: Vec<u8>) {
    let mut api = API.write();

    let mut t = Instant::now();

    if !dict_zip.is_empty() {
        let mut archive = flate2::read::GzDecoder::new(Cursor::new(dict_zip));
        let mut file = std::fs::File::create(&dict_path).unwrap();
        std::io::copy(&mut archive, &mut file).unwrap();
        log!(t, "Extracted new dictionary database");
    }

    let dict = SqliteDb::new(&dict_path);
    *api = Some(dict);

    log_stream_sink
        .write()
        .as_ref()
        .unwrap()
        .add("Initialized API".to_string())
        .unwrap();
}

pub fn get_entry_summaries(entry_ids: Vec<u32>) -> Vec<EntrySummary> {
    let summaries = entry_ids
        .into_iter()
        .filter_map(|entry_id| {
            let api = API.read();
            let api = api.as_ref().unwrap();
            let (variants, defs) = get_entry_defs(entry_id, api)?;
            Some(EntrySummary {
                variant_trad: variants.0.first().unwrap().word.clone(),
                variant_simp: variants.0.first().unwrap().word_simp.clone(),
                defs,
            })
        })
        .collect();
    summaries
}

pub fn combined_search(
    capacity: u32,
    query: String,
    script: Script,
    romanization: Romanization,
) -> CombinedSearchResults {
    let api = API.read();
    let api = api.as_ref().unwrap();
    match &mut search::combined_search(api, &query, script, romanization) {
        CombinedSearchRank::Variant(variant_ranks) => CombinedSearchResults {
            variant_results: variant_ranks_to_results(
                variant_ranks,
                api,
                script,
                romanization,
                capacity,
            ),
            pr_results: (None, vec![]),
            english_results: (None, vec![]),
        },
        CombinedSearchRank::Pr(pr_ranks) => CombinedSearchResults {
            variant_results: (None, vec![]),
            pr_results: pr_ranks_to_results(pr_ranks, api, script, capacity),
            english_results: (None, vec![]),
        },
        CombinedSearchRank::All(variant_ranks, pr_ranks, english_ranks) => CombinedSearchResults {
            variant_results: variant_ranks_to_results(
                variant_ranks,
                api,
                script,
                romanization,
                capacity,
            ),
            pr_results: pr_ranks_to_results(pr_ranks, api, script, capacity),
            english_results: english_ranks_to_results(
                english_ranks,
                api,
                script,
                romanization,
                capacity,
            ),
        },
    }
}

pub fn eg_search(
    capacity: u32,
    max_first_index_in_eg: u32,
    query: String,
    script: Script,
) -> Vec<EgSearchResult> {
    let api = API.read();
    let api = api.as_ref().unwrap();
    let mut ranks = search::eg_search(api, &query, max_first_index_in_eg as usize, script);
    let mut results = vec![];
    let mut i = 0;
    while ranks.len() > 0 && i < capacity {
        let search::EgSearchRank {
            id,
            def_index,
            eg_index,
            matched_eg,
            ..
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

pub fn get_entry_group_json(id: u32) -> Vec<String> {
    let api = API.read();
    let api = api.as_ref().unwrap();
    let rich_entry_group = entry_group_index::get_entry_group(api, id);
    rich_entry_group
        .iter()
        .map(|entry| serde_json::to_string(&to_lean_rich_entry(entry)).unwrap())
        .collect()
}

pub fn get_entry_id(query: String, script: Script) -> Option<u32> {
    let api = API.read();
    let api = api.as_ref().unwrap();
    api.get(&query, script).map(|id| id as u32)
}

fn jyutping_to_standard_romanization(
    pr: &LaxJyutPing,
    romanization: Romanization,
) -> Option<String> {
    match romanization {
        Romanization::Jyutping => pr.to_jyutpings().map(|jyutpings| {
            jyutpings
                .iter()
                .map(|jyutping| jyutping.to_string())
                .join(" ")
        }),
        Romanization::Yale => {
            let yale = pr.to_yale();
            if yale.is_empty() {
                None
            } else {
                Some(yale)
            }
        }
    }
}

fn variant_ranks_to_results(
    variant_ranks: &mut BinaryHeap<search::VariantSearchRank>,
    dict: &dyn RichDictLike,
    script: Script,
    romanization: Romanization,
    capacity: u32,
) -> (Option<u32>, Vec<VariantSearchResult>) {
    let mut variant_search_results = vec![];
    let mut i = 0;
    let max_score = variant_ranks.peek().map(|rank| {
        let m = &rank.matched_variant;
        (100 - m.prefix.chars().count() - m.suffix.chars().count()) as u32
    });
    while !variant_ranks.is_empty() && i < capacity {
        let search::VariantSearchRank {
            id,
            matched_variant,
            variant_index,
            ..
        } = variant_ranks.pop().unwrap();
        let (variants, defs) = get_entry_defs(id, dict).unwrap();
        variant_search_results.push(VariantSearchResult {
            id: id as u32,
            matched_variant: matched_variant.clone(),
            prs: variants.0[variant_index]
                .prs
                .0
                .iter()
                .filter_map(|pr| jyutping_to_standard_romanization(pr, romanization))
                .collect(),
            yues: defs
                .iter()
                .map(|def| match script {
                    Script::Traditional => def.yue_trad.clone(),
                    Script::Simplified => def.yue_simp.clone(),
                })
                .collect(),
            engs: defs.iter().map(|def| def.eng.clone()).collect(),
        });
        i += 1;
    }
    (max_score, variant_search_results)
}

fn pr_ranks_to_results(
    pr_ranks: &mut BinaryHeap<search::PrSearchRank>,
    dict: &dyn RichDictLike,
    script: Script,
    capacity: u32,
) -> (Option<u32>, Vec<PrSearchResult>) {
    let mut pr_search_results = vec![];
    let mut i = 0;
    let max_score = pr_ranks.peek().map(|rank| rank.score as u32);
    while !pr_ranks.is_empty() && i < capacity {
        let search::PrSearchRank {
            id,
            variants,
            matched_pr,
            ..
        } = pr_ranks.pop().unwrap();
        let (_, defs) = get_entry_defs(id, dict).unwrap();
        pr_search_results.push(PrSearchResult {
            id: id as u32,
            variants,
            matched_pr,
            yues: defs
                .iter()
                .map(|def| match script {
                    Script::Traditional => def.yue_trad.clone(),
                    Script::Simplified => def.yue_simp.clone(),
                })
                .collect(),
            engs: defs.iter().map(|def| def.eng.clone()).collect(),
        });
        i += 1;
    }
    (max_score, pr_search_results)
}

pub struct EntryDef {
    pub yue_trad: String,
    pub yue_simp: String,
    pub eng: String,
}

fn get_entry_defs(id: EntryId, dict: &dyn RichDictLike) -> Option<(RichVariants, Vec<EntryDef>)> {
    let entry = dict.get_entry(id)?;
    let defs: &Vec<wordshk_tools::rich_dict::RichDef> = &entry.defs;
    Some((
        entry.variants,
        defs.iter()
            .filter_map(|def| {
                def.eng
                    .as_ref()
                    .map(|def| {
                        let result = clause_to_string(&def);
                        result
                    })
                    .map(|eng| EntryDef {
                        yue_trad: clause_to_string(&def.yue),
                        yue_simp: clause_to_string(&def.yue_simp),
                        eng,
                    })
            })
            .collect(),
    ))
}

fn english_ranks_to_results(
    english_ranks: &mut BinaryHeap<EnglishSearchRank>,
    dict: &dyn RichDictLike,
    script: Script,
    romanization: Romanization,
    capacity: u32,
) -> (Option<u32>, Vec<EnglishSearchResult>) {
    let mut english_search_results = vec![];
    let mut i = 0;
    let max_score = english_ranks.peek().map(|rank| {
        // If the query appears in the English definition, give it a score of 100
        if rank.matched_eng.iter().any(|segment| segment.matched) {
            100
        } else {
            rank.score as u32
        }
    });
    while !english_ranks.is_empty() && i < capacity {
        let entry = english_ranks.pop().unwrap();
        let variants =
            search::pick_variants(&dict.get_entry(entry.entry_id).unwrap().variants, script);
        english_search_results.push(EnglishSearchResult {
            id: entry.entry_id as u32,
            def_index: entry.def_index as u32,
            variants: variants
                .0
                .iter()
                .map(|v| {
                    (
                        v.word.clone(),
                        v.prs
                            .0
                            .iter()
                            .filter_map(|pr| jyutping_to_standard_romanization(pr, romanization))
                            .join(", "),
                    )
                })
                .collect(),
            matched_eng: entry.matched_eng.clone(),
        });
        i += 1;
    }
    (max_score, english_search_results)
}
