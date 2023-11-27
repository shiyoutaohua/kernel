; loader-5.asm
; 加载并跳转至内核代码
%include "boot.inc"

SECTION loader vstart=LOADER_BASE_ADDR
	mov sp, LOADER_BASE_ADDR
	call proc_loader_start
	jmp proc_enter_long_model

proc_loader_start:
	mov ax, 0xb800
	mov gs, ax
	mov byte [gs:0xa0], 'L'
	ret

proc_enter_long_model:
	call proc_gen_page_tab
	; 屏蔽外部中断
	cli
	; 开启A20
	in al, 0x92
	or al, 2
	out 0x92, al
	; 加载GDT
	lgdt [hole_gdt64_ptr]
	; 设置CR4.PAE
	mov eax, cr4
	bts eax, 5
	mov cr4, eax
	; 加载PML4
	mov eax, 0x90000
	mov cr3, eax
	; 设置EFER.LME
	mov ecx, 0C0000080h
	rdmsr
	bts eax, 8
	wrmsr
	; 设置CR0.PE和CR0.PG
	mov eax, cr0
	bts eax, 0
	bts eax, 31
	mov cr0, eax
	; 远跳转刷新指令流水线
	jmp dword var_selector_code64:proc_long_mode_start

proc_gen_page_tab:
	; 使用4K页面且仅映射了前16M物理内存
	push ds
	mov ax, 0x9000
	mov ds, ax
	; PML4E/256T
	mov dword [0x0000], 0x91003
	mov dword [0x0800], 0x91003
	; PDPTE/512G
	mov dword [0x1000], 0x92003
	; PDE/1G
	mov dword [0x2000], 0x93003
	mov dword [0x2008], 0x94003
	mov dword [0x2010], 0x95003
	mov dword [0x2018], 0x96003
	mov dword [0x2020], 0x97003
	mov dword [0x2028], 0x98003
	mov dword [0x2030], 0x99003
	mov dword [0x2038], 0x9a003
	; PTE/2M
	xor eax, eax
	mov ebx, 0x3000
	mov ecx, 4096
	mov edx, 0x0003
	loop_create_pte:
		mov [ebx + eax * 8], edx
		add edx, 0x1000
		inc eax
		loop loop_create_pte
	pop ds
	ret

[bits 64]
proc_long_mode_start:
	; 设置内核段
	mov ax, var_selector_data64
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ss, ax
	mov gs, ax
	; GDT指针转换为虚拟地址
	sgdt [hole_gdt64_ptr]
	mov rbx, KERNEL_SPACE_START
	add qword [hole_gdt64_ptr + 2], rbx
	lgdt [hole_gdt64_ptr]
	; 设置内核栈
	mov rsp, KERNEL_STACK_ADDR
	call proc_load_kernel
	call proc_init_kernel
	; 跳转至内核elf64.e_entry
	mov rax, KERNEL_LOAD_ADDR + 24
	mov rax, [rax]
	jmp rax

proc_load_kernel:
	mov eax, KERNEL_START_SECTOR
	mov rbx, KERNEL_LOAD_ADDR
	mov ecx, KERNEL_SECTOR_COUNT
	call proc_read_disk
	ret

proc_init_kernel:
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	xor rdx, rdx
	mov r10, KERNEL_LOAD_ADDR
	mov r11, KERNEL_LOAD_ADDR + 32
	mov r12, KERNEL_LOAD_ADDR + 54
	mov r13, KERNEL_LOAD_ADDR + 56
	mov rbx, [r11]
	mov cx, [r13]
	mov dx, [r12]
	add rbx, r10
	loop_each_segment:
		cmp word [rbx], 0
		je loop_ptnull
		cld
		push rcx
		mov rcx, [rbx + 32]
		mov rax, [rbx + 8]
		add rax, r10
		mov rsi, rax
		mov rdi, [rbx + 16]
		rep movsb
		pop rcx
	loop_ptnull:
		add rbx, rdx
		loop loop_each_segment
	ret

proc_read_disk:
	; 备份
	mov esi, eax
	mov edi, ecx
	; 设置待读取扇区数
	mov dx, 0x1f2
	mov al, cl
	out dx, al
	mov eax, esi ; 恢复
	; 写入LBA地址前24位
	mov dx, 0x1f3
	out dx, al

	mov dx, 0x1f4
	shr eax, 8
	out dx, al

	mov dx, 0x1f5
	shr eax, 8
	out dx, al
	; 写入LBA地址高4位并设置Device寄存器
	mov dx, 0x1f6
	shr eax, 8
	or al,0xe0
	out dx, al
	; 写入读命令
	mov dx, 0x1f7
	mov al, 0x20
	out dx, al
	loop_not_ready:
		in al, dx
		and al, 0x88
		cmp al, 0x08
		jnz loop_not_ready
	mov ax, di
	mov dx, 256
	mul dx
	; ax * dx结果并不大,所有只取ax中低16位,dx中高16位不用
	mov cx, ax
	mov dx, 0x1f0
	loop_go_read:
		in ax, dx
		mov [ebx], ax
		add ebx, 2
		loop loop_go_read
	ret

hole_gdt64:
	dq 0
hole_desc_code64:
	dq DESC_CODE64
hole_desc_data64:
	dq DESC_DATA64
hole_gdt64_ptr:
	dw var_gdt64_len - 1
	dq hole_gdt64
; 变量汇编后不占内存
var_gdt64_len       equ hole_gdt64_ptr - hole_gdt64
var_selector_code64 equ hole_desc_code64 - hole_gdt64
var_selector_data64 equ hole_desc_data64 - hole_gdt64
