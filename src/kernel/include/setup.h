#ifndef _INCLUDE_SETUP_H
#define _INCLUDE_SETUP_H

#include "types.h"

enum tka {
	/* The next pointer of last node in the list. */
	TKA_NONE = 0x0,
	TKA_CORE = 0x1,
	TKA_MEM = 0x2,
	TKA_CMD = 0xff
};

struct ka_mem {
	u64 start;
	u64 size;
	u8 attr;
} __attribute__((packed));

struct ka_cmd {
	/* Minimum size */
	char value[1];
};

/* Structure passed to kernel to tell it about the hardware it's running on. */
struct ka {
	struct __attribute__((packed)) {
		u8 type;
		u64 next;
	} hdr;
	union {
		struct ka_mem mem;
		struct ka_cmd cmd;
	} body;
} __attribute__((packed));

void each_ka (struct ka *pka);

#endif
