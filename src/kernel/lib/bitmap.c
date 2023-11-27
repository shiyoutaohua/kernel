#define _LIB_BITMAP_C

#include "../include/string.h"
#include "../include/bitmap.h"

void bitmap_init (struct bitmap *map) {
	memset(map->bits, 0, map->size);
}

u8 bitmap_bt (struct bitmap *map, u64 idx) {
	u64 idx_byte = idx / 8;
	u8 idx_bit = idx % 8;
	return ((map->bits[idx_byte] >> idx_bit) & 1);
}

void bitmap_bs (struct bitmap *map, u64 idx) {
	u64 idx_byte = idx / 8;
	u8 idx_bit = idx % 8;
	map->bits[idx_byte] |= (1 << idx_bit);
}

void bitmap_bc (struct bitmap *map, u64 idx) {
	u64 idx_byte = idx / 8;
	u8 idx_bit = idx % 8;
	map->bits[idx_byte] &= ~(1 << idx_bit);
}

u64 bitmap_scan (struct bitmap *map, u64 count) {
	u64 idx_byte = 0;
	while ((0xff == map->bits[idx_byte]) && (idx_byte < map->size)) idx_byte++;
	if (idx_byte >= map->size) return -1;
	u8 idx_bit = 0;
	while (1 << idx_bit & map->bits[idx_byte]) idx_bit++;
	/* Now, we've found the first free bit. */
	u64 bit_start = idx_byte * 8 + idx_bit;
	if (count == 1) return bit_start;
	u64 bit_pend = map->size * 8 - bit_start;
	u64 bit_next = bit_start + 1;
	u64 count_found = 1;
	bit_start = -1;
	while (bit_pend-- > 0) {
		if(bitmap_bt(map, bit_next)) {
			count_found = 0;
		} else {
			count_found++;
		}
		if (count_found == count) {
			bit_start = bit_next - count_found + 1;
			break;
		}
		bit_next++;
	}
	return bit_start;
}
