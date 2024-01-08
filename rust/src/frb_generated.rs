// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.11.

#![allow(
    non_camel_case_types,
    unused,
    non_snake_case,
    clippy::needless_return,
    clippy::redundant_closure_call,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::unused_unit,
    clippy::double_parens,
    clippy::let_and_return,
    clippy::too_many_arguments
)]

// Section: imports

use flutter_rust_bridge::{Handler, IntoIntoDart};
use flutter_rust_bridge::for_generated::byteorder::{NativeEndian, ReadBytesExt, WriteBytesExt};
use flutter_rust_bridge::for_generated::transform_result_dco;

#[cfg(not(target_family = "wasm"))]
pub use io::*;
#[cfg(target_family = "wasm")]
pub use web::*;

// Section: boilerplate

flutter_rust_bridge::frb_generated_boilerplate!();

// Section: executor

flutter_rust_bridge::frb_generated_default_handler!();

// Section: wire_funcs

fn wire_combined_search_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    capacity: impl CstDecode<u32>,
    query: impl CstDecode<String>,
    script: impl CstDecode<crate::api::api::Script>,
    romanization: impl CstDecode<crate::api::api::Romanization>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "combined_search",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_capacity = capacity.cst_decode();
            let api_query = query.cst_decode();
            let api_script = script.cst_decode();
            let api_romanization = romanization.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::combined_search(
                        api_capacity,
                        api_query,
                        api_script,
                        api_romanization,
                    ))
                })())
            }
        },
    )
}
fn wire_create_log_stream_impl(port_: flutter_rust_bridge::for_generated::MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "create_log_stream",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Stream,
        },
        move || {
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::create_log_stream(StreamSink::new(
                        context.rust2dart_context().stream_sink::<_, String>(),
                    )))
                })())
            }
        },
    )
}
fn wire_eg_search_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    capacity: impl CstDecode<u32>,
    max_first_index_in_eg: impl CstDecode<u32>,
    query: impl CstDecode<String>,
    script: impl CstDecode<crate::api::api::Script>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "eg_search",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_capacity = capacity.cst_decode();
            let api_max_first_index_in_eg = max_first_index_in_eg.cst_decode();
            let api_query = query.cst_decode();
            let api_script = script.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::eg_search(
                        api_capacity,
                        api_max_first_index_in_eg,
                        api_query,
                        api_script,
                    ))
                })())
            }
        },
    )
}
fn wire_generate_pr_indices_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    romanization: impl CstDecode<crate::api::api::Romanization>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "generate_pr_indices",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_romanization = romanization.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::generate_pr_indices(api_romanization))
                })())
            }
        },
    )
}
fn wire_get_entry_group_json_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    id: impl CstDecode<u32>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_entry_group_json",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_id = id.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::get_entry_group_json(api_id))
                })())
            }
        },
    )
}
fn wire_get_entry_id_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    query: impl CstDecode<String>,
    script: impl CstDecode<crate::api::api::Script>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_entry_id",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_query = query.cst_decode();
            let api_script = script.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::get_entry_id(api_query, api_script))
                })())
            }
        },
    )
}
fn wire_get_entry_json_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    id: impl CstDecode<u32>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_entry_json",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_id = id.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::get_entry_json(api_id))
                })())
            }
        },
    )
}
fn wire_get_entry_summaries_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    entry_ids: impl CstDecode<Vec<u32>>,
    script: impl CstDecode<crate::api::api::Script>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_entry_summaries",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_entry_ids = entry_ids.cst_decode();
            let api_script = script.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::get_entry_summaries(
                        api_entry_ids,
                        api_script,
                    ))
                })())
            }
        },
    )
}
fn wire_get_jyutping_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    query: impl CstDecode<String>,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_jyutping",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let api_query = query.cst_decode();
            move |context| {
                transform_result_dco((move || {
                    Result::<_, ()>::Ok(crate::api::api::get_jyutping(api_query))
                })())
            }
        },
    )
}
fn wire_init_api_impl(port_: flutter_rust_bridge::for_generated::MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "init_api",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            move |context| {
                transform_result_dco((move || Result::<_, ()>::Ok(crate::api::api::init_api()))())
            }
        },
    )
}
fn wire_init_utils_impl(port_: flutter_rust_bridge::for_generated::MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::DcoCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "init_utils",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            move |context| {
                transform_result_dco((move || Result::<_, ()>::Ok(crate::api::api::init_utils()))())
            }
        },
    )
}

