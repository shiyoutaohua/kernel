; loader-2.asm
; 打印字符串[BIOS中断:0x10 | 打印字符串: 0x13]
%include "boot.inc"

SECTION loader vstart=LOADER_BASE_ADDR
	mov sp, LOADER_BASE_ADDR
	call proc_loader_start
	jmp $

proc_loader_start:
	mov ax, 0x1301             ; ah: 13 打印字符串, al: 01 光标移至字符串尾
	mov bx, 0x000f             ; bh: 页码, bl: 颜色属性
	mov dx, 0x0100             ; dh: 行, dl: 列
	xor si, si
	mov es, si
	mov bp, hole_loader_msg    ; es:bp 字符串基址
	mov cx, var_loader_msg_len ; cx 字符串长度
	int 0x10
	ret

hole_loader_msg:
	db "Loader"
	var_loader_msg_len equ $ - hole_loader_msg
