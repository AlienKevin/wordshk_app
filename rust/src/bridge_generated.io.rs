use super::*;
use wordshk_tools::english_index::EnglishIndex;
use std::collections::HashMap;
use wordshk_tools::search;
use wordshk_tools::rich_dict::RichDict;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_init_api(
    port_: i64,
    api_json: *mut wire_uint_8_list,
    english_index_json: *mut wire_uint_8_list,
    word_list: *mut wire_uint_8_list,
) {
    wire_init_api_impl(port_, api_json, english_index_json, word_list)
}

#[no_mangle]
pub extern "C" fn wire_pr_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
    romanization: i32,
) {
    wire_pr_search_impl(port_, capacity, query, script, romanization)
}

#[no_mangle]
pub extern "C" fn wire_variant_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
) {
    wire_variant_search_impl(port_, capacity, query, script)
}

#[no_mangle]
pub extern "C" fn wire_combined_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
    romanization: i32,
) {
    wire_combined_search_impl(port_, capacity, query, script, romanization)
}

#[no_mangle]
pub extern "C" fn wire_english_search(
    port_: i64,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
) {
    wire_english_search_impl(port_, capacity, query, script)
}

#[no_mangle]
pub extern "C" fn wire_get_entry_json(port_: i64, id: u32) {
    wire_get_entry_json_impl(port_, id)
}

#[no_mangle]
pub extern "C" fn wire_get_entry_group_json(port_: i64, id: u32) {
    wire_get_entry_group_json_impl(port_, id)
}

#[no_mangle]
pub extern "C" fn wire_get_entry_id(port_: i64, query: *mut wire_uint_8_list, script: i32) {
    wire_get_entry_id_impl(port_, query, script)
}

#[no_mangle]
pub extern "C" fn wire_get_jyutping(port_: i64, query: *mut wire_uint_8_list) {
    wire_get_jyutping_impl(port_, query)
}

#[no_mangle]
pub extern "C" fn wire_new__static_method__Api(
    port_: i64,
    api_json: *mut wire_uint_8_list,
    english_index_json: *mut wire_uint_8_list,
    word_list: *mut wire_uint_8_list,
) {
    wire_new__static_method__Api_impl(port_, api_json, english_index_json, word_list)
}

#[no_mangle]
pub extern "C" fn wire_pr_search__method__Api(
    port_: i64,
    that: *mut wire_Api,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
    romanization: i32,
) {
    wire_pr_search__method__Api_impl(port_, that, capacity, query, script, romanization)
}

#[no_mangle]
pub extern "C" fn wire_variant_search__method__Api(
    port_: i64,
    that: *mut wire_Api,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
) {
    wire_variant_search__method__Api_impl(port_, that, capacity, query, script)
}

#[no_mangle]
pub extern "C" fn wire_combined_search__method__Api(
    port_: i64,
    that: *mut wire_Api,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
    romanization: i32,
) {
    wire_combined_search__method__Api_impl(port_, that, capacity, query, script, romanization)
}

#[no_mangle]
pub extern "C" fn wire_english_search__method__Api(
    port_: i64,
    that: *mut wire_Api,
    capacity: u32,
    query: *mut wire_uint_8_list,
    script: i32,
) {
    wire_english_search__method__Api_impl(port_, that, capacity, query, script)
}

#[no_mangle]
pub extern "C" fn wire_get_entry_json__method__Api(port_: i64, that: *mut wire_Api, id: usize) {
    wire_get_entry_json__method__Api_impl(port_, that, id)
}

#[no_mangle]
pub extern "C" fn wire_get_entry_group_json__method__Api(
    port_: i64,
    that: *mut wire_Api,
    id: usize,
) {
    wire_get_entry_group_json__method__Api_impl(port_, that, id)
}

#[no_mangle]
pub extern "C" fn wire_get_entry_id__method__Api(
    port_: i64,
    that: *mut wire_Api,
    query: *mut wire_uint_8_list,
    script: i32,
) {
    wire_get_entry_id__method__Api_impl(port_, that, query, script)
}

