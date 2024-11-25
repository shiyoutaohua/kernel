; loader-1.asm
; 探测内存
; 加载GDT
; 开启分页
; 进入保护模式
; 加载内核
%include "boot.inc"

SECTION loader vstart=LOADER_BASE_ADDR
   call proc_loader_start
   call proc_detect_mem
   jmp proc_enter_protect_model
   
hole_gdt_item0:
   dq 0

; 代码段[0x00CF9A000000FFFF] 基址:0x0 界限:0xFFFFF size=4K*1M
hole_gdt_item1:
   dd 0x0000FFFF
   dd DESC_CODE_HIGH4B

; 数据段[0x00CF92000000FFFF] 基址:0x0 界限:0xFFFFF size=4K*1M
hole_gdt_item2:
   dd 0x0000FFFF
   dd DESC_DATA_HIGH4B

; 显存文本模式段[0x00C0920B80000007] 基址:0xB8000 限制:0x7 size=4K*8
hole_gdt_item3:
   dd 0x80000007
   dd DESC_VIDEO_HIGH4B

   var_gdt_size  equ $ - hole_gdt_item0
   var_gdt_limit equ var_gdt_size - 1
   var_selector_code equ (0x0001 << 3) + TI_GDT + RPL0
   var_selector_data equ (0x0002 << 3) + TI_GDT + RPL0
   var_selector_video equ (0x0003 << 3) + TI_GDT + RPL0
   ; 预留60个段描述符的位置
   times 60 dq 0

; 定义gdt指针
hole_gdt_ptr:
   dw var_gdt_limit
   dd hole_gdt_item0

hole_ards_count:
   dw 0;

hole_ards_list:
   times 300 db 0
   
proc_loader_start:
   mov ax, 0xb800
   mov gs, ax
   mov byte [gs:0xa0], 'L'
   ret
   
proc_detect_mem:
   xor ebx, ebx
   mov edx, 0x534d4150
   mov di, hole_ards_list
   loop_e820:
      mov eax, 0x0000e820
      mov ecx, 20
      int 0x15
      jc proc_hlt
      add di, cx
      inc word [hole_ards_count]
      cmp ebx, 0
      jnz loop_e820
   ret
   
; 进入保护模式
proc_enter_protect_model:
   ; 开启A20
   in al, 0x92
   or al, 0000_0010B
   out 0x92, al
   
   ; 加载gdt
   lgdt [hole_gdt_ptr]
   
   ; cr0 PM位置1
   mov eax, cr0
   or eax, 0x00000001
   mov cr0, eax
   
   ; 远跳转刷新指令流水线
   jmp dword var_selector_code:proc_protect_mode_start
   
proc_hlt:
   hlt
   
[bits 32]
proc_protect_mode_start:
   mov ax, var_selector_data
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov ss, ax
   mov ax, var_selector_video
   mov gs, ax
   mov esp, LOADER_BASE_ADDR
   
   mov byte [gs:0x140], 'P'
   call proc_setup_pde_pte
   jmp proc_enable_paging

proc_setup_pde_pte:
   ; 创建内核PDE
   mov eax, PG_DIR_TAB_ADDR
   mov ebx, PG_DIR_TAB_ADDR
   add eax, 0x1000
   or eax, PG_USER_WRITE_PRESENT
   mov ecx, 256
   mov esi, 768
   loop_create_kernel_pde:
      mov [ebx + esi * 4], eax
      inc esi
      add eax, 0x1000
      loop loop_create_kernel_pde
   
   ; 使第0个PDE和第768个PDE指向同一个页表
   mov eax, PG_DIR_TAB_ADDR
   add eax, 0x1000
   or eax, PG_USER_WRITE_PRESENT
   mov [PG_DIR_TAB_ADDR + 0x00], eax
   
   ; 低端16M物理内存PTE
   mov ebx, PG_DIR_TAB_ADDR
   add ebx, 0x1000
   mov ecx, 4096
   mov eax, 0
   mov edx, PG_USER_WRITE_PRESENT
   loop_create_pte:
      mov [ebx + eax * 4], edx
      add edx, 4096
      inc eax
      loop loop_create_pte
   ret
   
proc_enable_paging:
   sgdt [hole_gdt_ptr]
   ; 显存段转为虚拟地址
   mov ebx, [hole_gdt_ptr + 2]
   or dword [ebx + 0x18 + 4], 0xc0000000
   ; gdt指针转为虚拟地址
   add dword [hole_gdt_ptr + 2], 0xc0000000
   ; 栈指针转为虚拟地址
   add esp, 0xc0000000
   ; 写入页目录表地址
   mov eax, PG_DIR_TAB_ADDR
   mov cr3, eax
   ; 开启分页标志cr0的pg位
   mov eax, cr0
   or eax, 0x80000000
   mov cr0, eax
   lgdt [hole_gdt_ptr]
   ; 重新加载显存段
   mov ax, var_selector_video
   mov gs, ax
   mov byte [gs:0x1E0], 'V' 
   call proc_load_kernel
   call proc_parse_kernel
   mov esp, KERNEL_STACK_ADDR
   jmp KERNEL_ENTRY_POINT
   
proc_parse_kernel:
   xor eax, eax
   xor ebx, ebx
   xor ecx, ecx
   xor edx, edx
   
   mov ebx, [KERNEL_BASE_ADDR + 28] ; Program Header偏移地址
   mov dx, [KERNEL_BASE_ADDR + 42]  ; Program Header大小
   mov cx, [KERNEL_BASE_ADDR + 44]  ; Program Header个数
   add ebx, KERNEL_BASE_ADDR
   loop_each_segment:
      cmp byte [ebx], 0
      je proc_pt_null
      push dword [ebx + 16]
      mov eax, [ebx + 4]
      add eax, KERNEL_BASE_ADDR
      push eax
      push dword [ebx + 8]
      call proc_mem_copy
      add esp,12 ; 清理压入的参数
   proc_pt_null:
      add ebx, edx
      loop loop_each_segment
      
   ret
   
proc_mem_copy:
   cld
   push ebp
   mov ebp, esp
   push ecx
   mov edi, [ebp + 8]	   ; dst
   mov esi, [ebp + 12]	   ; src
   mov ecx, [ebp + 16]	   ; size
   rep movsb
   ;恢复环境
   pop ecx		
   pop ebp
   ret
   
   
proc_load_kernel:
   mov eax, KERNEL_START_SECTOR
   mov ebx, KERNEL_BASE_ADDR
   mov ecx, KERNEL_SECTOR_COUNT
   call proc_read_disk
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