// Section: wrapper_structs

#[derive(Clone)]
pub struct mirror_MatchedInfix(crate::api::api::MatchedInfix);

#[derive(Clone)]
pub struct mirror_MatchedSegment(crate::api::api::MatchedSegment);

#[derive(Clone)]
pub struct mirror_Romanization(crate::api::api::Romanization);

#[derive(Clone)]
pub struct mirror_Script(crate::api::api::Script);

// Section: static_checks

#[allow(clippy::unnecessary_literal_unwrap)]
const _: fn() = || {
    {
        let MatchedInfix = None::<crate::api::api::MatchedInfix>.unwrap();
        let _: String = MatchedInfix.prefix;
        let _: String = MatchedInfix.query;
        let _: String = MatchedInfix.suffix;
    }
    {
        let MatchedSegment = None::<crate::api::api::MatchedSegment>.unwrap();
        let _: String = MatchedSegment.segment;
        let _: bool = MatchedSegment.matched;
    }
};

// Section: dart2rust

impl CstDecode<bool> for bool {
    fn cst_decode(self) -> bool {
        self
    }
}
impl CstDecode<i32> for i32 {
    fn cst_decode(self) -> i32 {
        self
    }
}
impl CstDecode<crate::api::api::Romanization> for i32 {
    fn cst_decode(self) -> crate::api::api::Romanization {
        match self {
            0 => crate::api::api::Romanization::Jyutping,
            1 => crate::api::api::Romanization::Yale,
            _ => unreachable!("Invalid variant for Romanization: {}", self),
        }
    }
}
impl CstDecode<crate::api::api::Script> for i32 {
    fn cst_decode(self) -> crate::api::api::Script {
        match self {
            0 => crate::api::api::Script::Simplified,
            1 => crate::api::api::Script::Traditional,
            _ => unreachable!("Invalid variant for Script: {}", self),
        }
    }
}
impl CstDecode<u32> for u32 {
    fn cst_decode(self) -> u32 {
        self
    }
}
impl CstDecode<u8> for u8 {
    fn cst_decode(self) -> u8 {
        self
    }
}
impl SseDecode for String {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <Vec<u8>>::sse_decode(deserializer);
        return String::from_utf8(inner).unwrap();
    }
}

impl SseDecode for bool {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u8().unwrap() != 0
    }
}

impl SseDecode for crate::api::api::CombinedSearchResults {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_variantResults =
            <Vec<crate::api::api::VariantSearchResult>>::sse_decode(deserializer);
        let mut var_prResults = <Vec<crate::api::api::PrSearchResult>>::sse_decode(deserializer);
        let mut var_englishResults =
            <Vec<crate::api::api::EnglishSearchResult>>::sse_decode(deserializer);
        return crate::api::api::CombinedSearchResults {
            variant_results: var_variantResults,
            pr_results: var_prResults,
            english_results: var_englishResults,
        };
    }
}

impl SseDecode for crate::api::api::EgSearchResult {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_id = <u32>::sse_decode(deserializer);
        let mut var_defIndex = <u32>::sse_decode(deserializer);
        let mut var_egIndex = <u32>::sse_decode(deserializer);
        let mut var_matchedEg = <crate::api::api::MatchedInfix>::sse_decode(deserializer);
        return crate::api::api::EgSearchResult {
            id: var_id,
            def_index: var_defIndex,
            eg_index: var_egIndex,
            matched_eg: var_matchedEg,
        };
    }
}

impl SseDecode for crate::api::api::EnglishSearchResult {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_id = <u32>::sse_decode(deserializer);
        let mut var_defIndex = <u32>::sse_decode(deserializer);
        let mut var_variant = <String>::sse_decode(deserializer);
        let mut var_pr = <String>::sse_decode(deserializer);
        let mut var_matchedEng = <Vec<crate::api::api::MatchedSegment>>::sse_decode(deserializer);
        return crate::api::api::EnglishSearchResult {
            id: var_id,
            def_index: var_defIndex,
            variant: var_variant,
            pr: var_pr,
            matched_eng: var_matchedEng,
        };
    }
}

