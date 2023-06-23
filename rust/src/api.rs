use std::collections::BinaryHeap;
use std::collections::HashMap;

use anyhow::Result;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use parking_lot::Mutex;
use serde::{Serialize, Deserialize, ser::SerializeStruct, Serializer, Deserializer};
use wordshk_tools::dict::clause_to_string;
use wordshk_tools::english_index::{EnglishIndex, EnglishIndexData};
pub use wordshk_tools::jyutping::Romanization;
use wordshk_tools::lean_rich_dict::to_lean_rich_entry;
use wordshk_tools::rich_dict::RichDict;
use wordshk_tools::search;
use wordshk_tools::search::{CombinedSearchRank, VariantsMap};
pub use wordshk_tools::search::Script;
use wordshk_tools::unicode::is_cjk;
use flutter_rust_bridge::RustOpaque;

// use oslog::{OsLogger};
// use log::{LevelFilter, info};

pub struct Api {
    pub dict: RustOpaque<RichDict>,
    pub english_index: RustOpaque<EnglishIndex>,
    pub variants_map: RustOpaque<search::VariantsMap>,
    pub word_list: RustOpaque<HashMap<String, Vec<String>>>,
}

// Implement `Serialize` for `Api`
impl Serialize for Api {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        let mut state = serializer.serialize_struct("Api", 1)?;
        // assuming RustOpaque<RichDict> can be serialized
        state.serialize_field("dict", &self.dict.clone().try_unwrap().unwrap())?;
        state.end()
    }
}

// Implement `Deserialize` for `Api`
impl<'de> Deserialize<'de> for Api {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        // Create a helper struct
        #[derive(Deserialize)]
        struct Fields {
            dict: RichDict,
        }

        let fields = Fields::deserialize(deserializer)?;

        Ok(Api {
            dict: RustOpaque::new(fields.dict),
            // fill in the other fields with some sensible default values
            english_index: RustOpaque::new(EnglishIndex::default()),
            variants_map: RustOpaque::new(search::VariantsMap::default()),
            word_list: RustOpaque::new(HashMap::default()),
        })
    }
}

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

impl Api {
    pub fn new(api_json: String, english_index_json: String, word_list: String) -> Api {
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
        api.variants_map = RustOpaque::new(search::rich_dict_to_variants_map(&api.dict));
        let english_index: EnglishIndex = serde_json::from_str(&english_index_json).unwrap();
        api.english_index = RustOpaque::new(english_index);
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
        api.word_list = RustOpaque::new(word_list);
        api
    }

    pub fn pr_search(&self, capacity: u32, query: String, script: Script, romanization: Romanization) -> Vec<PrSearchResult> {
        let mut results = vec![];
        let mut ranks = search::pr_search(&self.variants_map, &query, romanization);
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
        match &mut search::combined_search(&self.variants_map, &self.english_index, &query, script, romanization) {
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

pub struct PrSearchResult {
    pub id: u32,
    pub variant: String,
    pub pr: String,
}

fn pr_ranks_to_results(pr_ranks: &mut BinaryHeap<search::PrSearchRank>, variants_map: &VariantsMap, script: Script, capacity: u32) -> Vec<PrSearchResult> {
    let mut pr_search_results = vec![];
    let mut i = 0;
    while pr_ranks.len() > 0 && i < capacity {
        let search::PrSearchRank {
            id, variant_index, pr_index, score, ..
        } = pr_ranks.pop().unwrap();
        if score > 70 {
            let variant = &search::pick_variants(variants_map.get(&id).unwrap(), script).0[variant_index];
            pr_search_results.push(PrSearchResult {
                id: id as u32,
                variant: variant.word.clone(),
                pr: variant.prs.0[pr_index].to_string(),
            });
            i += 1;
        }
    }
    pr_search_results
}

pub struct VariantSearchResult {
    pub id: u32,
    pub variant: String,
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

pub struct EnglishSearchResult {
    pub id: u32,
    pub def_index: u32,
    pub variant: String,
    pub pr: String,
    pub eng: String,
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

lazy_static! {
    static ref API: Mutex<Option<Api>> = Mutex::new(None);
    static ref IS_LOG_INITIALIZED: Mutex<bool> = Mutex::new(false);
}

pub fn init_api(api_json: String, english_index_json: String, word_list: String) -> Result<()> {
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
