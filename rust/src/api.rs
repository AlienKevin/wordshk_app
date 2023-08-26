use anyhow::Result;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use parking_lot::Mutex;
pub use wordshk_tools::jyutping::Romanization;
pub use wordshk_tools::search::Script;

use crate::util::*;

// use oslog::{OsLogger};
// use log::{LevelFilter, info};

pub struct CombinedSearchResults {
    pub variant_results: Vec<VariantSearchResult>,
    pub pr_results: Vec<PrSearchResult>,
    pub english_results: Vec<EnglishSearchResult>
}

#[frb(mirror(Script))]
pub enum _Script {
    Simplified,
    Traditional,
}

#[frb(mirror(Romanization))]
pub enum _Romanization {
    Jyutping,
    YaleNumbers,
    YaleDiacritics,
    CantonesePinyin,
    Guangdong,
    SidneyLau,
    Ipa,
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

lazy_static! {
    static ref API: Mutex<Option<Api>> = Mutex::new(None);
    static ref IS_LOG_INITIALIZED: Mutex<bool> = Mutex::new(false);
}

pub fn init_api(api_json: Vec<u8>, english_index_json: Vec<u8>, word_list: String) -> Result<()> {
    // info!("Calling init_api()...");
    *API.lock() = Some(Api::new(api_json, english_index_json, word_list));
    Ok(())
}

pub fn pr_search(capacity: u32, query: String, script: Script, romanization: Romanization) -> Result<Vec<PrSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().pr_search(capacity, query, script, romanization))
}

pub fn variant_search(capacity: u32, query: String, script: Script) -> Result<Vec<VariantSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().variant_search(capacity, query, script))
}

pub fn combined_search(capacity: u32, query: String, script: Script, romanization: Romanization) -> Result<CombinedSearchResults> {
    Ok((*API.lock()).as_ref().unwrap().combined_search(capacity, query, script, romanization))
}

pub fn english_search(capacity: u32, query: String, script: Script) -> Result<Vec<EnglishSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().english_search(capacity, query, script))
}

pub fn get_entry_json(id: u32) -> Result<String> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_json(id as usize))
}

pub fn get_entry_group_json(id: u32) -> Result<Vec<String>> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_group_json(id as usize))
}

pub fn get_entry_id(query: String, script: Script) -> Option<u32> {
    (*API.lock()).as_ref().unwrap().get_entry_id(query, script)
}

pub fn get_jyutping(query: String) -> Vec<String> {
    (*API.lock()).as_ref().unwrap().get_jyutping(query)
}
