#ifndef _INCLUDE_INTR_H
#define _INCLUDE_INTR_H

#include "types.h"

/* Control port of master chip. */
#define PIC_M_CTRL 0x20

/* Data port of master chip. */
#define PIC_M_DATA 0x21

/* Control port of slave chip. */
#define PIC_S_CTRL 0xa0

/* Data port of slave chip. */
#define PIC_S_DATA 0xa1

/* The count of idt entity. */
#define IDTE_CNT 0x30

/* The attribute of kernel's interrupt gate. */
#define K_GATE_INTR_ATTR 0x8e00

/* The attribute of kernel's trap gate. */
#define K_GATE_TRAP_ATTR 0x8f00

/* The attribute of user's interrupt gate. */
#define U_GATE_INTR_ATTR 0xee00

/* The attribute of user's trap gate. */
#define U_GATE_TRAP_ATTR 0xef00

/* The system-clock interrupt vector number. */
#define IV_CLOCK 0x20

/* The system call interrupt vector number. */
#define IV_SYS_CALL 0x2f

/* idt entity */
struct idte {
	u16 offset_low;
	u16 selector;
	u16 attribute;
	u16 offset_mid;
	u32 offset_high;
	u32 reserved;
} __attribute__((packed));

/* idt register */
struct idtr {
	u16 limit;
	u64 offset;
} __attribute__((packed));

void open_intr (void);

void close_intr (void);

void init_intr (void);

#endif
