use std::collections::BinaryHeap;

use wordshk_tools::dict::clause_to_string;
use wordshk_tools::english_index::EnglishIndexData;
use wordshk_tools::rich_dict::RichDict;
use wordshk_tools::search;
use wordshk_tools::search::{Script, VariantsMap};

use crate::api::{EnglishSearchResult, PrSearchResult, VariantSearchResult};

pub(crate) fn pr_ranks_to_results(pr_ranks: &mut BinaryHeap<search::PrSearchRank>, variants_map: &VariantsMap, dict: &RichDict, script: Script, capacity: u32) -> Vec<PrSearchResult> {
    let mut pr_search_results = vec![];
    let mut i = 0;
    while pr_ranks.len() > 0 && i < capacity {
        let search::PrSearchRank {
            id, variant_index, pr_index, ..
        } = pr_ranks.pop().unwrap();
        let variant = &search::pick_variants(variants_map.get(&id).unwrap(), script).0[variant_index];
        let defs = get_entry_defs(id, dict, script);
        let (yues, engs) = defs.into_iter().unzip();
        pr_search_results.push(PrSearchResult {
            id: id as u32,
            variant: variant.word.clone(),
            pr: variant.prs.0[pr_index].to_string(),
            yues,
            engs,
        });
        i += 1;
    }
    pr_search_results
}

pub(crate) fn variant_ranks_to_results(variant_ranks: &mut BinaryHeap<search::VariantSearchRank>, variants_map: &VariantsMap, dict: &RichDict, script: Script, capacity: u32) -> Vec<VariantSearchResult> {
    let mut variant_search_results = vec![];
    let mut i = 0;
    while variant_ranks.len() > 0 && i < capacity {
        let search::VariantSearchRank {
            id, variant_index, ..
        } = variant_ranks.pop().unwrap();
        let variant = &search::pick_variants(variants_map.get(&id).unwrap(), script).0[variant_index];
        let defs = get_entry_defs(id, dict, script);
        let (yues, engs) = defs.into_iter().unzip();
        variant_search_results.push(VariantSearchResult {
            id: id as u32,
            variant: variant.word.clone(),
            yues,
            engs,
        });
        i += 1;
    }
    variant_search_results
}

pub(crate) fn get_entry_defs(id: usize, dict: &RichDict, script: Script) -> Vec<(String, String)> {
    let defs = &dict.get(&id).unwrap().defs;
    defs.iter().filter_map(|def|
        def.eng.as_ref().map(|def| clause_to_string(def)).map(|eng|
            (clause_to_string(match script {
                Script::Simplified => &def.yue_simp,
                Script::Traditional => &def.yue, }),
             eng,
            )
        )).collect()
}

pub(crate) fn english_ranks_to_results(english_ranks: &Vec<EnglishIndexData>, dict: &RichDict, variants_map: &VariantsMap, script: Script, capacity: u32) -> Vec<EnglishSearchResult> {
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
