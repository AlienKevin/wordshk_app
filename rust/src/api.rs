use wordshk_tools::dict::{LaxJyutPing};
use wordshk_tools::parse::{parse_dict, parse_pr};
use wordshk_tools::rich_dict::{enrich_dict, RichDict};
use wordshk_tools::lean_rich_dict::{to_lean_rich_entry};
use wordshk_tools::search;
use chrono::{DateTime, Utc};
use flate2::read::GzDecoder;
use reqwest;
use serde::{Deserialize, Serialize};
use std::fs;
use std::io::prelude::*;
use std::path::Path;
use parking_lot::Mutex;
use lazy_static::lazy_static;
use anyhow::{anyhow, Result};
// use oslog::{OsLogger};
// use log::{LevelFilter, info};

#[derive(Serialize, Deserialize)]
struct Api {
    pub dict: RichDict,
    pub release_time: DateTime<Utc>,
}

fn serialize_api<P: AsRef<Path>>(output_path: &P, api: &Api) {
    // info!("Serializing Api struct as json...");
    let json = serde_json::to_string(&api).unwrap();
    // info!("Serialized Api as json!");
    fs::write(output_path, json)
        .expect("Unable to output serailized RichDict");
    // info!("Wrote json to app dir");
}

fn deserialize_api<P: AsRef<Path>>(input_path: &P) -> Option<Api> {
    match fs::read_to_string(input_path) {
        Ok(json) => match serde_json::from_str(&json) {
            Ok(api) => Some(api),
            Err(_) => None,
        },
        Err(_) => None,
    }
}

impl Api {
    pub fn new(app_dir: String) -> Self {
        // if !*IS_LOG_INITIALIZED.lock() {
        //     OsLogger::new("hk.words")
        //         .level_filter(LevelFilter::Debug)
        //         .category_level_filter("Settings", LevelFilter::Trace)
        //         .init()
        //         .unwrap();
        //     *IS_LOG_INITIALIZED.lock() = true;
        // }
        // info!("Calling Api::new()...");
        let api_path = Path::new(&app_dir).join("api.json");
        // info!("Api path is at: {:?}", api_path);
        let current_time = Utc::now();
        match deserialize_api(&api_path) {
            Some(api) => {
                if current_time
                    .signed_duration_since(api.release_time)
                    .num_weeks()
                    > 1
                {
                    Api::get_new_dict(&api_path)
                } else {
                    api
                }
            }
            None => Api::get_new_dict(&api_path),
        }
    }

    pub fn pr_search(&self, capacity: u32, query: &str) -> Vec<PrSearchResult> {
        pr_search_helper(capacity, &self.dict, &parse_pr(query))
    }

    pub fn variant_search(&self, capacity: u32, query: &str) -> Vec<VariantSearchResult> {
        variant_search_helper(capacity, &self.dict, query)
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

    fn get_new_dict<P: AsRef<Path>>(api_path: &P) -> Api {
        // info!("Calling Api::get_new_dict()...");
        let new_release_time = Utc::now();
        let csv_url = "https://words.hk/static/all.csv.gz";
        let csv_gz_data = reqwest::blocking::get(csv_url).unwrap().bytes().unwrap();
        // info!("Downloaded CSV data");
        let mut gz = GzDecoder::new(&csv_gz_data[..]);
        let mut csv_data = String::new();
        gz.read_to_string(&mut csv_data).unwrap();
        // info!("Decompressed CSV data");
        let csv_data_remove_first_line = csv_data.get(csv_data.find('\n').unwrap() + 1..).unwrap();
        let csv_data_remove_two_lines = csv_data_remove_first_line
            .get(csv_data_remove_first_line.find('\n').unwrap() + 1..)
            .unwrap();
        // info!("Cleaned CSV data");
        let dict = parse_dict(csv_data_remove_two_lines.as_bytes()).unwrap();
        // info!("Parsed CSV data");
        // // info!("{:?}", dict.get(&(89331 as usize)).unwrap());
        let new_api = Api {
            dict: enrich_dict(&dict),
            release_time: new_release_time,
        };
        // info!("Created Api struct");
        serialize_api(api_path, &new_api);
        // info!("Serialized api data");
        new_api
    }
}

pub struct PrSearchResult {
    pub id: u32,
    pub variant: String,
    pub pr: String,
}

fn pr_search_helper(capacity: u32, dict: &RichDict, query: &LaxJyutPing) -> Vec<PrSearchResult> {
    let mut ranks = search::pr_search(dict, query);
    let mut results = vec![];
    let mut i = 0;
    while ranks.len() > 0 && i < capacity {
        let search::PrSearchRank {
            id,
            variant_index,
            pr_index,
            ..
        } = ranks.pop().unwrap();
        let entry = dict.get(&id).unwrap();
        let variant = &entry.variants.0[variant_index];
        results.push(PrSearchResult {
            id: id as u32,
            variant: variant.word.clone(),
            pr: variant.prs.0[pr_index].to_string(),
        });
        i += 1;
    }
    results
}

pub struct VariantSearchResult {
    pub id: u32,
    pub variant: String,
}

fn variant_search_helper(
    capacity: u32,
    dict: &RichDict,
    query: &str,
) -> Vec<VariantSearchResult> {
    let mut ranks = search::variant_search(dict, query);
    let mut results = vec![];
    let mut i = 0;
    while ranks.len() > 0 && i < capacity {
        let search::VariantSearchRank {
            id, variant_index, ..
        } = ranks.pop().unwrap();
        let entry = dict.get(&id).unwrap();
        let variant = &entry.variants.0[variant_index];
        results.push(VariantSearchResult {
            id: id as u32,
            variant: variant.word.clone(),
        });
        i += 1;
    }
    results
}

lazy_static! {
    static ref API: Mutex<Option<Api>> = Mutex::new(None);
    static ref APP_DIR: Mutex<Option<String>> = Mutex::new(None);
    static ref IS_LOG_INITIALIZED: Mutex<bool> = Mutex::new(false);
}

pub fn init_api(input_app_dir: String) -> Result<()> {
    // info!("Calling init_api()...");
    *APP_DIR.lock() = Some(input_app_dir.clone());
    *API.lock() = Some(Api::new(input_app_dir));
    Ok(())
}

pub fn pr_search(capacity: u32, query: String) -> Result<Vec<PrSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().pr_search(capacity, &query))
}

pub fn variant_search(capacity: u32, query: String) -> Result<Vec<VariantSearchResult>> {
    Ok((*API.lock()).as_ref().unwrap().variant_search(capacity, &query))
}

pub fn get_entry_json(id: u32) -> Result<String> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_json(id as usize))
}

pub fn get_entry_group_json(id: u32) -> Result<Vec<String>> {
    Ok((*API.lock()).as_ref().unwrap().get_entry_group_json(id as usize))
}
