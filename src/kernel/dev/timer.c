#define _DEV_TIMER_C

#include "../include/io.h"
#include "../include/timer.h"

#define PIT_CLK_INPUT 1193180
#define PIT_CRTL_PORT 0x43
#define CONTRER0_DATA_PORT 0x40
#define COUNTER0_NO 0
#define COUNTER0_WORK_MODE 2
#define COUNTER0_VALUE (PIT_CLK_INPUT / CLOCK_INTR_FREQUENCY)
#define COUNTER0_LATCH_RW 3

void init_timer (void) {
	outb(PIT_CRTL_PORT, (u8) COUNTER0_NO << 6 | COUNTER0_LATCH_RW << 4 | COUNTER0_WORK_MODE << 1);
	outb(CONTRER0_DATA_PORT, (u8) COUNTER0_VALUE);
	outb(CONTRER0_DATA_PORT, (u8) (COUNTER0_VALUE >> 8));
}
