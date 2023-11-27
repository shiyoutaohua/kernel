; 调用约定16: 整型参数[1..3]->[di, si, dx], 其余自右向左依次压栈, 被调用者保存寄存器, 调用者清理栈空间, 返回值ax
; 其中[ax, di, si, dx]为易失寄存器，各方无义务保存其状态
; memecoy (dest, src, size);
[bits 16]
proc16_mem_cpy:
	cld
	mov cx, dx
	rep movsb
	ret

; 调用约定64: 整型参数[1..6]->[rdi, rsi, rdx, rcx, r8, r9], 其余自右向左依次压栈, 被调用者保存寄存器, 调用者清理栈空间, 返回值rax,
; 其中[rax, rdi, rsi, rdx, rcx, r8, r9]为易失寄存器，各方无义务保存其状态
; memecoy (dest, src, size);
[bits 64]
proc64_mem_cpy:
	cld
	mov rcx, rdx
	rep movsb
	ret
