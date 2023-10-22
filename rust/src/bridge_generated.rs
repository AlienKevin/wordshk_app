#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.80.1.

use core::panic::UnwindSafe;
use std::ffi::c_void;
use std::sync::Arc;

use flutter_rust_bridge::*;
use flutter_rust_bridge::rust2dart::IntoIntoDart;

#[cfg(not(target_family = "wasm"))]
pub use io::*;

use crate::api::*;

// Section: imports

// Section: wire functions

fn wire_get_entry_summaries_impl(
    port_: MessagePort,
    entry_ids: impl Wire2Api<Vec<u32>> + UnwindSafe,
    script: impl Wire2Api<Script> + UnwindSafe,
    is_eng_def: impl Wire2Api<bool> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<EntrySummary>>(
        WrapInfo {
            debug_name: "get_entry_summaries",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_entry_ids = entry_ids.wire2api();
            let api_script = script.wire2api();
            let api_is_eng_def = is_eng_def.wire2api();
            move |task_callback| get_entry_summaries(api_entry_ids, api_script, api_is_eng_def)
        },
    )
}
fn wire_update_pr_indices_impl(
    port_: MessagePort,
    pr_indices: impl Wire2Api<Vec<u8>> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, ()>(
        WrapInfo {
            debug_name: "update_pr_indices",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_pr_indices = pr_indices.wire2api();
            move |task_callback| update_pr_indices(api_pr_indices)
        },
    )
}
fn wire_generate_pr_indices_impl(
    port_: MessagePort,
    romanization: impl Wire2Api<Romanization> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<u8>>(
        WrapInfo {
            debug_name: "generate_pr_indices",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_romanization = romanization.wire2api();
            move |task_callback| generate_pr_indices(api_romanization)
        },
    )
}
fn wire_pr_search_impl(
    port_: MessagePort,
    capacity: impl Wire2Api<u32> + UnwindSafe,
    query: impl Wire2Api<String> + UnwindSafe,
    script: impl Wire2Api<Script> + UnwindSafe,
    romanization: impl Wire2Api<Romanization> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<PrSearchResult>>(
        WrapInfo {
            debug_name: "pr_search",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_capacity = capacity.wire2api();
            let api_query = query.wire2api();
            let api_script = script.wire2api();
            let api_romanization = romanization.wire2api();
            move |task_callback| pr_search(api_capacity, api_query, api_script, api_romanization)
        },
    )
}
fn wire_variant_search_impl(
    port_: MessagePort,
    capacity: impl Wire2Api<u32> + UnwindSafe,
    query: impl Wire2Api<String> + UnwindSafe,
    script: impl Wire2Api<Script> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<VariantSearchResult>>(
        WrapInfo {
            debug_name: "variant_search",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_capacity = capacity.wire2api();
            let api_query = query.wire2api();
            let api_script = script.wire2api();
            move |task_callback| variant_search(api_capacity, api_query, api_script)
        },
    )
}
fn wire_combined_search_impl(
    port_: MessagePort,
    capacity: impl Wire2Api<u32> + UnwindSafe,
    query: impl Wire2Api<String> + UnwindSafe,
    script: impl Wire2Api<Script> + UnwindSafe,
    romanization: impl Wire2Api<Romanization> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, CombinedSearchResults>(
        WrapInfo {
            debug_name: "combined_search",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_capacity = capacity.wire2api();
            let api_query = query.wire2api();
            let api_script = script.wire2api();
            let api_romanization = romanization.wire2api();
            move |task_callback| {
                combined_search(api_capacity, api_query, api_script, api_romanization)
            }
        },
    )
}
fn wire_english_search_impl(
    port_: MessagePort,
    capacity: impl Wire2Api<u32> + UnwindSafe,
    query: impl Wire2Api<String> + UnwindSafe,
    script: impl Wire2Api<Script> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<EnglishSearchResult>>(
        WrapInfo {
            debug_name: "english_search",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_capacity = capacity.wire2api();
            let api_query = query.wire2api();
            let api_script = script.wire2api();
            move |task_callback| english_search(api_capacity, api_query, api_script)
        },
    )
}
fn wire_eg_search_impl(
    port_: MessagePort,
    capacity: impl Wire2Api<u32> + UnwindSafe,
    max_first_index_in_eg: impl Wire2Api<u32> + UnwindSafe,
    query: impl Wire2Api<String> + UnwindSafe,
    script: impl Wire2Api<Script> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, (Option<String>, Vec<EgSearchResult>)>(
        WrapInfo {
            debug_name: "eg_search",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_capacity = capacity.wire2api();
            let api_max_first_index_in_eg = max_first_index_in_eg.wire2api();
            let api_query = query.wire2api();
            let api_script = script.wire2api();
            move |task_callback| {
                eg_search(
                    api_capacity,
                    api_max_first_index_in_eg,
                    api_query,
                    api_script,
                )
            }
        },
    )
}
fn wire_get_entry_json_impl(port_: MessagePort, id: impl Wire2Api<u32> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, String>(
        WrapInfo {
            debug_name: "get_entry_json",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_id = id.wire2api();
            move |task_callback| get_entry_json(api_id)
        },
    )
}
fn wire_get_entry_group_json_impl(port_: MessagePort, id: impl Wire2Api<u32> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<String>>(
        WrapInfo {
            debug_name: "get_entry_group_json",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_id = id.wire2api();
            move |task_callback| get_entry_group_json(api_id)
        },
    )
}
fn wire_get_entry_id_impl(
    port_: MessagePort,
    query: impl Wire2Api<String> + UnwindSafe,
    script: impl Wire2Api<Script> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Option<u32>>(
        WrapInfo {
            debug_name: "get_entry_id",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_query = query.wire2api();
            let api_script = script.wire2api();
            move |task_callback| Ok(get_entry_id(api_query, api_script))
        },
    )
}
fn wire_get_jyutping_impl(port_: MessagePort, query: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<String>>(
        WrapInfo {
            debug_name: "get_jyutping",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_query = query.wire2api();
            move |task_callback| Ok(get_jyutping(api_query))
        },
    )
}
fn wire_get_splotlight_summaries_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<SpotlightEntrySummary>>(
        WrapInfo {
            debug_name: "get_splotlight_summaries",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| Ok(get_splotlight_summaries()),
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<bool> for bool {
    fn wire2api(self) -> bool {
        self
    }
}
impl Wire2Api<i32> for i32 {
    fn wire2api(self) -> i32 {
        self
    }
}
impl Wire2Api<Romanization> for i32 {
    fn wire2api(self) -> Romanization {
        match self {
            0 => Romanization::Jyutping,
            1 => Romanization::Yale,
            _ => unreachable!("Invalid variant for Romanization: {}", self),
        }
    }
}
impl Wire2Api<Script> for i32 {
    fn wire2api(self) -> Script {
        match self {
            0 => Script::Simplified,
            1 => Script::Traditional,
            _ => unreachable!("Invalid variant for Script: {}", self),
        }
    }
}
impl Wire2Api<u32> for u32 {
    fn wire2api(self) -> u32 {
        self
    }
}
impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for CombinedSearchResults {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.variant_results.into_into_dart().into_dart(),
            self.pr_results.into_into_dart().into_dart(),
            self.english_results.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for CombinedSearchResults {}
impl rust2dart::IntoIntoDart<CombinedSearchResults> for CombinedSearchResults {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for EgSearchResult {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.def_index.into_into_dart().into_dart(),
            self.eg_index.into_into_dart().into_dart(),
            self.eg.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for EgSearchResult {}
impl rust2dart::IntoIntoDart<EgSearchResult> for EgSearchResult {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for EnglishSearchResult {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.def_index.into_into_dart().into_dart(),
            self.variant.into_into_dart().into_dart(),
            self.pr.into_into_dart().into_dart(),
            self.eng.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for EnglishSearchResult {}
impl rust2dart::IntoIntoDart<EnglishSearchResult> for EnglishSearchResult {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for EntrySummary {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.variant.into_into_dart().into_dart(),
            self.def.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for EntrySummary {}
impl rust2dart::IntoIntoDart<EntrySummary> for EntrySummary {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for PrSearchResult {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.variant.into_into_dart().into_dart(),
            self.pr.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for PrSearchResult {}
impl rust2dart::IntoIntoDart<PrSearchResult> for PrSearchResult {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for SpotlightEntrySummary {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.variants.into_into_dart().into_dart(),
            self.variants_simp.into_into_dart().into_dart(),
            self.jyutpings.into_into_dart().into_dart(),
            self.yales.into_into_dart().into_dart(),
            self.def.into_into_dart().into_dart(),
            self.def_simp.into_into_dart().into_dart(),
            self.def_en.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for SpotlightEntrySummary {}
impl rust2dart::IntoIntoDart<SpotlightEntrySummary> for SpotlightEntrySummary {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for VariantSearchResult {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.variant.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for VariantSearchResult {}
impl rust2dart::IntoIntoDart<VariantSearchResult> for VariantSearchResult {
    fn into_into_dart(self) -> Self {
        self
    }
}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
