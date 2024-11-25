#ifndef _INCLUDE_KERNEL_H
#define _INCLUDE_KERNEL_H

#define K_SPACE_START 0xffff800000000000

#define K_SEG_SELECTOR_CODE 0x8
#define K_SEG_SELECTOR_DATA 0x10
#define U_SEG_SELECTOR_CODE 0x18
#define U_SEG_SELECTOR_DATA 0x20

#include "setup.h"

void kernel_init (struct ka *pka);

#endif
