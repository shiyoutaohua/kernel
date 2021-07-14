#define _LIB_INTR_C

#include "../include/print.h"
#include "../include/kernel.h"
#include "../include/intr.h"
#include "../include/io.h"

extern void *imt[IDTE_CNT];

static struct idte idt[IDTE_CNT];

/* Interrupt service routine. */
void isr (u8 iv) {
	switch (iv) {
		case IV_CLOCK:
			putstr(" iv0x20 ");
			break;
		case IV_SYS_CALL:
			putstr(" iv0x2f ");
			break;
		default:
			break;
	}
}

static void init_pic (void) {
	/* init master chip. */
	outb(PIC_M_CTRL, 0x11);
	outb(PIC_M_DATA, IV_CLOCK);
	outb(PIC_M_DATA, 0x04);
	outb(PIC_M_DATA, 0x01);
	/* init slave chip. */
	outb(PIC_S_CTRL, 0x11);
	outb(PIC_S_DATA, 0x28);
	outb(PIC_S_DATA, 0x02);
	outb(PIC_S_DATA, 0x01);
	/* Open IR0 on master chip. */
	outb(PIC_M_DATA, 0xfe);
	outb(PIC_S_DATA, 0xff);
}

static void init_idt (void) {
	struct idte gate;
	gate.selector = K_SEG_SELECTOR_CODE;
	gate.reserved = 0;
	for (int i = 0; i < IDTE_CNT; i++) {
		gate.attribute = (i == IV_SYS_CALL) ? U_GATE_INTR_ATTR : K_GATE_INTR_ATTR;
		if (i < 0x12) gate.attribute = (i > 0x2 && i < 0x6) ? U_GATE_TRAP_ATTR : K_GATE_TRAP_ATTR;
		gate.offset_low = (u64)imt[i];
		gate.offset_mid = (u64)imt[i] >> 16;
		gate.offset_high = (u64)imt[i] >> 32;
		idt[i] = gate;
	}
	struct idtr ir;
	ir.limit = (u16)(sizeof(idt) - 1);
	ir.offset = (u64)idt;
	__asm__ __volatile__ ("lidt %0;" : : "m"(ir));
}

void open_intr (void) {
	__asm__ __volatile__ ("sti;");
}

void close_intr (void) {
	__asm__ __volatile__ ("cli;");
}

void init_intr (void) {
	init_idt();
	init_pic();
	open_intr();
}
