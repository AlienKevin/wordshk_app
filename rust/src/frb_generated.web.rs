// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.4.

// Section: imports

use flutter_rust_bridge::for_generated::wasm_bindgen;
use flutter_rust_bridge::for_generated::wasm_bindgen::prelude::*;

use super::*;

// Section: dart2rust

impl<T> CstDecode<Option<T>> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
where
    JsValue: CstDecode<T>,
{
    fn cst_decode(self) -> Option<T> {
        (!self.is_null() && !self.is_undefined()).then(|| self.cst_decode())
    }
}
impl CstDecode<anyhow::Error> for String {
    fn cst_decode(self) -> anyhow::Error {
        unimplemented!()
    }
}
impl CstDecode<String> for String {
    fn cst_decode(self) -> String {
        self
    }
}
impl CstDecode<crate::api::api::CombinedSearchResults>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::CombinedSearchResults {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            3,
            "Expected 3 elements, got {}",
            self_.length()
        );
        crate::api::api::CombinedSearchResults {
            variant_results: self_.get(0).cst_decode(),
            pr_results: self_.get(1).cst_decode(),
            english_results: self_.get(2).cst_decode(),
        }
    }
}
impl CstDecode<crate::api::api::EgSearchResult>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::EgSearchResult {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            4,
            "Expected 4 elements, got {}",
            self_.length()
        );
        crate::api::api::EgSearchResult {
            id: self_.get(0).cst_decode(),
            def_index: self_.get(1).cst_decode(),
            eg_index: self_.get(2).cst_decode(),
            eg: self_.get(3).cst_decode(),
        }
    }
}
impl CstDecode<crate::api::api::EnglishSearchResult>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::EnglishSearchResult {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            5,
            "Expected 5 elements, got {}",
            self_.length()
        );
        crate::api::api::EnglishSearchResult {
            id: self_.get(0).cst_decode(),
            def_index: self_.get(1).cst_decode(),
            variant: self_.get(2).cst_decode(),
            pr: self_.get(3).cst_decode(),
            eng: self_.get(4).cst_decode(),
        }
    }
}
impl CstDecode<crate::api::api::EntrySummary>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::EntrySummary {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            2,
            "Expected 2 elements, got {}",
            self_.length()
        );
        crate::api::api::EntrySummary {
            variant: self_.get(0).cst_decode(),
            defs: self_.get(1).cst_decode(),
        }
    }
}
impl CstDecode<Vec<String>> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> Vec<String> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<crate::api::api::EgSearchResult>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> Vec<crate::api::api::EgSearchResult> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<crate::api::api::EnglishSearchResult>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> Vec<crate::api::api::EnglishSearchResult> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<crate::api::api::EntrySummary>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> Vec<crate::api::api::EntrySummary> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<crate::api::api::PrSearchResult>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> Vec<crate::api::api::PrSearchResult> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<u32>> for Box<[u32]> {
    fn cst_decode(self) -> Vec<u32> {
        self.into_vec()
    }
}
impl CstDecode<Vec<u8>> for Box<[u8]> {
    fn cst_decode(self) -> Vec<u8> {
        self.into_vec()
    }
}
impl CstDecode<Vec<(String, String)>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> Vec<(String, String)> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<crate::api::api::SpotlightEntrySummary>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> Vec<crate::api::api::SpotlightEntrySummary> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<crate::api::api::VariantSearchResult>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> Vec<crate::api::api::VariantSearchResult> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Option<String>> for Option<String> {
    fn cst_decode(self) -> Option<String> {
        self.map(CstDecode::cst_decode)
    }
}
impl CstDecode<crate::api::api::PrSearchResult>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::PrSearchResult {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            5,
            "Expected 5 elements, got {}",
            self_.length()
        );
        crate::api::api::PrSearchResult {
            id: self_.get(0).cst_decode(),
            variant: self_.get(1).cst_decode(),
            pr: self_.get(2).cst_decode(),
            yues: self_.get(3).cst_decode(),
            engs: self_.get(4).cst_decode(),
        }
    }
}
impl CstDecode<(Option<String>, Vec<crate::api::api::EgSearchResult>)>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> (Option<String>, Vec<crate::api::api::EgSearchResult>) {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            2,
            "Expected 2 elements, got {}",
            self_.length()
        );
        (self_.get(0).cst_decode(), self_.get(1).cst_decode())
    }
}
impl CstDecode<(String, String)> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> (String, String) {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            2,
            "Expected 2 elements, got {}",
            self_.length()
        );
        (self_.get(0).cst_decode(), self_.get(1).cst_decode())
    }
}
impl CstDecode<crate::api::api::SpotlightEntrySummary>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::SpotlightEntrySummary {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            8,
            "Expected 8 elements, got {}",
            self_.length()
        );
        crate::api::api::SpotlightEntrySummary {
            id: self_.get(0).cst_decode(),
            variants: self_.get(1).cst_decode(),
            variants_simp: self_.get(2).cst_decode(),
            jyutpings: self_.get(3).cst_decode(),
            yales: self_.get(4).cst_decode(),
            def: self_.get(5).cst_decode(),
            def_simp: self_.get(6).cst_decode(),
            def_en: self_.get(7).cst_decode(),
        }
    }
}
impl CstDecode<crate::api::api::VariantSearchResult>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::VariantSearchResult {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            4,
            "Expected 4 elements, got {}",
            self_.length()
        );
        crate::api::api::VariantSearchResult {
            id: self_.get(0).cst_decode(),
            variant: self_.get(1).cst_decode(),
            yues: self_.get(2).cst_decode(),
            engs: self_.get(3).cst_decode(),
        }
    }
}
impl CstDecode<anyhow::Error> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> anyhow::Error {
        unimplemented!()
    }
}
impl CstDecode<String> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> String {
        self.as_string().expect("non-UTF-8 string, or not a string")
    }
}
impl CstDecode<i32> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> i32 {
        self.unchecked_into_f64() as _
    }
}
impl CstDecode<Vec<u32>> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> Vec<u32> {
        self.unchecked_into::<flutter_rust_bridge::for_generated::js_sys::Uint32Array>()
            .to_vec()
            .into()
    }
}
impl CstDecode<Vec<u8>> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> Vec<u8> {
        self.unchecked_into::<flutter_rust_bridge::for_generated::js_sys::Uint8Array>()
            .to_vec()
            .into()
    }
}
impl CstDecode<crate::api::api::Romanization>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::Romanization {
        (self.unchecked_into_f64() as i32).cst_decode()
    }
}
impl CstDecode<crate::api::api::Script>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    fn cst_decode(self) -> crate::api::api::Script {
        (self.unchecked_into_f64() as i32).cst_decode()
    }
}
impl CstDecode<u32> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> u32 {
        self.unchecked_into_f64() as _
    }
}
impl CstDecode<u8> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> u8 {
        self.unchecked_into_f64() as _
    }
}
impl CstDecode<usize> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    fn cst_decode(self) -> usize {
        self.unchecked_into_f64() as _
    }
}