impl SseDecode for crate::api::api::EntrySummary {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_variant = <String>::sse_decode(deserializer);
        let mut var_defs = <Vec<(String, String)>>::sse_decode(deserializer);
        return crate::api::api::EntrySummary {
            variant: var_variant,
            defs: var_defs,
        };
    }
}

impl SseDecode for i32 {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_i32::<NativeEndian>().unwrap()
    }
}

impl SseDecode for Vec<String> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<String>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<crate::api::api::EgSearchResult> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<crate::api::api::EgSearchResult>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<crate::api::api::EnglishSearchResult> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<crate::api::api::EnglishSearchResult>::sse_decode(
                deserializer,
            ));
        }
        return ans_;
    }
}

impl SseDecode for Vec<crate::api::api::EntrySummary> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<crate::api::api::EntrySummary>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<crate::api::api::MatchedSegment> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<crate::api::api::MatchedSegment>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<crate::api::api::PrSearchResult> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<crate::api::api::PrSearchResult>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<u32> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<u32>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<u8> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<u8>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<(String, String)> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<(String, String)>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<crate::api::api::VariantSearchResult> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<crate::api::api::VariantSearchResult>::sse_decode(
                deserializer,
            ));
        }
        return ans_;
    }
}

impl SseDecode for crate::api::api::MatchedInfix {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_prefix = <String>::sse_decode(deserializer);
        let mut var_query = <String>::sse_decode(deserializer);
        let mut var_suffix = <String>::sse_decode(deserializer);
        return crate::api::api::MatchedInfix {
            prefix: var_prefix,
            query: var_query,
            suffix: var_suffix,
        };
    }
}

impl SseDecode for crate::api::api::MatchedSegment {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_segment = <String>::sse_decode(deserializer);
        let mut var_matched = <bool>::sse_decode(deserializer);
        return crate::api::api::MatchedSegment {
            segment: var_segment,
            matched: var_matched,
        };
    }
}

impl SseDecode for Option<u32> {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        if (<bool>::sse_decode(deserializer)) {
            return Some(<u32>::sse_decode(deserializer));
        } else {
            return None;
        }
    }
}

impl SseDecode for crate::api::api::PrSearchResult {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_id = <u32>::sse_decode(deserializer);
        let mut var_variant = <String>::sse_decode(deserializer);
        let mut var_matchedPr = <Vec<crate::api::api::MatchedSegment>>::sse_decode(deserializer);
        let mut var_yues = <Vec<String>>::sse_decode(deserializer);
        let mut var_engs = <Vec<String>>::sse_decode(deserializer);
        return crate::api::api::PrSearchResult {
            id: var_id,
            variant: var_variant,
            matched_pr: var_matchedPr,
            yues: var_yues,
            engs: var_engs,
        };
    }
}

impl SseDecode for (String, String) {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_field0 = <String>::sse_decode(deserializer);
        let mut var_field1 = <String>::sse_decode(deserializer);
        return (var_field0, var_field1);
    }
}

impl SseDecode for crate::api::api::Romanization {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <i32>::sse_decode(deserializer);
        return match inner {
            0 => crate::api::api::Romanization::Jyutping,
            1 => crate::api::api::Romanization::Yale,
            _ => unreachable!("Invalid variant for Romanization: {}", inner),
        };
    }
}

impl SseDecode for crate::api::api::Script {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <i32>::sse_decode(deserializer);
        return match inner {
            0 => crate::api::api::Script::Simplified,
            1 => crate::api::api::Script::Traditional,
            _ => unreachable!("Invalid variant for Script: {}", inner),
        };
    }
}

impl SseDecode for u32 {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u32::<NativeEndian>().unwrap()
    }
}

impl SseDecode for u8 {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u8().unwrap()
    }
}

impl SseDecode for () {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {}
}

impl SseDecode for crate::api::api::VariantSearchResult {
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_id = <u32>::sse_decode(deserializer);
        let mut var_matchedVariant = <crate::api::api::MatchedInfix>::sse_decode(deserializer);
        let mut var_yues = <Vec<String>>::sse_decode(deserializer);
        let mut var_engs = <Vec<String>>::sse_decode(deserializer);
        return crate::api::api::VariantSearchResult {
            id: var_id,
            matched_variant: var_matchedVariant,
            yues: var_yues,
            engs: var_engs,
        };
    }
}

// Section: rust2dart

