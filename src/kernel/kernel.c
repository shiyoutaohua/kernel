#define _KERNEL_C

#include "include/print.h"
#include "include/timer.h"
#include "include/intr.h"
#include "include/kernel.h"
#include "include/string.h"
#include "include/mm.h"

int main (struct ka *pka) {
	putstr("OS: Hello world!\n");
	kernel_init(pka);
	while(true);
	return 0;
}

void kernel_init (struct ka *pka) {
	each_ka(pka);
	init_mpool(64 << 20);
	init_timer();
	init_intr();
	// alloc_page(3);
}
