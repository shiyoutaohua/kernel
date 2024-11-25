; loader-3.asm
; 进入保护模式
%include "boot.inc"

SECTION loader vstart=LOADER_BASE_ADDR
	mov sp, LOADER_BASE_ADDR
	call proc_loader_start
	jmp proc_enter_protect_model

proc_loader_start:
	mov ax, 0xb800
	mov gs, ax
	mov byte [gs:0xa0], 'L'
	ret

proc_enter_protect_model:
	; 禁止外部中断
	cli
	; 开启A20
	in al, 0x92
	or al, 2
	out 0x92, al
	; 加载gdt
	lgdt [hole_gdt32_ptr]
	; 设置CR0.PE
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	; 远跳转刷新指令流水线
	jmp dword var_selector_code32:proc_protect_mode_start

[bits 32]
proc_protect_mode_start:
	mov ax, var_selector_data32
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ss, ax
	mov gs, ax
	jmp $

hole_gdt32:
	dq 0
hole_desc_code32:
	dq DESC_CODE32
hole_desc_data32:
	dq DESC_DATA32

	var_gdt32_len       equ $ - hole_gdt32
	var_selector_code32 equ hole_desc_code32 - hole_gdt32
	var_selector_data32 equ hole_desc_data32 - hole_gdt32

hole_gdt32_ptr:
	dw var_gdt32_len - 1
	dd hole_gdt32
