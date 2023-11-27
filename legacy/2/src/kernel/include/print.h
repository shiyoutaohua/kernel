#ifndef _INCLUDE_PRINT_H
#define _INCLUDE_PRINT_H

#include "types.h"

int putchar (char c);

int putstr (char* str);

u16 get_cursor (void);

void set_cursor (u16);

void cls();

#endif
