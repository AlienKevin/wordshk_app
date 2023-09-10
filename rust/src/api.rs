use anyhow::Result;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use parking_lot::Mutex;
use wordshk_tools::dict::clause_to_string;
pub use wordshk_tools::jyutping::Romanization;
pub use wordshk_tools::search::Script;

use crate::util::*;

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
}

pub struct VariantSearchResult {
    pub id: u32,
    pub variant: String,
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

lazy_static! {
    static ref API: Mutex<Api> = Mutex::new(Api::new());
}

pub struct EntrySummary {
    pub variant: String,
    pub def: String,
}

pub fn get_entry_summaries(entry_ids: Vec<u32>, script: Script, is_eng_def: bool) -> Result<Vec<EntrySummary>> {
    let api = API.lock();
    let summaries = entry_ids.into_iter().map(|entry_id| {
        let entry = api.dict.get(&(entry_id as usize)).unwrap();
        let variant = match script {
            Script::Traditional => entry.variants.to_words().first().unwrap().to_string(),
            Script::Simplified => entry.variants_simp.first().unwrap().to_string(),
        };
        let defs = entry.defs.first().unwrap();
        let def = if is_eng_def {
            defs.eng
                .as_ref()
                .map(|c| clause_to_string(c))
                .unwrap_or("".to_string())
        } else {
            match script {
                Script::Traditional => clause_to_string(&defs.yue),
                Script::Simplified => clause_to_string(&defs.yue_simp),
            }
        };
        EntrySummary { variant, def }
    }).collect();
    Ok(summaries)
}

pub fn update_pr_indices(pr_indices: Vec<u8>) -> Result<()> {
    (*API.lock()).update_pr_indices(pr_indices)
}

pub fn generate_pr_indices(romanization: Romanization) -> Result<Vec<u8>> {
    // info!("api.rs generate_pr_indices");
    Ok((*API.lock()).generate_pr_indices(romanization))
}

pub fn pr_search(
    capacity: u32,
    query: String,
    script: Script,
    romanization: Romanization,
) -> Result<Vec<PrSearchResult>> {
    Ok((*API.lock()).pr_search(capacity, query, script, romanization))
}

pub fn variant_search(
    capacity: u32,
    query: String,
    script: Script,
) -> Result<Vec<VariantSearchResult>> {
    Ok((*API.lock()).variant_search(capacity, query, script))
}

pub fn combined_search(
    capacity: u32,
    query: String,
    script: Script,
    romanization: Romanization,
) -> Result<CombinedSearchResults> {
    Ok((*API.lock()).combined_search(capacity, query, script, romanization))
}

pub fn english_search(
    capacity: u32,
    query: String,
    script: Script,
) -> Result<Vec<EnglishSearchResult>> {
    Ok((*API.lock()).english_search(capacity, query, script))
}

pub fn eg_search(
    capacity: u32,
    max_eg_length: u32,
    query: String,
    script: Script,
) -> Result<(Option<String>, Vec<EgSearchResult>)> {
    Ok((*API.lock()).eg_search(capacity, max_eg_length, query, script))
}

pub fn get_entry_json(id: u32) -> Result<String> {
    Ok((*API.lock()).get_entry_json(id as usize))
}

pub fn get_entry_group_json(id: u32) -> Result<Vec<String>> {
    Ok((*API.lock()).get_entry_group_json(id as usize))
}

pub fn get_entry_id(query: String, script: Script) -> Option<u32> {
    (*API.lock()).get_entry_id(query, script)
}

pub fn get_jyutping(query: String) -> Vec<String> {
    (*API.lock()).get_jyutping(query)
}
