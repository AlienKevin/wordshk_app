#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`.

use flutter_rust_bridge::*;

use crate::api::*;

// Section: imports

// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_init_api(
    port_: i64,
    api_json: *mut wire_uint_8_list,
    english_index_json: *mut wire_uint_8_list,
    word_list: *mut wire_uint_8_list,
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

#[no_mangle]
pub extern "C" fn wire_pr_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
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
            move |task_callback| pr_search(api_capacity, api_query, api_script)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_variant_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
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

#[no_mangle]
pub extern "C" fn wire_combined_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
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
            move |task_callback| combined_search(api_capacity, api_query, api_script)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_english_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
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

#[no_mangle]
pub extern "C" fn wire_get_entry_json(port_: i64, id: u32) {
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

#[no_mangle]
pub extern "C" fn wire_get_entry_group_json(port_: i64, id: u32) {
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

#[no_mangle]
pub extern "C" fn wire_get_entry_id(port_: i64, query: *mut wire_uint_8_list, script: i32) {
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

#[no_mangle]
pub extern "C" fn wire_get_jyutping(port_: i64, query: *mut wire_uint_8_list) {
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

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: wrapper structs

// Section: static checks

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_uint_8_list(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        if self.is_null() {
            None
        } else {
            Some(self.wire2api())
        }
    }
}

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
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

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

// Section: impl IntoDart

impl support::IntoDart for CombinedSearchResults {
    fn into_dart(self) -> support::DartCObject {
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
    fn into_dart(self) -> support::DartCObject {
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
    fn into_dart(self) -> support::DartCObject {
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
    fn into_dart(self) -> support::DartCObject {
        vec![self.id.into_dart(), self.variant.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for VariantSearchResult {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturnStruct(val: support::WireSyncReturnStruct) {
    unsafe {
        let _ = support::vec_from_leak_ptr(val.ptr, val.len);
    }
}
