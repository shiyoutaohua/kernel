#ifndef _INCLUDE_BITMAP_H
#define _INCLUDE_BITMAP_H

#include "types.h"

struct bitmap {
	u64 size;
	u8 *bits;
};

void bitmap_init (struct bitmap *map);

/* bit test */
u8 bitmap_bt (struct bitmap *map, u64 idx);

/* bit set */
void bitmap_bs (struct bitmap *map, u64 idx);

/* bit clear */
void bitmap_bc (struct bitmap *map, u64 idx);

u64 bitmap_scan (struct bitmap *map, u64 count);

#endif
