; loader-1.asm
%include "boot.inc"

SECTION loader vstart=LOADER_BASE_ADDR
	mov sp, LOADER_BASE_ADDR

	; print string
	mov ax, 0xb800
	mov gs, ax

	mov byte [gs:0xa0], 'L'
	mov byte [gs:0xa2], 'o'
	mov byte [gs:0xa4], 'a'
	mov byte [gs:0xa6], 'd'
	mov byte [gs:0xa8], 'e'
	mov byte [gs:0xaa], 'r'

	jmp $
