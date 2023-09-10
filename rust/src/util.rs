use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::io::prelude::*;
use std::io::Read;

use anyhow::Result;
use flate2::Compression;
use flate2::read::GzDecoder;
use flate2::write::GzEncoder;
use lazy_static::lazy_static;
use parking_lot::Mutex;
use rmp_serde::Serializer;
use serde::{Deserialize, Serialize};
use wordshk_tools::dict::clause_to_string;
use wordshk_tools::english_index::{EnglishIndex, EnglishIndexData};
pub use wordshk_tools::jyutping::Romanization;
use wordshk_tools::lean_rich_dict::to_lean_rich_entry;
use wordshk_tools::pr_index::PrIndices;
use wordshk_tools::rich_dict::RichDict;
use wordshk_tools::search;
use wordshk_tools::search::{CombinedSearchRank, Script, VariantsMap};
use wordshk_tools::unicode::is_cjk;

use crate::api::{CombinedSearchResults, EgSearchResult, EnglishSearchResult, PrSearchResult, VariantSearchResult};

// use oslog::{OsLogger};
// use log::{LevelFilter, info};

#[derive(Deserialize, Serialize)]
pub struct Api {
    pub dict: RichDict,
    #[serde(skip)]
    pub english_index: EnglishIndex,
    #[serde(skip)]
    pub pr_indices: PrIndices,
    #[serde(skip)]
    pub variants_map: VariantsMap,
    #[serde(skip)]
    pub word_list: HashMap<String, Vec<String>>,
}

lazy_static! {
    static ref IS_LOG_INITIALIZED: Mutex<bool> = Mutex::new(false);
}

impl Api {
    pub fn new() -> Self {
        // if !(*IS_LOG_INITIALIZED.lock()) {
        //     OsLogger::new("hk.words")
        //         .level_filter(LevelFilter::Debug)
        //         .category_level_filter("Settings", LevelFilter::Trace)
        //         .init()
        //         .unwrap();
        //     *IS_LOG_INITIALIZED.lock() = true;
        // }
        // info!("Calling Api::new()...");

        let api_json = include_bytes!("../data/api.json");
        let english_index_json = include_bytes!("../data/english_index.json");
        let word_list = include_str!("../data/word_list.tsv");

        let mut api_decompressor = GzDecoder::new(&api_json[..]);
        let mut api_str = String::new();
        api_decompressor.read_to_string(&mut api_str).unwrap();
        let mut api: Api = serde_json::from_str(&api_str).unwrap();

        api.variants_map = search::rich_dict_to_variants_map(&api.dict);
        // info!("Loaded dict");

        let mut english_index_decompressor = GzDecoder::new(&english_index_json[..]);
        let mut english_index_str = String::new();
        english_index_decompressor.read_to_string(&mut english_index_str).unwrap();
        let english_index: EnglishIndex = serde_json::from_str(&english_index_str).unwrap();
        api.english_index = english_index;
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
        api.word_list = word_list;
        // info!("Loaded word list");

        api
    }

    pub fn update_pr_indices(&mut self, pr_indices_msgpack: Vec<u8>) -> Result<()> {
        let mut pr_indices_decompressor = GzDecoder::new(&pr_indices_msgpack[..]);
        let mut pr_indices_bytes = Vec::new();
        pr_indices_decompressor.read_to_end(&mut pr_indices_bytes)?;
        let pr_indices: PrIndices = rmp_serde::from_slice(&pr_indices_bytes[..])?;
        self.pr_indices = pr_indices;
        Ok(())
    }

    pub fn generate_pr_indices(&mut self, romanization: Romanization) -> Vec<u8> {
        // info!("in generate_pr_indices");
        let pr_indices = wordshk_tools::pr_index::generate_pr_indices(&self.dict, romanization);
        self.pr_indices = pr_indices;

        let mut buf = Vec::new();
        self.pr_indices
            .serialize(&mut Serializer::new(&mut buf))
            .unwrap();

        let mut e = GzEncoder::new(Vec::new(), Compression::default());
        e.write_all(&buf).expect("failed to compress pr_indices");
        e.finish().expect("failed to finish compressing the stream of pr_indices")
    }

