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

void wire_init_api(int64_t port, struct wire_uint_8_list *input_app_dir);

void wire_pr_search(int64_t port, uint32_t capacity, struct wire_uint_8_list *query);

void wire_variant_search(int64_t port, uint32_t capacity, struct wire_uint_8_list *query);

void wire_get_entry_html(int64_t port, uint32_t id);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_init_api);
    dummy_var ^= ((int64_t) (void*) wire_pr_search);
    dummy_var ^= ((int64_t) (void*) wire_variant_search);
    dummy_var ^= ((int64_t) (void*) wire_get_entry_html);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}