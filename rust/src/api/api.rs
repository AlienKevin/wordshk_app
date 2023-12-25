use std::collections::HashMap;
use std::env;
use std::io::prelude::*;
use std::io::Read;
use std::sync::Mutex;

use anyhow::Result;
use flate2::Compression;
use flate2::read::GzDecoder;
use flate2::write::GzEncoder;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use once_cell::sync::Lazy;
use rmp_serde::Serializer;
use serde::Serialize;
use wordshk_tools::dict::clause_to_string;
use wordshk_tools::english_index::EnglishIndex;
pub use wordshk_tools::jyutping::Romanization;
use wordshk_tools::lean_rich_dict::to_lean_rich_entry;
use wordshk_tools::pr_index::PrIndices;
use wordshk_tools::rich_dict::RichDict;
use wordshk_tools::search;
use wordshk_tools::search::{CombinedSearchRank, VariantsMap};
pub use wordshk_tools::search::Script;
use wordshk_tools::unicode::is_cjk;

use crate::api::utils::*;

// use oslog::{OsLogger};
// use log::{LevelFilter, info};
// use log::info;

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

pub struct PrSearchResult {
    pub id: u32,
    pub variant: String,
    pub pr: String,
    pub yues: Vec<String>,
    pub engs: Vec<String>,
}

pub struct VariantSearchResult {
    pub id: u32,
    pub variant: String,
    pub yues: Vec<String>,
    pub engs: Vec<String>,
}

pub struct EnglishSearchResult {
    pub id: u32,
    pub def_index: u32,
    pub variant: String,
    pub pr: String,
    pub eng: String,
}

pub struct EgSearchResult {
    pub id: u32,
    pub def_index: u32,
    pub eg_index: u32,
    pub eg: String,
}

pub struct SpotlightEntrySummary {
    pub id: usize,
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
    dict: RichDict,
    english_index: EnglishIndex,
    pr_indices: Mutex<PrIndices>,
    variants_map: VariantsMap,
    word_list: HashMap<String, Vec<String>>,
}

lazy_static! {
    static ref IS_LOG_INITIALIZED: Mutex<bool> = Mutex::new(false);
}

static API: Lazy<WordshkApi> =
    Lazy::new(|| { env::set_var("RUST_BACKTRACE", "1"); WordshkApi::new() });

pub fn init_api() -> () {
    let _ = &*API;
}

impl WordshkApi {
    fn new() -> WordshkApi {
        // if !(*IS_LOG_INITIALIZED.lock()) {
        //     OsLogger::new("hk.words")
        //         .level_filter(LevelFilter::Debug)
        //         .category_level_filter("Settings", LevelFilter::Trace)
        //         .init()
        //         .unwrap();
        //     *IS_LOG_INITIALIZED.lock() = true;
        // }
        // info!("Calling Api::new()...");

        let dict_json = include_bytes!("../../data/dict.json");
        let english_index_json = include_bytes!("../../data/english_index.json");
        let word_list = include_str!("../../data/word_list.tsv");

        let mut dict_decompressor = GzDecoder::new(&dict_json[..]);
        let mut dict_str = String::new();
        dict_decompressor.read_to_string(&mut dict_str).unwrap();
        let dict: RichDict = serde_json::from_str(&dict_str).unwrap();

        let variants_map = search::rich_dict_to_variants_map(&dict);
        // info!("Loaded dict");

        let mut english_index_decompressor = GzDecoder::new(&english_index_json[..]);
        let mut english_index_str = String::new();
        english_index_decompressor.read_to_string(&mut english_index_str).unwrap();
        let english_index: EnglishIndex = serde_json::from_str(&english_index_str).unwrap();
        // info!("Loaded english index");

        let mut rdr = csv::ReaderBuilder::new()
            .has_headers(false)
            .delimiter(b'\t')
            .from_reader(word_list.as_bytes());
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
        // info!("Loaded word list");

        WordshkApi {
            dict,
            english_index,
            pr_indices: Mutex::new(PrIndices::default()),
            variants_map,
            word_list,
        }
    }
}


pub fn get_entry_summaries(entry_ids: Vec<u32>, script: Script) -> Result<Vec<EntrySummary>> {
    let summaries = entry_ids.into_iter().map(|entry_id| {
        let entry = API.dict.get(&(entry_id as usize)).unwrap();
        let variant = match script {
            Script::Traditional => entry.variants.to_words().first().unwrap().to_string(),
            Script::Simplified => entry.variants_simp.first().unwrap().to_string(),
        };
        let defs = get_entry_defs(entry.id, &API.dict, script);
        EntrySummary { variant, defs }
    }).collect();
    Ok(summaries)
}

pub fn update_pr_indices(pr_indices: Vec<u8>) -> Result<()> {
    let mut pr_indices_decompressor = GzDecoder::new(&pr_indices[..]);
    let mut pr_indices_bytes = Vec::new();
    pr_indices_decompressor.read_to_end(&mut pr_indices_bytes)?;
    let pr_indices: PrIndices = rmp_serde::from_slice(&pr_indices_bytes[..])?;
    *API.pr_indices.lock().unwrap() = pr_indices;
    Ok(())
}

