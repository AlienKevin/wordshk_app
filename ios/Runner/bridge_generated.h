#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_RichDict {
  const void *ptr;
} wire_RichDict;

typedef struct wire_EnglishIndex {
  const void *ptr;
} wire_EnglishIndex;

typedef struct wire_SearchVariantsMap {
  const void *ptr;
} wire_SearchVariantsMap;

typedef struct wire_HashMapStringVecString {
  const void *ptr;
} wire_HashMapStringVecString;

typedef struct wire_Api {
  struct wire_RichDict dict;
  struct wire_EnglishIndex english_index;
  struct wire_SearchVariantsMap variants_map;
  struct wire_HashMapStringVecString word_list;
} wire_Api;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_init_api(int64_t port_,
                   struct wire_uint_8_list *api_json,
                   struct wire_uint_8_list *english_index_json,
                   struct wire_uint_8_list *word_list);

void wire_pr_search(int64_t port_,
                    uint32_t capacity,
                    struct wire_uint_8_list *query,
                    int32_t script,
                    int32_t romanization);

void wire_variant_search(int64_t port_,
                         uint32_t capacity,
                         struct wire_uint_8_list *query,
                         int32_t script);

void wire_combined_search(int64_t port_,
                          uint32_t capacity,
                          struct wire_uint_8_list *query,
                          int32_t script,
                          int32_t romanization);

void wire_english_search(int64_t port_,
                         uint32_t capacity,
                         struct wire_uint_8_list *query,
                         int32_t script);

void wire_get_entry_json(int64_t port_, uint32_t id);

void wire_get_entry_group_json(int64_t port_, uint32_t id);

void wire_get_entry_id(int64_t port_, struct wire_uint_8_list *query, int32_t script);

void wire_get_jyutping(int64_t port_, struct wire_uint_8_list *query);

void wire_new__static_method__Api(int64_t port_,
                                  struct wire_uint_8_list *api_json,
                                  struct wire_uint_8_list *english_index_json,
                                  struct wire_uint_8_list *word_list);

void wire_pr_search__method__Api(int64_t port_,
                                 struct wire_Api *that,
                                 uint32_t capacity,
                                 struct wire_uint_8_list *query,
                                 int32_t script,
                                 int32_t romanization);

void wire_variant_search__method__Api(int64_t port_,
                                      struct wire_Api *that,
                                      uint32_t capacity,
                                      struct wire_uint_8_list *query,
                                      int32_t script);

void wire_combined_search__method__Api(int64_t port_,
                                       struct wire_Api *that,
                                       uint32_t capacity,
                                       struct wire_uint_8_list *query,
                                       int32_t script,
                                       int32_t romanization);

void wire_english_search__method__Api(int64_t port_,
                                      struct wire_Api *that,
                                      uint32_t capacity,
                                      struct wire_uint_8_list *query,
                                      int32_t script);

void wire_get_entry_json__method__Api(int64_t port_, struct wire_Api *that, uintptr_t id);

void wire_get_entry_group_json__method__Api(int64_t port_, struct wire_Api *that, uintptr_t id);

void wire_get_entry_id__method__Api(int64_t port_,
                                    struct wire_Api *that,
                                    struct wire_uint_8_list *query,
                                    int32_t script);

void wire_get_jyutping__method__Api(int64_t port_,
                                    struct wire_Api *that,
                                    struct wire_uint_8_list *query);

struct wire_EnglishIndex new_EnglishIndex(void);

struct wire_HashMapStringVecString new_HashMapStringVecString(void);

struct wire_RichDict new_RichDict(void);

struct wire_SearchVariantsMap new_SearchVariantsMap(void);

struct wire_Api *new_box_autoadd_api_0(void);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void drop_opaque_EnglishIndex(const void *ptr);

const void *share_opaque_EnglishIndex(const void *ptr);

void drop_opaque_HashMapStringVecString(const void *ptr);

const void *share_opaque_HashMapStringVecString(const void *ptr);

void drop_opaque_RichDict(const void *ptr);

const void *share_opaque_RichDict(const void *ptr);

void drop_opaque_SearchVariantsMap(const void *ptr);

const void *share_opaque_SearchVariantsMap(const void *ptr);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_init_api);
    dummy_var ^= ((int64_t) (void*) wire_pr_search);
    dummy_var ^= ((int64_t) (void*) wire_variant_search);
    dummy_var ^= ((int64_t) (void*) wire_combined_search);
    dummy_var ^= ((int64_t) (void*) wire_english_search);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_json);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_group_json);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_id);
    dummy_var ^= ((int64_t) (void*) wire_get_jyutping);
    dummy_var ^= ((int64_t) (void*) wire_new__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_pr_search__method__Api);
    dummy_var ^= ((int64_t) (void*) wire_variant_search__method__Api);
    dummy_var ^= ((int64_t) (void*) wire_combined_search__method__Api);
    dummy_var ^= ((int64_t) (void*) wire_english_search__method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_json__method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_group_json__method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_id__method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_jyutping__method__Api);
    dummy_var ^= ((int64_t) (void*) new_EnglishIndex);
    dummy_var ^= ((int64_t) (void*) new_HashMapStringVecString);
    dummy_var ^= ((int64_t) (void*) new_RichDict);
    dummy_var ^= ((int64_t) (void*) new_SearchVariantsMap);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_api_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) drop_opaque_EnglishIndex);
    dummy_var ^= ((int64_t) (void*) share_opaque_EnglishIndex);
    dummy_var ^= ((int64_t) (void*) drop_opaque_HashMapStringVecString);
    dummy_var ^= ((int64_t) (void*) share_opaque_HashMapStringVecString);
    dummy_var ^= ((int64_t) (void*) drop_opaque_RichDict);
    dummy_var ^= ((int64_t) (void*) share_opaque_RichDict);
    dummy_var ^= ((int64_t) (void*) drop_opaque_SearchVariantsMap);
    dummy_var ^= ((int64_t) (void*) share_opaque_SearchVariantsMap);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
