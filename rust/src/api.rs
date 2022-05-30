use wordshk_tools::rich_dict::{RichDict};
use wordshk_tools::lean_rich_dict::{to_lean_rich_entry};
use wordshk_tools::search;
pub use wordshk_tools::search::Script;
use wordshk_tools::english_index::EnglishIndex;
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use parking_lot::Mutex;
use lazy_static::lazy_static;
use anyhow::{Result};
use flutter_rust_bridge::frb;
use wordshk_tools::dict::clause_to_string;
// use oslog::{OsLogger};
// use log::{LevelFilter, info};

#[derive(Serialize, Deserialize)]
struct Api {
    pub dict: RichDict,
    #[serde(skip)]
    pub english_index: EnglishIndex,
    #[serde(skip)]
    pub variants_map: search::VariantsMap,
    pub release_time: DateTime<Utc>,
}

pub struct CombinedSearchResults {
    pub pr_search_results: Vec<PrSearchResult>,
    pub variant_search_results: Vec<VariantSearchResult>,
}

#[frb(mirror(Script))]
pub enum _Script {
    Simplified,
    Traditional,
}

impl Api {
    pub fn new(api_json: String, english_index_json: String) -> Self {
        // if !*IS_LOG_INITIALIZED.lock() {
        //     OsLogger::new("hk.words")
        //         .level_filter(LevelFilter::Debug)
        //         .category_level_filter("Settings", LevelFilter::Trace)
        //         .init()
        //         .unwrap();
        //     *IS_LOG_INITIALIZED.lock() = true;
        // }
        // info!("Calling Api::new()...");
        let mut api: Api = serde_json::from_str(&api_json).unwrap();
        api.variants_map = search::rich_dict_to_variants_map(&api.dict);
        let english_index: EnglishIndex = serde_json::from_str(&english_index_json).unwrap();
        api.english_index = english_index;
        api
    }

    pub fn pr_search(&self, capacity: u32, query: &str, script: Script) -> Vec<PrSearchResult> {
        let mut results = vec![];
        let mut ranks = search::pr_search(&self.variants_map, query);
        let mut i = 0;
        while ranks.len() > 0 && i < capacity {
            let search::PrSearchRank {
                id,
                variant_index,
                pr_index,
                ..
            } = ranks.pop().unwrap();
            let variant = &search::pick_variants(self.variants_map.get(&id).unwrap(), script).0[variant_index];
            results.push(PrSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[pr_index].to_string(),
            });
            i += 1;
        }
        results
    }

    pub fn variant_search(&self, capacity: u32, query: &str, script: Script) -> Vec<VariantSearchResult> {
        let mut ranks = search::variant_search(&self.variants_map, query, script);
        let mut results = vec![];
        let mut i = 0;
        while ranks.len() > 0 && i < capacity {
            let search::VariantSearchRank {
                id, variant_index, ..
            } = ranks.pop().unwrap();
            let variant = &search::pick_variants(self.variants_map.get(&id).unwrap(), script).0[variant_index];
            results.push(VariantSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
            });
            i += 1;
        }
        results
    }

    pub fn combined_search(&self, capacity: u32, query: &str, script: Script) -> CombinedSearchResults {
        let (mut variant_ranks, mut pr_ranks) =
            search::combined_search(&self.variants_map, query, script);
        let mut variant_search_results = vec![];
        let mut pr_search_results = vec![];
        let mut i = 0;
        while variant_ranks.len() > 0 && i < capacity {
            let search::VariantSearchRank {
                id, variant_index, ..
            } = variant_ranks.pop().unwrap();
            let variant = &search::pick_variants(self.variants_map.get(&id).unwrap(), script).0[variant_index];
            variant_search_results.push(VariantSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
            });
            i += 1;
        }
        i = 0;
        while pr_ranks.len() > 0 && i < capacity {
            let search::PrSearchRank {
                id, variant_index, pr_index, ..
            } = pr_ranks.pop().unwrap();
            let variant = &search::pick_variants(self.variants_map.get(&id).unwrap(), script).0[variant_index];
            pr_search_results.push(PrSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[pr_index].to_string(),
            });
            i += 1;
        }
        CombinedSearchResults { variant_search_results, pr_search_results }
    }

    pub fn english_search(&self, capacity: u32, query: &str, script: Script) -> Vec<EnglishSearchResult> {
        let entries = search::english_search(&self.english_index, query);
        entries[..std::cmp::min(capacity as usize, entries.len())]
            .iter()
            .map(|entry| {
                let variant = &search::pick_variants(&self.variants_map.get(&entry.entry_id).unwrap(), script).0[0];
                EnglishSearchResult {
                    id: entry.entry_id as u32,
                    variant: variant.word.clone(),
                    pr: variant.prs.0[0].to_string(),
                    eng: clause_to_string(
                        &self.dict.get(&entry.entry_id).unwrap().defs[entry.def_index]
                            .eng
                            .as_ref()
                            .unwrap(),
                    ),
                }
            })
            .collect()
    }

    pub fn get_entry_json(&self, id: usize) -> String {
        let rich_entry = self.dict.get(&id).unwrap();
        serde_json::to_string(&to_lean_rich_entry(rich_entry)).unwrap()
    }

    pub fn get_entry_group_json(&self, id: usize) -> Vec<String> {
        let rich_entry_group = search::get_entry_group(&self.dict, &id);
        rich_entry_group
            .iter()
            .map(|entry| serde_json::to_string(&to_lean_rich_entry(entry)).unwrap())
            .collect()
    }

    pub fn get_entry_id(&self, query: &str, script: Script) -> Option<u32> {
        search::get_entry_id(&self.variants_map, query, script).map(|id| id as u32)
    }
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
    pub variant: String,
    pub pr: String,
    pub eng: String,
}

lazy_static! {
    static ref API: Mutex<Option<Api>> = Mutex::new(None);
    static ref IS_LOG_INITIALIZED: Mutex<bool> = Mutex::new(false);
}

pub fn init_api(api_json: String, english_index_json: String) -> Result<()> {
    // info!("Calling init_api()...");
    *API.lock() = Some(Api::new(api_json, english_index_json));
    Ok(())
}

pub fn pr_search(capacity: u32, query: String, script: Script) -> Result<Vec<PrSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().pr_search(capacity, &query, script))
}

pub fn variant_search(capacity: u32, query: String, script: Script) -> Result<Vec<VariantSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().variant_search(capacity, &query, script))
}

pub fn combined_search(capacity: u32, query: String, script: Script) -> Result<CombinedSearchResults> {
    Ok((*API.lock()).as_ref().unwrap().combined_search(capacity, &query, script))
}

pub fn english_search(capacity: u32, query: String, script: Script) -> Result<Vec<EnglishSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().english_search(capacity, &query, script))
}

pub fn get_entry_json(id: u32) -> Result<String> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_json(id as usize))
}

pub fn get_entry_group_json(id: u32) -> Result<Vec<String>> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_group_json(id as usize))
}

pub fn get_entry_id(query: String, script: Script) -> Option<u32> {
    (*API.lock()).as_ref().unwrap().get_entry_id(&query, script)
}
