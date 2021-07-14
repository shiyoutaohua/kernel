[bits 64]

; Interrupt service routine
extern isr

%define WITH_ERRNO nop
%define WITHOUT_ERRNO push 0

; MK_MONITOR (iv, errno)
%macro MK_MONITOR 2
monitor%1:
	; push interrupt error code
	%2
	push rax
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push rbp
	push rsp
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	mov ax, ds
	push rax
	mov ax, es
	push rax
	mov ax, fs
	push rax
	mov ax, gs
	push rax
	; send EOI
	mov al,0x20
	out 0xa0,al
	out 0x20,al
	; pass iv as input to handler
	mov rdi, %1
	call isr
	pop rax
	mov gs, ax
	pop rax
	mov fs, ax
	pop rax
	mov es, ax
	pop rax
	mov ds, ax
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsp
	pop rbp
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	; skip interrupt error code
	add rsp, 8
	iretq
%endmacro

MK_MONITOR 0x00, WITHOUT_ERRNO
MK_MONITOR 0x01, WITHOUT_ERRNO
MK_MONITOR 0x02, WITHOUT_ERRNO
MK_MONITOR 0x03, WITHOUT_ERRNO
MK_MONITOR 0x04, WITHOUT_ERRNO
MK_MONITOR 0x05, WITHOUT_ERRNO
MK_MONITOR 0x06, WITHOUT_ERRNO
MK_MONITOR 0x07, WITHOUT_ERRNO
MK_MONITOR 0x08, WITH_ERRNO
MK_MONITOR 0x09, WITHOUT_ERRNO
MK_MONITOR 0x0a, WITH_ERRNO
MK_MONITOR 0x0b, WITH_ERRNO
MK_MONITOR 0x0c, WITHOUT_ERRNO
MK_MONITOR 0x0d, WITH_ERRNO
MK_MONITOR 0x0e, WITH_ERRNO
MK_MONITOR 0x0f, WITHOUT_ERRNO
MK_MONITOR 0x10, WITHOUT_ERRNO
MK_MONITOR 0x11, WITH_ERRNO
MK_MONITOR 0x12, WITHOUT_ERRNO
MK_MONITOR 0x13, WITHOUT_ERRNO
MK_MONITOR 0x14, WITHOUT_ERRNO
MK_MONITOR 0x15, WITHOUT_ERRNO
MK_MONITOR 0x16, WITHOUT_ERRNO
MK_MONITOR 0x17, WITHOUT_ERRNO
MK_MONITOR 0x18, WITH_ERRNO
MK_MONITOR 0x19, WITHOUT_ERRNO
MK_MONITOR 0x1a, WITH_ERRNO
MK_MONITOR 0x1b, WITH_ERRNO
MK_MONITOR 0x1c, WITHOUT_ERRNO
MK_MONITOR 0x1d, WITH_ERRNO
MK_MONITOR 0x1e, WITH_ERRNO
MK_MONITOR 0x1f, WITHOUT_ERRNO
MK_MONITOR 0x20, WITHOUT_ERRNO
MK_MONITOR 0x21, WITHOUT_ERRNO
MK_MONITOR 0x22, WITHOUT_ERRNO
MK_MONITOR 0x23, WITHOUT_ERRNO
MK_MONITOR 0x24, WITHOUT_ERRNO
MK_MONITOR 0x25, WITHOUT_ERRNO
MK_MONITOR 0x26, WITHOUT_ERRNO
MK_MONITOR 0x27, WITHOUT_ERRNO
MK_MONITOR 0x28, WITHOUT_ERRNO
MK_MONITOR 0x29, WITHOUT_ERRNO
MK_MONITOR 0x2a, WITHOUT_ERRNO
MK_MONITOR 0x2b, WITHOUT_ERRNO
MK_MONITOR 0x2c, WITHOUT_ERRNO
MK_MONITOR 0x2d, WITHOUT_ERRNO
MK_MONITOR 0x2e, WITHOUT_ERRNO
MK_MONITOR 0x2f, WITHOUT_ERRNO

; Interrupt monitor
global imt
imt:
	dq monitor0x00
	dq monitor0x01
	dq monitor0x02
	dq monitor0x03
	dq monitor0x04
	dq monitor0x05
	dq monitor0x06
	dq monitor0x07
	dq monitor0x08
	dq monitor0x09
	dq monitor0x0a
	dq monitor0x0b
	dq monitor0x0c
	dq monitor0x0d
	dq monitor0x0e
	dq monitor0x0f
	dq monitor0x10
	dq monitor0x11
	dq monitor0x12
	dq monitor0x13
	dq monitor0x14
	dq monitor0x15
	dq monitor0x16
	dq monitor0x17
	dq monitor0x18
	dq monitor0x19
	dq monitor0x1a
	dq monitor0x1b
	dq monitor0x1c
	dq monitor0x1d
	dq monitor0x1e
	dq monitor0x1f
	dq monitor0x20
	dq monitor0x21
	dq monitor0x22
	dq monitor0x23
	dq monitor0x24
	dq monitor0x25
	dq monitor0x26
	dq monitor0x27
	dq monitor0x28
	dq monitor0x29
	dq monitor0x2a
	dq monitor0x2b
	dq monitor0x2c
	dq monitor0x2d
	dq monitor0x2e
	dq monitor0x2f
