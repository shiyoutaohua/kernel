; loader-1.asm
; 探测内存
; 加载GDT
; 进入保护模式
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
   
   jmp $

