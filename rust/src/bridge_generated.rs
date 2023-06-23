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
// Generated by `flutter_rust_bridge`@ 1.78.0.

use core::panic::UnwindSafe;
use std::ffi::c_void;
use std::sync::Arc;

use flutter_rust_bridge::*;

#[cfg(not(target_family = "wasm"))]
pub use io::*;

use crate::api::*;

// Section: imports

// Section: wire functions

fn wire_init_api_impl(
    port_: MessagePort,
    api_json: impl Wire2Api<String> + UnwindSafe,
    english_index_json: impl Wire2Api<String> + UnwindSafe,
    word_list: impl Wire2Api<String> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "init_api",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_api_json = api_json.wire2api();
            let api_english_index_json = english_index_json.wire2api();
            let api_word_list = word_list.wire2api();
            move |task_callback| init_api(api_api_json, api_english_index_json, api_word_list)
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
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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
fn wire_get_entry_json_impl(port_: MessagePort, id: impl Wire2Api<u32> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
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

impl Wire2Api<i32> for i32 {
    fn wire2api(self) -> i32 {
        self
    }
}
impl Wire2Api<Romanization> for i32 {
    fn wire2api(self) -> Romanization {
        match self {
            0 => Romanization::Jyutping,
            1 => Romanization::YaleNumbers,
            2 => Romanization::YaleDiacritics,
            3 => Romanization::CantonesePinyin,
            4 => Romanization::Guangdong,
            5 => Romanization::SidneyLau,
            6 => Romanization::Ipa,
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
            self.variant_results.into_dart(),
            self.pr_results.into_dart(),
            self.english_results.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for CombinedSearchResults {}

impl support::IntoDart for EnglishSearchResult {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_dart(),
            self.def_index.into_dart(),
            self.variant.into_dart(),
            self.pr.into_dart(),
            self.eng.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for EnglishSearchResult {}

impl support::IntoDart for PrSearchResult {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_dart(),
            self.variant.into_dart(),
            self.pr.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for PrSearchResult {}

impl support::IntoDart for VariantSearchResult {
    fn into_dart(self) -> support::DartAbi {
        vec![self.id.into_dart(), self.variant.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for VariantSearchResult {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
