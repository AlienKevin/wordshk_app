use super::*;

// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_update_pr_indices(port_: i64, pr_indices: *mut wire_uint_8_list) {
    wire_update_pr_indices_impl(port_, pr_indices)
}

#[no_mangle]
pub extern "C" fn wire_generate_pr_indices(port_: i64, romanization: i32) {
    wire_generate_pr_indices_impl(port_, romanization)
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

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
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

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