pub fn generate_pr_indices(romanization: Romanization) -> Vec<u8> {
    // info!("in generate_pr_indices");
    let pr_indices = wordshk_tools::pr_index::generate_pr_indices(&API.dict, romanization);

    let mut buf = Vec::new();
    pr_indices
        .serialize(&mut Serializer::new(&mut buf))
        .unwrap();

    let mut e = GzEncoder::new(Vec::new(), Compression::default());
    e.write_all(&buf).expect("failed to compress pr_indices");
    let result = e.finish().expect("failed to finish compressing the stream of pr_indices");
    *API.pr_indices.lock().unwrap() = pr_indices;
    result
}

pub fn pr_search(capacity: u32, query: String, script: Script, romanization: Romanization) -> Vec<PrSearchResult> {
    let mut ranks = search::pr_search(&API.pr_indices.lock().unwrap(), &API.dict, &query, romanization);
    pr_ranks_to_results(&mut ranks, &API.variants_map, &API.dict, script, capacity)
}

pub fn variant_search(capacity: u32, query: String, script: Script) -> Vec<VariantSearchResult> {
    let mut ranks = search::variant_search(&API.variants_map, &query, script);
    variant_ranks_to_results(&mut ranks, &API.variants_map, &API.dict, script, capacity)
}

pub fn combined_search(capacity: u32, query: String, script: Script, romanization: Romanization) -> CombinedSearchResults {
    match &mut search::combined_search(&API.variants_map, &API.pr_indices.lock().unwrap(), &API.english_index, &API.dict, &query, script, romanization) {
        CombinedSearchRank::Variant(variant_ranks) =>
            CombinedSearchResults {
                variant_results: variant_ranks_to_results(variant_ranks, &API.variants_map, &API.dict, script, capacity),
                pr_results: vec![],
                english_results: vec![]
            },
        CombinedSearchRank::Pr(pr_ranks) =>
            CombinedSearchResults {
                variant_results: vec![],
                pr_results: pr_ranks_to_results(pr_ranks, &API.variants_map,  &API.dict,script, capacity),
                english_results: vec![]
            },
        CombinedSearchRank::All(variant_ranks, pr_ranks, english_ranks) =>
            CombinedSearchResults {
                variant_results: variant_ranks_to_results(variant_ranks, &API.variants_map, &API.dict, script, capacity),
                pr_results: pr_ranks_to_results(pr_ranks, &API.variants_map, &API.dict, script, capacity),
                english_results: english_ranks_to_results(english_ranks, &API.dict, &API.variants_map, script, capacity)
            }
    }
}

pub fn english_search(capacity: u32, query: String, script: Script) -> Vec<EnglishSearchResult> {
    let entries = search::english_search(&API.english_index, &query);
    entries[..std::cmp::min(capacity as usize, entries.len())]
        .iter()
        .map(|entry| {
            let variant = &search::pick_variants(&API.variants_map.get(&entry.entry_id).unwrap(), script).0[0];
            EnglishSearchResult {
                id: entry.entry_id as u32,
                def_index: entry.def_index as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[0].to_string(),
                eng: clause_to_string(
                    &API.dict.get(&entry.entry_id).unwrap().defs[entry.def_index]
                        .eng
                        .as_ref()
                        .unwrap(),
                ),
            }
        })
        .collect()
}

pub fn eg_search(capacity: u32, max_first_index_in_eg: u32, query: String, script: Script) -> (Option<String>, Vec<EgSearchResult>) {
    let (query_found, mut ranks) = search::eg_search(&API.dict, &query, max_first_index_in_eg as usize, script);
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
                Script::Traditional => API.dict[&id].defs[def_index].egs[eg_index].yue.as_ref().unwrap().to_string(),
                Script::Simplified => API.dict[&id].defs[def_index].egs[eg_index].yue_simp.as_ref().unwrap().to_string(),
            }
        });
        i += 1;
    }
    (query_found, results)
}

pub fn get_splotlight_summaries() -> Vec<SpotlightEntrySummary> {
    // Create the final EntrySummary list
    let summaries: Vec<SpotlightEntrySummary> = API.dict.iter()
        .map(|(id, entry)| {
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

pub fn get_entry_json(id: usize) -> String {
    let rich_entry = API.dict.get(&id).unwrap();
    serde_json::to_string(&to_lean_rich_entry(rich_entry)).unwrap()
}

pub fn get_entry_group_json(id: usize) -> Vec<String> {
    let rich_entry_group = search::get_entry_group(&API.dict, &id);
    rich_entry_group
        .iter()
        .map(|entry| serde_json::to_string(&to_lean_rich_entry(entry)).unwrap())
        .collect()
}

pub fn get_entry_id(query: String, script: Script) -> Option<u32> {
    search::get_entry_id(&API.variants_map, &query, script).map(|id| id as u32)
}

pub fn get_jyutping(query: String) -> Vec<String> {
    let query_normalized: String = query.chars().filter(|&c| is_cjk(c)).collect();
    if query_normalized.chars().count() == 1 {
        search::get_char_jyutpings(query_normalized.chars().next().unwrap()).unwrap_or(vec![])
    } else {
        API.word_list.get(&query_normalized).unwrap_or(&vec![]).clone()
    }
}
