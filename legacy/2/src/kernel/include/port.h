#ifndef _INCLUDE_PORT_H
#define _INCLUDE_PORT_H

#include "types.h"

static inline void outb (u16 port, u8 data)
{
	__asm__ __volatile__ ("outb %b0, %w1" : : "a" (data), "d" (port));
}

static inline void outw (u16 port, u16 data)
{
	__asm__ __volatile__ ("outw %w0, %w1" : : "a" (data), "d" (port));
}

static inline u8 inb (u16 port)
{
	u8 data;
	__asm__ __volatile__ ("inb %w1, %b0" : "=a" (data) : "d" (port));
	return data;
}

static inline u16 inw (u16 port)
{
	u16 data;
	__asm__ __volatile__ ("inw %w1, %w0" : "=a" (data) : "d" (port));
	return data;
}

#endif