#[no_mangle]
pub extern "C" fn wire_get_jyutping__method__Api(
    port_: i64,
    that: *mut wire_Api,
    query: *mut wire_uint_8_list,
) {
    wire_get_jyutping__method__Api_impl(port_, that, query)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_EnglishIndex() -> wire_EnglishIndex {
    wire_EnglishIndex::new_with_null_ptr()
}

#[no_mangle]
pub extern "C" fn new_HashMapStringVecString() -> wire_HashMapStringVecString {
    wire_HashMapStringVecString::new_with_null_ptr()
}

#[no_mangle]
pub extern "C" fn new_RichDict() -> wire_RichDict {
    wire_RichDict::new_with_null_ptr()
}

#[no_mangle]
pub extern "C" fn new_SearchVariantsMap() -> wire_SearchVariantsMap {
    wire_SearchVariantsMap::new_with_null_ptr()
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_api_0() -> *mut wire_Api {
    support::new_leak_box_ptr(wire_Api::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

#[no_mangle]
pub extern "C" fn drop_opaque_EnglishIndex(ptr: *const c_void) {
    unsafe {
        Arc::<EnglishIndex>::decrement_strong_count(ptr as _);
    }
}

#[no_mangle]
pub extern "C" fn share_opaque_EnglishIndex(ptr: *const c_void) -> *const c_void {
    unsafe {
        Arc::<EnglishIndex>::increment_strong_count(ptr as _);
        ptr
    }
}

#[no_mangle]
pub extern "C" fn drop_opaque_HashMapStringVecString(ptr: *const c_void) {
    unsafe {
        Arc::<HashMap<String, Vec<String>>>::decrement_strong_count(ptr as _);
    }
}

#[no_mangle]
pub extern "C" fn share_opaque_HashMapStringVecString(ptr: *const c_void) -> *const c_void {
    unsafe {
        Arc::<HashMap<String, Vec<String>>>::increment_strong_count(ptr as _);
        ptr
    }
}

#[no_mangle]
pub extern "C" fn drop_opaque_RichDict(ptr: *const c_void) {
    unsafe {
        Arc::<RichDict>::decrement_strong_count(ptr as _);
    }
}

#[no_mangle]
pub extern "C" fn share_opaque_RichDict(ptr: *const c_void) -> *const c_void {
    unsafe {
        Arc::<RichDict>::increment_strong_count(ptr as _);
        ptr
    }
}

#[no_mangle]
pub extern "C" fn drop_opaque_SearchVariantsMap(ptr: *const c_void) {
    unsafe {
        Arc::<search::VariantsMap>::decrement_strong_count(ptr as _);
    }
}

#[no_mangle]
pub extern "C" fn share_opaque_SearchVariantsMap(ptr: *const c_void) -> *const c_void {
    unsafe {
        Arc::<search::VariantsMap>::increment_strong_count(ptr as _);
        ptr
    }
}

// Section: impl Wire2Api

impl Wire2Api<RustOpaque<EnglishIndex>> for wire_EnglishIndex {
    fn wire2api(self) -> RustOpaque<EnglishIndex> {
        unsafe { support::opaque_from_dart(self.ptr as _) }
    }
}
impl Wire2Api<RustOpaque<HashMap<String, Vec<String>>>> for wire_HashMapStringVecString {
    fn wire2api(self) -> RustOpaque<HashMap<String, Vec<String>>> {
        unsafe { support::opaque_from_dart(self.ptr as _) }
    }
}
impl Wire2Api<RustOpaque<RichDict>> for wire_RichDict {
    fn wire2api(self) -> RustOpaque<RichDict> {
        unsafe { support::opaque_from_dart(self.ptr as _) }
    }
}
impl Wire2Api<RustOpaque<search::VariantsMap>> for wire_SearchVariantsMap {
    fn wire2api(self) -> RustOpaque<search::VariantsMap> {
        unsafe { support::opaque_from_dart(self.ptr as _) }
    }
}
impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<Api> for wire_Api {
    fn wire2api(self) -> Api {
        Api {
            dict: self.dict.wire2api(),
            english_index: self.english_index.wire2api(),
            variants_map: self.variants_map.wire2api(),
            word_list: self.word_list.wire2api(),
        }
    }
}
impl Wire2Api<Api> for *mut wire_Api {
    fn wire2api(self) -> Api {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Api>::wire2api(*wrap).into()
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

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_EnglishIndex {
    ptr: *const core::ffi::c_void,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_HashMapStringVecString {
    ptr: *const core::ffi::c_void,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RichDict {
    ptr: *const core::ffi::c_void,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SearchVariantsMap {
    ptr: *const core::ffi::c_void,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Api {
    dict: wire_RichDict,
    english_index: wire_EnglishIndex,
    variants_map: wire_SearchVariantsMap,
    word_list: wire_HashMapStringVecString,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
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

impl NewWithNullPtr for wire_EnglishIndex {
    fn new_with_null_ptr() -> Self {
        Self {
            ptr: core::ptr::null(),
        }
    }
}
impl NewWithNullPtr for wire_HashMapStringVecString {
    fn new_with_null_ptr() -> Self {
        Self {
            ptr: core::ptr::null(),
        }
    }
}
impl NewWithNullPtr for wire_RichDict {
    fn new_with_null_ptr() -> Self {
        Self {
            ptr: core::ptr::null(),
        }
    }
}
impl NewWithNullPtr for wire_SearchVariantsMap {
    fn new_with_null_ptr() -> Self {
        Self {
            ptr: core::ptr::null(),
        }
    }
}

impl NewWithNullPtr for wire_Api {
    fn new_with_null_ptr() -> Self {
        Self {
            dict: wire_RichDict::new_with_null_ptr(),
            english_index: wire_EnglishIndex::new_with_null_ptr(),
            variants_map: wire_SearchVariantsMap::new_with_null_ptr(),
            word_list: wire_HashMapStringVecString::new_with_null_ptr(),
        }
    }
}

impl Default for wire_Api {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