impl flutter_rust_bridge::IntoDart for crate::api::api::CombinedSearchResults {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.variant_results.into_into_dart().into_dart(),
            self.pr_results.into_into_dart().into_dart(),
            self.english_results.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::api::CombinedSearchResults
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::api::CombinedSearchResults>
    for crate::api::api::CombinedSearchResults
{
    fn into_into_dart(self) -> crate::api::api::CombinedSearchResults {
        self
    }
}
impl flutter_rust_bridge::IntoDart for crate::api::api::EgSearchResult {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.def_index.into_into_dart().into_dart(),
            self.eg_index.into_into_dart().into_dart(),
            self.matched_eg.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::api::EgSearchResult
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::api::EgSearchResult>
    for crate::api::api::EgSearchResult
{
    fn into_into_dart(self) -> crate::api::api::EgSearchResult {
        self
    }
}
impl flutter_rust_bridge::IntoDart for crate::api::api::EnglishSearchResult {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.def_index.into_into_dart().into_dart(),
            self.variant.into_into_dart().into_dart(),
            self.pr.into_into_dart().into_dart(),
            self.matched_eng.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::api::EnglishSearchResult
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::api::EnglishSearchResult>
    for crate::api::api::EnglishSearchResult
{
    fn into_into_dart(self) -> crate::api::api::EnglishSearchResult {
        self
    }
}
impl flutter_rust_bridge::IntoDart for crate::api::api::EntrySummary {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.variant.into_into_dart().into_dart(),
            self.defs.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive for crate::api::api::EntrySummary {}
impl flutter_rust_bridge::IntoIntoDart<crate::api::api::EntrySummary>
    for crate::api::api::EntrySummary
{
    fn into_into_dart(self) -> crate::api::api::EntrySummary {
        self
    }
}
impl flutter_rust_bridge::IntoDart for mirror_MatchedInfix {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.0.prefix.into_into_dart().into_dart(),
            self.0.query.into_into_dart().into_dart(),
            self.0.suffix.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive for mirror_MatchedInfix {}
impl flutter_rust_bridge::IntoIntoDart<mirror_MatchedInfix> for crate::api::api::MatchedInfix {
    fn into_into_dart(self) -> mirror_MatchedInfix {
        mirror_MatchedInfix(self)
    }
}
impl flutter_rust_bridge::IntoDart for mirror_MatchedSegment {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.0.segment.into_into_dart().into_dart(),
            self.0.matched.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive for mirror_MatchedSegment {}
impl flutter_rust_bridge::IntoIntoDart<mirror_MatchedSegment> for crate::api::api::MatchedSegment {
    fn into_into_dart(self) -> mirror_MatchedSegment {
        mirror_MatchedSegment(self)
    }
}
impl flutter_rust_bridge::IntoDart for crate::api::api::PrSearchResult {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.variant.into_into_dart().into_dart(),
            self.matched_pr.into_into_dart().into_dart(),
            self.yues.into_into_dart().into_dart(),
            self.engs.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::api::PrSearchResult
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::api::PrSearchResult>
    for crate::api::api::PrSearchResult
{
    fn into_into_dart(self) -> crate::api::api::PrSearchResult {
        self
    }
}
impl flutter_rust_bridge::IntoDart for mirror_Romanization {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        match self.0 {
            crate::api::api::Romanization::Jyutping => 0,
            crate::api::api::Romanization::Yale => 1,
        }
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive for mirror_Romanization {}
impl flutter_rust_bridge::IntoIntoDart<mirror_Romanization> for crate::api::api::Romanization {
    fn into_into_dart(self) -> mirror_Romanization {
        mirror_Romanization(self)
    }
}
impl flutter_rust_bridge::IntoDart for mirror_Script {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        match self.0 {
            crate::api::api::Script::Simplified => 0,
            crate::api::api::Script::Traditional => 1,
        }
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive for mirror_Script {}
impl flutter_rust_bridge::IntoIntoDart<mirror_Script> for crate::api::api::Script {
    fn into_into_dart(self) -> mirror_Script {
        mirror_Script(self)
    }
}
impl flutter_rust_bridge::IntoDart for crate::api::api::VariantSearchResult {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.matched_variant.into_into_dart().into_dart(),
            self.yues.into_into_dart().into_dart(),
            self.engs.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::api::VariantSearchResult
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::api::VariantSearchResult>
    for crate::api::api::VariantSearchResult
{
    fn into_into_dart(self) -> crate::api::api::VariantSearchResult {
        self
    }
}

impl SseEncode for String {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <Vec<u8>>::sse_encode(self.into_bytes(), serializer);
    }
}

impl SseEncode for bool {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_u8(self as _).unwrap();
    }
}

impl SseEncode for crate::api::api::CombinedSearchResults {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <Vec<crate::api::api::VariantSearchResult>>::sse_encode(self.variant_results, serializer);
        <Vec<crate::api::api::PrSearchResult>>::sse_encode(self.pr_results, serializer);
        <Vec<crate::api::api::EnglishSearchResult>>::sse_encode(self.english_results, serializer);
    }
}

impl SseEncode for crate::api::api::EgSearchResult {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <u32>::sse_encode(self.id, serializer);
        <u32>::sse_encode(self.def_index, serializer);
        <u32>::sse_encode(self.eg_index, serializer);
        <crate::api::api::MatchedInfix>::sse_encode(self.matched_eg, serializer);
    }
}

impl SseEncode for crate::api::api::EnglishSearchResult {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <u32>::sse_encode(self.id, serializer);
        <u32>::sse_encode(self.def_index, serializer);
        <String>::sse_encode(self.variant, serializer);
        <String>::sse_encode(self.pr, serializer);
        <Vec<crate::api::api::MatchedSegment>>::sse_encode(self.matched_eng, serializer);
    }
}

impl SseEncode for crate::api::api::EntrySummary {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.variant, serializer);
        <Vec<(String, String)>>::sse_encode(self.defs, serializer);
    }
}

impl SseEncode for i32 {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_i32::<NativeEndian>(self).unwrap();
    }
}

impl SseEncode for Vec<String> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <String>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<crate::api::api::EgSearchResult> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <crate::api::api::EgSearchResult>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<crate::api::api::EnglishSearchResult> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <crate::api::api::EnglishSearchResult>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<crate::api::api::EntrySummary> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <crate::api::api::EntrySummary>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<crate::api::api::MatchedSegment> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <crate::api::api::MatchedSegment>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<crate::api::api::PrSearchResult> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <crate::api::api::PrSearchResult>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<u32> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <u32>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<u8> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <u8>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<(String, String)> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <(String, String)>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<crate::api::api::VariantSearchResult> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <crate::api::api::VariantSearchResult>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for crate::api::api::MatchedInfix {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.prefix, serializer);
        <String>::sse_encode(self.query, serializer);
        <String>::sse_encode(self.suffix, serializer);
    }
}

