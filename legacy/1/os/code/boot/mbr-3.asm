; mbr-3.asm
; 将loader载入内存
%include "boot.inc"

SECTION mbr vstart=0x7c00
   mov ax, cs     ; 由BIOS跳转MBR时, cs被置0
   mov sp, 0x7c00
   
   ; clean screen
   mov ax, 0x03 ;ah=0x00 重置; al=03 文本80x25
   int 0x10
   
   ; print string
   mov ax, 0xb800
   mov gs, ax
   mov byte [gs:0x00], 'M'
   mov byte [gs:0x01], 0x84
   mov byte [gs:0x02], 'B'
   mov byte [gs:0x03], 0x84
   mov byte [gs:0x04], 'R'
   mov byte [gs:0x05], 0x84
   
   mov esi, LOADER_START_SECTOR
   mov di, LOADER_SECTOR_COUNT
   mov bx, LOADER_BASE_ADDR
   call proc_read_disk
   jmp LOADER_BASE_ADDR
   
proc_read_disk:
   ; 设置待读取扇区数
   mov ax, di
   mov dx, 0x1f2
   out dx, ax
   ; 写入LBA地址前24位
   mov eax, esi
   mov dx, 0x1f3
   out dx, al
   
   shr eax, 8
   mov dx, 0x1f4
   out dx, al
   
   shr eax, 8
   mov dx, 0x1f5
   out dx, al
   ; 设置Device寄存器
   mov al, 0xe0
   mov dx, 0x1f6
   out dx, al
   ; 写入读命令
   mov al, 0x20
   mov dx, 0x1f7
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
      mov [bx], ax
      add bx, 2
      loop loop_go_read
   ret
      
   times 510-($-$$) db 0
   dw 0xaa55
