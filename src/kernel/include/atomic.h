#ifndef _INCLUDE_ATOMIC_H
#define _INCLUDE_ATOMIC_H

#include "types.h"

i64 compare_and_exchange_i64(const i64 *dst, i64 old, i64 value);

i32 compare_and_exchange_i32(const i32 *dst, i32 old, i32 value);

i16 compare_and_exchange_i16(const i16 *dst, i16 old, i16 value);

i8 compare_and_exchange_i8(const i8 *dst, i8 old, i8 value);

#endif
