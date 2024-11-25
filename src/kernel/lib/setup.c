#define _LIB_SETUP_C

#include "../include/string.h"
#include "../include/print.h"
#include "../include/setup.h"

void each_ka (struct ka *pka) {
	while (pka != TKA_NONE) {
		switch (pka->hdr.type) {
			case TKA_CMD: {
				putstr(pka->body.cmd.value);
				putchar('\n');
				break;
			}
			case TKA_MEM: {
				char buff[20];
				putstr("Mem [");
				putstr(i2s(pka->body.mem.start, buff, HEX));
				putstr(" ");
				putstr(i2s(pka->body.mem.size, buff, HEX));
				putstr(" ");
				putstr(i2s(pka->body.mem.attr, buff, HEX));
				putstr("]\n");
				break;
			}
		}
		pka = (struct ka*)pka->hdr.next;
	}
}
