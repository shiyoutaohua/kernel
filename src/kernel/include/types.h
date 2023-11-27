#ifndef _INCLUDE_TYPES_H
#define _INCLUDE_TYPES_H

typedef signed char i8;
typedef signed short int i16;
typedef signed int i32;
typedef signed long long int i64;
typedef unsigned char u8;
typedef unsigned short int u16;
typedef unsigned int u32;
typedef unsigned long long int u64;
typedef float f32;
typedef double f64;

#define null ((void*)0)

typedef u8 bool;
#define true 1
#define false 0

#define offset_of(type, member) ((u64)&((type*)0)->member)
#define container_of(ptr, type, member) ((type*)((char*)ptr - offset_of(type, member)))

#endif
