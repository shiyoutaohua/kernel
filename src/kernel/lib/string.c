#define _LIB_STRING_C

#include "../include/string.h"

u64 strlen (const char *str) {
	const char *cp =  str;
	while (*cp++ );
	return (cp - str - 1 );
}

char *strcpy (char *dst, const char *src) {
	char *ret = dst;
	while ((*dst++ = *src++));
	return ret;
}

char *strcat (char *dst, const char *src) {
	strcpy(dst + strlen(dst), src);
	return dst;
}

void memset (void *dst, u8 value, u64 size) {
	u8* tmp = (u8*) dst;
	while (size-- > 0) *tmp++ = value;
}

void memcpy (void *dst, const void *src, u64 size) {
	u8 *dp = (u8*) dst;
	u8 *sp = (u8*) src;
	while (size-- > 0) *dp++ = *sp++;
}

char *i2s(i64 value, char *str, enum radix rdx) {
	switch (rdx) {
		case DEC: {
			u64 abs = value;
			u8 left = 0, right = 0;
			if (value < 0) {
				abs = (u64) -value;
				str[left++] = '-';
				right++;
			}
			do {
				str[right++] = (u8) (abs % rdx);
				abs = abs / rdx;
			} while (abs);
			str[right] = '\0';
			while (left < right) {
				char tmp = (char) (str[left] + '0');
				str[left++] = (char) (str[right - 1] + '0');
				str[--right] = tmp;
			}
			break;
		}
		case HEX: {
			char v[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
			u64 mask = 0xf;
			u8 step = 64, idx = 0;
			str[idx++] = '0';
			str[idx++] = 'x';
			while (step > 0) {
				step -= 4;
				str[idx++] = v[(value >> step) & mask];
			}
			str[idx] = '\0';
			break;
		}
		default:
			str = (char*)null;
	}
	return str;
}
