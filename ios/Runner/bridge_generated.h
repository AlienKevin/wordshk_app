#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_32_list {
  uint32_t *ptr;
  int32_t len;
} wire_uint_32_list;

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_get_entry_summaries(int64_t port_,
                              struct wire_uint_32_list *entry_ids,
                              int32_t script,
                              bool is_eng_def);

void wire_update_pr_indices(int64_t port_, struct wire_uint_8_list *pr_indices);

void wire_generate_pr_indices(int64_t port_, int32_t romanization);

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

void wire_eg_search(int64_t port_,
                    uint32_t capacity,
                    uint32_t max_eg_length,
                    struct wire_uint_8_list *query,
                    int32_t script);

void wire_get_entry_json(int64_t port_, uint32_t id);

void wire_get_entry_group_json(int64_t port_, uint32_t id);

void wire_get_entry_id(int64_t port_, struct wire_uint_8_list *query, int32_t script);

void wire_get_jyutping(int64_t port_, struct wire_uint_8_list *query);

struct wire_uint_32_list *new_uint_32_list_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_get_entry_summaries);
    dummy_var ^= ((int64_t) (void*) wire_update_pr_indices);
    dummy_var ^= ((int64_t) (void*) wire_generate_pr_indices);
    dummy_var ^= ((int64_t) (void*) wire_pr_search);
    dummy_var ^= ((int64_t) (void*) wire_variant_search);
    dummy_var ^= ((int64_t) (void*) wire_combined_search);
    dummy_var ^= ((int64_t) (void*) wire_english_search);
    dummy_var ^= ((int64_t) (void*) wire_eg_search);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_json);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_group_json);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_id);
    dummy_var ^= ((int64_t) (void*) wire_get_jyutping);
    dummy_var ^= ((int64_t) (void*) new_uint_32_list_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