    pub fn pr_search(&self, capacity: u32, query: String, script: Script, romanization: Romanization) -> Vec<PrSearchResult> {
        let mut results = vec![];
        let mut ranks = search::pr_search(&self.pr_indices, &self.dict, &query, romanization);
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

    pub fn variant_search(&self, capacity: u32, query: String, script: Script) -> Vec<VariantSearchResult> {
        let mut ranks = search::variant_search(&self.variants_map, &query, script);
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

    pub fn combined_search(&self, capacity: u32, query: String, script: Script, romanization: Romanization) -> CombinedSearchResults {
        match &mut search::combined_search(&self.variants_map, &self.pr_indices, &self.english_index, &self.dict, &query, script, romanization) {
            CombinedSearchRank::Variant(variant_ranks) =>
                CombinedSearchResults {
                    variant_results: variant_ranks_to_results(variant_ranks, &self.variants_map, script, capacity),
                    pr_results: vec![],
                    english_results: vec![]
                },
            CombinedSearchRank::Pr(pr_ranks) =>
                CombinedSearchResults {
                    variant_results: vec![],
                    pr_results: pr_ranks_to_results(pr_ranks, &self.variants_map, script, capacity),
                    english_results: vec![]
                },
            CombinedSearchRank::All(variant_ranks, pr_ranks, english_ranks) =>
                CombinedSearchResults {
                    variant_results: variant_ranks_to_results(variant_ranks, &self.variants_map, script, capacity),
                    pr_results: pr_ranks_to_results(pr_ranks, & self.variants_map, script, capacity),
                    english_results: english_ranks_to_results(english_ranks, & self.dict, &self.variants_map, script, capacity)
                }
        }
    }

    pub fn english_search(&self, capacity: u32, query: String, script: Script) -> Vec<EnglishSearchResult> {
        let entries = search::english_search(&self.english_index, &query);
        entries[..std::cmp::min(capacity as usize, entries.len())]
            .iter()
            .map(|entry| {
                let variant = &search::pick_variants(&self.variants_map.get(&entry.entry_id).unwrap(), script).0[0];
                EnglishSearchResult {
                    id: entry.entry_id as u32,
                    def_index: entry.def_index as u32,
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

    pub fn eg_search(&self, capacity: u32, max_first_index_in_eg: u32, query: String, script: Script) -> (Option<String>, Vec<EgSearchResult>) {
        let (query_found, mut ranks) = search::eg_search(&self.dict, &query, max_first_index_in_eg as usize, script);
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
                    Script::Traditional => self.dict[&id].defs[def_index].egs[eg_index].yue.as_ref().unwrap().to_string(),
                    Script::Simplified => self.dict[&id].defs[def_index].egs[eg_index].yue_simp.as_ref().unwrap().to_string(),
                }
            });
            i += 1;
        }
        (query_found, results)
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

    pub fn get_entry_id(&self, query: String, script: Script) -> Option<u32> {
        search::get_entry_id(&self.variants_map, &query, script).map(|id| id as u32)
    }

    pub fn get_jyutping(&self, query: String) -> Vec<String> {
        let query_normalized: String =query.chars().filter(|&c| is_cjk(c)).collect();
        if query_normalized.chars().count() == 1 {
            search::get_char_jyutpings(query_normalized.chars().next().unwrap()).unwrap_or(vec![])
        } else {
            self.word_list.get(&query_normalized).unwrap_or(&vec![]).clone()
        }
    }
}


fn pr_ranks_to_results(pr_ranks: &mut BinaryHeap<search::PrSearchRank>, variants_map: &VariantsMap, script: Script, capacity: u32) -> Vec<PrSearchResult> {
    let mut pr_search_results = vec![];
    let mut i = 0;
    while pr_ranks.len() > 0 && i < capacity {
        let search::PrSearchRank {
            id, variant_index, pr_index, ..
        } = pr_ranks.pop().unwrap();
        let variant = &search::pick_variants(variants_map.get(&id).unwrap(), script).0[variant_index];
        pr_search_results.push(PrSearchResult {
            id: id as u32,
            variant: variant.word.clone(),
            pr: variant.prs.0[pr_index].to_string(),
        });
        i += 1;
    }
    pr_search_results
}

fn variant_ranks_to_results(variant_ranks: &mut BinaryHeap<search::VariantSearchRank>, variants_map: &VariantsMap, script: Script, capacity: u32) -> Vec<VariantSearchResult> {
    let mut variant_search_results = vec![];
    let mut i = 0;
    while variant_ranks.len() > 0 && i < capacity {
        let search::VariantSearchRank {
            id, variant_index, ..
        } = variant_ranks.pop().unwrap();
        let variant = &search::pick_variants(variants_map.get(&id).unwrap(), script).0[variant_index];
        variant_search_results.push(VariantSearchResult {
            id: id as u32,
            variant: variant.word.clone(),
        });
        i += 1;
    }
    variant_search_results
}

fn english_ranks_to_results(english_ranks: &Vec<EnglishIndexData>, dict: &RichDict, variants_map: &VariantsMap, script: Script, capacity: u32) -> Vec<EnglishSearchResult> {
    english_ranks[..std::cmp::min(capacity as usize, english_ranks.len())]
        .iter()
        .map(|entry| {
            let variant = &search::pick_variants(&variants_map.get(&entry.entry_id).unwrap(), script).0[0];
            EnglishSearchResult {
                id: entry.entry_id as u32,
                def_index: entry.def_index as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[0].to_string(),
                eng: clause_to_string(
                    &dict.get(&entry.entry_id).unwrap().defs[entry.def_index]
                        .eng
                        .as_ref()
                        .unwrap(),
                ),
            }
        })
        .collect()
}
