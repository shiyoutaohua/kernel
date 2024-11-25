VIDEO_BASE equ 0xffff8000000b8000

[bits 64]

global putchar
putchar:
	push rbp
	mov rbp, rsp
	; 获取光标->cx
	xor rcx, rcx
	mov dx, 0x3d4
	mov al, 0xe
	out dx, al
	mov dx, 0x3d5
	in al, dx
	mov ch, al
	mov dx, 0x3d4
	mov al, 0xf
	out dx, al
	mov dx, 0x3d5
	in al, dx
	mov cl, al

	.parse_char:
	cmp di, 0xa
	jz .is_lf
	cmp di, 0xd
	jz .is_cr

	.put_printable:
	; 待打印字符及属性di, 光标位置cx
	add di, 0x700
	shl cx, 1
	mov r8, VIDEO_BASE
	add r8, rcx
	mov [r8], di
	shr cx, 1
	inc cx
	cmp cx, 2000
	jl .set_cursor
	jnl .roll_one_line

	.is_lf:
	xor dx, dx
	mov ax, cx
	mov si, 80
	div si
	sub cx, dx
	add cx, 80
	cmp cx, 2000
	jl .set_cursor
	jnl .roll_one_line

	.is_cr:
	xor dx, dx
	mov ax, cx
	mov si, 80
	div si
	sub cx, dx
	jmp .set_cursor

	; 滚屏一行
	.roll_one_line:
	cld
	mov ecx, 960
	mov rsi, VIDEO_BASE
	add rsi, 0xa0
	mov rdi, VIDEO_BASE
	rep movsd
	mov r10, VIDEO_BASE
	add r10, 3840
	mov rcx, 80
	.L0:
	mov word [r10], 0x720
	add r10, 2
	loop .L0
	mov cx, 1920

	; 设置光标<-cx
	.set_cursor:
	mov dx, 0x3d4
	mov al, 0xe
	out dx, al
	mov dx, 0x3d5
	mov al, ch
	out dx, al
	mov dx, 0x3d4
	mov al, 0xf
	out dx, al
	mov dx, 0x3d5
	mov al, cl
	out dx, al
	mov rax, 0
	pop rbp
	ret

global putstr
putstr:
	push rbp
	mov rbp, rsp
	.L1:
	xor rax, rax
	mov al, [rdi]
	cmp al, 0
	jz .str_over
	push rdi
	mov di, ax
	call putchar
	pop rdi
	inc rdi
	jmp .L1
	.str_over:
	pop rbp
	ret

global get_cursor
get_cursor:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; 获取光标位置高8位
	mov dx, 0x3d4
	mov al, 0xe
	out dx, al
	mov dx, 0x3d5
	in al, dx
	mov ah, al
	; 获取光标位置低8位
	mov dx, 0x3d4
	mov al, 0xf
	out dx, al
	mov dx, 0x3d5
	in al, dx
	pop rbp
	ret

global set_cursor
set_cursor:
	push rbp
	mov rbp, rsp
	mov rcx, rdi
	; 设置光标位置高8位
	mov dx, 0x3d4
	mov al, 0xe
	out dx, al
	mov dx, 0x3d5
	mov al, ch
	out dx, al
	; 设置光标位置低8位
	mov dx, 0x3d4
	mov al, 0xf
	out dx, al
	mov dx, 0x3d5
	mov al, cl
	out dx, al
	pop rbp
	ret

global cls
cls:
	push rbp
	mov rbp, rsp
	mov r10, VIDEO_BASE
	mov rcx, 2000
	.L2:
	mov word [r10], 0x720
	add r10, 2
	loop .L2
	; 重置光标
	mov dx, 0x3d4
	mov al, 0xe
	out dx, al
	mov dx, 0x3d5
	mov al, 0
	out dx, al
	mov dx, 0x3d4
	mov al, 0xf
	out dx, al
	mov dx, 0x3d5
	mov al, 0
	out dx, al
	pop rbp
	ret
