#define _LIB_ATOMIC_C

#include "../include/atomic.h"

i64 compare_and_exchange_i64(const i64 *dst, i64 old, i64 value) {
	__asm__ __volatile__("lock; cmpxchgq %2, (%1)"
	: "+a"(old)
	: "r"(dst), "r"(value)
	: "cc", "memory");
	return old;
}

i32 compare_and_exchange_i32(const i32 *dst, i32 old, i32 value) {
	__asm__ __volatile__("lock; cmpxchgl %2, (%1)"
	: "+a"(old)
	: "r"(dst), "r"(value)
	: "cc", "memory");
	return old;
}

i16 compare_and_exchange_i16(const i16 *dst, i16 old, i16 value) {
	__asm__ __volatile__("lock; cmpxchgw %2, (%1)"
	: "+a"(old)
	: "r"(dst), "r"(value)
	: "cc", "memory");
	return old;
}

i8 compare_and_exchange_i8(const i8 *dst, i8 old, i8 value) {
	__asm__ __volatile__("lock; cmpxchgb %2, (%1)"
	: "+a"(old)
	: "r"(dst), "r"(value)
	: "cc", "memory");
	return old;
}
