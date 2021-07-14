#define _LIB_MM_C

#include "../include/string.h"
#include "../include/mm.h"

/*
 * @kpmpool (Kernel physical memory pool)
 * @kvmpool (Kernel virtual memory pool)
 * @upmpool (User physical memory pool)
 */
static struct mpool kpmpool, kvmpool, upmpool;

/*
 * The physical memory mapping is as follows:
 *
 * |\/\/\/\/\/\/\/|
 * |  allocatable |
 * +--------------+   0x1000000
 * |     used     |
 * +--------------+   0x0
 */
void init_mpool (u64 capacity) {
	u64 used_mem = 16 << 20;
	u64 free_mem = capacity - used_mem;
	u64 free_page = free_mem / PG_SIZE;
	u64 k_page = free_page / 2;
	u64 u_page = free_page - k_page;

	kpmpool.size = k_page * PG_SIZE;
	kpmpool.offset = used_mem;
	kpmpool.map.size = k_page / 8 + 1;
	kpmpool.map.bits = (u8*)K_P_M_POOL_BASE;

	upmpool.size = u_page * PG_SIZE;
	upmpool.offset = kpmpool.offset + kpmpool.size;
	upmpool.map.size = u_page / 8 + 1;
	upmpool.map.bits = (u8*)(K_P_M_POOL_BASE + kpmpool.map.size);

	kvmpool.size = kpmpool.size;
	kvmpool.offset = K_HEAP_BASE;
	kvmpool.map.size = kpmpool.map.size;
	kvmpool.map.bits = (u8*)(K_P_M_POOL_BASE + kpmpool.map.size + upmpool.map.size);

	bitmap_init(&kpmpool.map);
	bitmap_init(&upmpool.map);
	bitmap_init(&kvmpool.map);
}

static inline u16 idx_pml4e (void *vaddr) {
	return ((u64)vaddr >> 39) & 0x1ff;
}

static inline u16 idx_pdpe (void *vaddr) {
	return ((u64)vaddr >> 30) & 0x1ff;
}

static inline u16 idx_pde (void *vaddr) {
	return ((u64)vaddr >> 21) & 0x1ff;
}

static inline u16 idx_pte (void *vaddr) {
	return ((u64)vaddr >> 12) & 0x1ff;
}

static inline void *ptr_pml4e (void *vaddr) {
	return (void*)(0xfffffffffffff000 + idx_pml4e(vaddr) * 8);
}

static inline void *ptr_pdpe (void *vaddr) {
	return (void*)(0xffffffffffe00000 + ((u64)idx_pml4e(vaddr) << 12) + idx_pdpe(vaddr) * 8);
}

static inline void *ptr_pde (void *vaddr) {
	return (void*)(0xffffffffc0000000 + ((u64)idx_pml4e(vaddr) << 21) + ((u64)idx_pdpe(vaddr) << 12) + idx_pde(vaddr) * 8);
}

static inline void *ptr_pte (void *vaddr) {
	return (void*)(0xffffff8000000000 + ((u64)idx_pml4e(vaddr) << 30) + ((u64)idx_pdpe(vaddr) << 21) + ((u64)idx_pde(vaddr) << 12) + idx_pte(vaddr) * 8);
}

static void *find_page (struct mpool *pool, u64 count) {
	u64 idx  = bitmap_scan(&pool->map, count);
	if (idx == -1) return null;
	for (u64 i = 0; i < count; i++) {
		bitmap_bs(&pool->map, idx + i);
	}
	return (void*)(pool->offset + idx * PG_SIZE);
}

static void page_tab_map (void *vaddr, void *paddr) {
	u64 *_ptr_pml4e = (u64*)ptr_pml4e(vaddr);
	u64 *_ptr_pdpe = (u64*)ptr_pdpe(vaddr);
	u64 *_ptr_pde = (u64*)ptr_pde(vaddr);
	u64 *_ptr_pte = (u64*)ptr_pte(vaddr);
	for (;;) {
		if (*_ptr_pml4e & 1) {
			if (*_ptr_pdpe & 1) {
				if (*_ptr_pde & 1) {
					*_ptr_pte = (u64)paddr | 3;
					break;
				} else {
					void *pp_start = find_page(&kpmpool, 1);
					*_ptr_pde = (u64)pp_start | 3;
				}
			} else {
				void *pp_start = find_page(&kpmpool, 1);
				*_ptr_pdpe = (u64)pp_start | 3;
			}
		} else {
			void *pp_start = find_page(&kpmpool, 1);
			*_ptr_pml4e = (u64)pp_start | 3;
		}
	}
}

void *alloc_page (u64 count) {
	void *vp_start = find_page(&kvmpool, count);
	for (u64 i = 0; i < count; i++) {
		void *pp_start = find_page(&kpmpool, 1);
		if (pp_start == null) {
			// TODO: Physical page not enough and rollback required
			return null;
		}
		page_tab_map((vp_start + PG_SIZE * i), pp_start);
	}
	return vp_start;
}
