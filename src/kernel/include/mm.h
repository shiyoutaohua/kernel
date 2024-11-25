#ifndef _INCLUDE_MM_H
#define _INCLUDE_MM_H

#include "bitmap.h"

#define PG_SIZE 4096

/* Kernel physical memory pool base address. */
#define K_P_M_POOL_BASE 0x800000

/* The base address of kernel heap. */
#define K_HEAP_BASE 0xffff800001000000

/* The struct of memory pool. */
struct mpool {
	struct bitmap map;
	u64 offset;
	u64 size;
};

enum mpool_type {
	KPMPOOL = 1,
	KVMPOOL = 2,
	UPMPOOL = 3
};

void init_mpool (u64 capacity);

void *alloc_page (u64 count);

#endif