#[wasm_bindgen]
pub fn dart_fn_deliver_output(
    call_id: i32,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    let message = unsafe {
        flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
            ptr_,
            rust_vec_len_,
            data_len_,
        )
    };
    FLUTTER_RUST_BRIDGE_HANDLER.dart_fn_handle_output(call_id, message)
}

#[wasm_bindgen]
pub fn wire_combined_search(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    capacity: u32,
    query: String,
    script: i32,
    romanization: i32,
) {
    wire_combined_search_impl(port_, capacity, query, script, romanization)
}

#[wasm_bindgen]
pub fn wire_create_log_stream(port_: flutter_rust_bridge::for_generated::MessagePort) {
    wire_create_log_stream_impl(port_)
}

#[wasm_bindgen]
pub fn wire_eg_search(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    capacity: u32,
    max_first_index_in_eg: u32,
    query: String,
    script: i32,
) {
    wire_eg_search_impl(port_, capacity, max_first_index_in_eg, query, script)
}

#[wasm_bindgen]
pub fn wire_english_search(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    capacity: u32,
    query: String,
    script: i32,
) {
    wire_english_search_impl(port_, capacity, query, script)
}

#[wasm_bindgen]
pub fn wire_generate_pr_indices(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    romanization: i32,
) {
    wire_generate_pr_indices_impl(port_, romanization)
}

#[wasm_bindgen]
pub fn wire_get_entry_group_json(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    id: usize,
) {
    wire_get_entry_group_json_impl(port_, id)
}

#[wasm_bindgen]
pub fn wire_get_entry_id(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    query: String,
    script: i32,
) {
    wire_get_entry_id_impl(port_, query, script)
}

#[wasm_bindgen]
pub fn wire_get_entry_json(port_: flutter_rust_bridge::for_generated::MessagePort, id: usize) {
    wire_get_entry_json_impl(port_, id)
}

#[wasm_bindgen]
pub fn wire_get_entry_summaries(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    entry_ids: Box<[u32]>,
    script: i32,
) {
    wire_get_entry_summaries_impl(port_, entry_ids, script)
}

#[wasm_bindgen]
pub fn wire_get_jyutping(port_: flutter_rust_bridge::for_generated::MessagePort, query: String) {
    wire_get_jyutping_impl(port_, query)
}

#[wasm_bindgen]
pub fn wire_get_splotlight_summaries(port_: flutter_rust_bridge::for_generated::MessagePort) {
    wire_get_splotlight_summaries_impl(port_)
}

#[wasm_bindgen]
pub fn wire_init_api(port_: flutter_rust_bridge::for_generated::MessagePort) {
    wire_init_api_impl(port_)
}

#[wasm_bindgen]
pub fn wire_pr_search(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    capacity: u32,
    query: String,
    script: i32,
    romanization: i32,
) {
    wire_pr_search_impl(port_, capacity, query, script, romanization)
}

#[wasm_bindgen]
pub fn wire_update_pr_indices(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    pr_indices: Box<[u8]>,
) {
    wire_update_pr_indices_impl(port_, pr_indices)
}

#[wasm_bindgen]
pub fn wire_variant_search(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    capacity: u32,
    query: String,
    script: i32,
) {
    wire_variant_search_impl(port_, capacity, query, script)
}
