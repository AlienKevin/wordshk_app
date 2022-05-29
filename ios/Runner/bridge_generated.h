#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

void wire_init_api(int64_t port_,
                   struct wire_uint_8_list *api_json,
                   struct wire_uint_8_list *english_index_json);

void wire_pr_search(int64_t port_,
                    uint32_t capacity,
                    struct wire_uint_8_list *query,
                    int32_t script);

void wire_variant_search(int64_t port_,
                         uint32_t capacity,
                         struct wire_uint_8_list *query,
                         int32_t script);

void wire_combined_search(int64_t port_,
                          uint32_t capacity,
                          struct wire_uint_8_list *query,
                          int32_t script);

void wire_english_search(int64_t port_,
                         uint32_t capacity,
                         struct wire_uint_8_list *query,
                         int32_t script);

void wire_get_entry_json(int64_t port_, uint32_t id);

void wire_get_entry_group_json(int64_t port_, uint32_t id);

void wire_get_entry_id(int64_t port_, struct wire_uint_8_list *query, int32_t script);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

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
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}