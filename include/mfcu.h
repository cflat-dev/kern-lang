//
// Created by aarav on 4/21/26.
//

#ifndef CFLAT_MFCU_H
#define CFLAT_MFCU_H


#include <assert.h>
#include <stdio.h>
#include <stdlib.h>




#ifndef MAX_ALLOCATIONS

#define MAX_ALLOCATIONS 50
#endif





typedef struct {
    void *ptr;
    void (*cf)(void*); // Changed to take void* so it can actually free the ptr
} cleanup_table_item_t;

typedef struct {



    cleanup_table_item_t table[MAX_ALLOCATIONS];

    size_t count;
} cleanup_table_t;

// Use a unique name for the internal table instance

#define raii_scope \
cleanup_table_t _raii_scope = { .count = 0 };






// Actual cleanup execution
static inline void _run_cleanup(cleanup_table_t *ctx) {
    while (ctx->count > 0) {
        ctx->count--;
        if (ctx->table[ctx->count].cf) {
            ctx->table[ctx->count].cf(ctx->table[ctx->count].ptr);
             ctx->table[ctx->count].ptr = NULL;
            ctx->table[ctx->count].cf = NULL;

        }
    }
}





// Helper function
static inline void _mfcu(cleanup_table_t *ctx, void (*cf)(void*), void *ptr) {
    if (ctx->count < MAX_ALLOCATIONS) {
        ctx->table[ctx->count++] = (cleanup_table_item_t){ptr, cf};
    }
    else {
        fprintf(stderr, "FATAL: count of tracked allocations has exceeded the limit of %d\n", MAX_ALLOCATIONS);
      _run_cleanup(ctx);
        abort();   // Stop the program safely
    }


}

static  inline  void _release(cleanup_table_t *ctx,void *ptr)
{
  for (size_t i = 0; i < ctx->count; i++)
  {
      if (ctx->table[i].ptr == ptr)
      {
          ctx->table[i].ptr = NULL;
          ctx->table[i].cf = NULL;
          return;
      }
  }
}


#define cleanup() _run_cleanup(&_raii_scope)
#define release(ptr) \
    _release( &_raii_scope ,(void*) ptr )



#define ret(x) do { cleanup(); return x; } while(0)

#define ret_var(x) do {  release(&x)  ;cleanup(); return x; } while(0)

#define  cont cleanup();continue

#define brk cleanup();break;


// Passes the pointer to the cleanup function
#define mfcu(func, ptr) \
_mfcu(&_raii_scope, (void(*)(void*))func, (void*)ptr)





#endif //CFLAT_MFCU_H