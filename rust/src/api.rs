use wordshk_tools::dict::{LaxJyutPing};
use wordshk_tools::parse::{parse_dict, parse_pr};
use wordshk_tools::rich_dict::{enrich_dict, RichDict};
use wordshk_tools::lean_rich_dict::{to_lean_rich_entry};
use wordshk_tools::search;
use chrono::{DateTime, Utc};
use flate2::read::GzDecoder;
use reqwest;
use serde::{Deserialize, Serialize};
use std::{fs, thread};
use std::io::prelude::*;
use std::path::Path;
use parking_lot::Mutex;
use lazy_static::lazy_static;
use anyhow::{anyhow, Result};
use rayon::prelude::*;
// use oslog::{OsLogger};
// use log::{LevelFilter, info};

#[derive(Serialize, Deserialize)]
struct Api {
    pub dict: RichDict,
    #[serde(skip)]
    pub variants_map: search::VariantsMap,
    pub release_time: DateTime<Utc>,
}

pub struct CombinedSearchResults {
    pub pr_search_results: Vec<PrSearchResult>,
    pub variant_search_results: Vec<VariantSearchResult>,
}

impl Api {
    pub fn new(json: String) -> Self {
        // if !*IS_LOG_INITIALIZED.lock() {
        //     OsLogger::new("hk.words")
        //         .level_filter(LevelFilter::Debug)
        //         .category_level_filter("Settings", LevelFilter::Trace)
        //         .init()
        //         .unwrap();
        //     *IS_LOG_INITIALIZED.lock() = true;
        // }
        // info!("Calling Api::new()...");
        let mut api: Api = serde_json::from_str(&json).unwrap();
        api.variants_map = search::rich_dict_to_variants_map(&api.dict);
        api
    }

    pub fn pr_search(&self, capacity: u32, query: &str) -> Vec<PrSearchResult> {
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
            let variant = &self.variants_map.get(&id).unwrap().0[variant_index];
            results.push(PrSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[pr_index].to_string(),
            });
            i += 1;
        }
        results
    }

    pub fn variant_search(&self, capacity: u32, query: &str) -> Vec<VariantSearchResult> {
        let mut ranks = search::variant_search(&self.variants_map, query);
        let mut results = vec![];
        let mut i = 0;
        while ranks.len() > 0 && i < capacity {
            let search::VariantSearchRank {
                id, variant_index, ..
            } = ranks.pop().unwrap();
            let variant = &self.variants_map.get(&id).unwrap().0[variant_index];
            results.push(VariantSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
            });
            i += 1;
        }
        results
    }

    pub fn combined_search(&self, capacity: u32, query: &str) -> CombinedSearchResults {
        let (mut variant_ranks, mut pr_ranks) = search::combined_search(&self.variants_map, query);
        let mut variant_search_results = vec![];
        let mut pr_search_results = vec![];
        let mut i = 0;
        while variant_ranks.len() > 0 && i < capacity {
            let search::VariantSearchRank {
                id, variant_index, ..
            } = variant_ranks.pop().unwrap();
            let variant = &self.variants_map.get(&id).unwrap().0[variant_index];
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
            let variant = &self.variants_map.get(&id).unwrap().0[variant_index];
            pr_search_results.push(PrSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[pr_index].to_string(),
            });
            i += 1;
        }
        CombinedSearchResults { variant_search_results, pr_search_results }
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

    pub fn get_entry_id(&self, query: &str) -> Option<u32> {
        search::get_entry_id(&self.variants_map, query).map(|id| id as u32)
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

lazy_static! {
    static ref API: Mutex<Option<Api>> = Mutex::new(None);
    static ref IS_LOG_INITIALIZED: Mutex<bool> = Mutex::new(false);
}

pub fn init_api(json: String) -> Result<()> {
    // info!("Calling init_api()...");
    *API.lock() = Some(Api::new(json));
    Ok(())
}

pub fn pr_search(capacity: u32, query: String) -> Result<Vec<PrSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().pr_search(capacity, &query))
}

pub fn variant_search(capacity: u32, query: String) -> Result<Vec<VariantSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().variant_search(capacity, &query))
}

pub fn combined_search(capacity: u32, query: String) -> Result<CombinedSearchResults> {
    Ok((*API.lock()).as_ref().unwrap().combined_search(capacity, &query))
}

pub fn get_entry_json(id: u32) -> Result<String> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_json(id as usize))
}

pub fn get_entry_group_json(id: u32) -> Result<Vec<String>> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_group_json(id as usize))
}

pub fn get_entry_id(query: String) -> Option<u32> {
    (*API.lock()).as_ref().unwrap().get_entry_id(&query)
}
