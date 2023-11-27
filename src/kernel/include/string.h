#ifndef _INCLUDE_STRING_H
#define _INCLUDE_STRING_H

#include "types.h"

enum radix {
	BIN = 2,
	OCT = 8,
	DEC = 10,
	HEX = 16
};

u64 strlen (const char *str);

char *strcpy (char *dst, const char *src);

char *strcat (char *dst, const char *src);

void memset (void *dst, u8 value, u64 size);

/* Copy @size bytes from @src to @dst. */
void memcpy (void *dst, const void *src, u64 size);

char *i2s(i64 value, char *str, enum radix rdx);

#endif