impl SseEncode for crate::api::api::MatchedSegment {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.segment, serializer);
        <bool>::sse_encode(self.matched, serializer);
    }
}

impl SseEncode for Option<u32> {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <bool>::sse_encode(self.is_some(), serializer);
        if let Some(value) = self {
            <u32>::sse_encode(value, serializer);
        }
    }
}

impl SseEncode for crate::api::api::PrSearchResult {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <u32>::sse_encode(self.id, serializer);
        <String>::sse_encode(self.variant, serializer);
        <Vec<crate::api::api::MatchedSegment>>::sse_encode(self.matched_pr, serializer);
        <Vec<String>>::sse_encode(self.yues, serializer);
        <Vec<String>>::sse_encode(self.engs, serializer);
    }
}

impl SseEncode for (String, String) {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.0, serializer);
        <String>::sse_encode(self.1, serializer);
    }
}

impl SseEncode for crate::api::api::Romanization {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self as _, serializer);
    }
}

impl SseEncode for crate::api::api::Script {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self as _, serializer);
    }
}

impl SseEncode for u32 {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_u32::<NativeEndian>(self).unwrap();
    }
}

impl SseEncode for u8 {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_u8(self).unwrap();
    }
}

impl SseEncode for () {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {}
}

impl SseEncode for crate::api::api::VariantSearchResult {
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <u32>::sse_encode(self.id, serializer);
        <crate::api::api::MatchedInfix>::sse_encode(self.matched_variant, serializer);
        <Vec<String>>::sse_encode(self.yues, serializer);
        <Vec<String>>::sse_encode(self.engs, serializer);
    }
}

#[cfg(not(target_family = "wasm"))]
#[path = "frb_generated.io.rs"]
mod io;
/// cbindgen:ignore
#[cfg(target_family = "wasm")]
#[path = "frb_generated.web.rs"]
mod web;
