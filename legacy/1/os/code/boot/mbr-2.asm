; mbr-2.asm
; 清屏功能[BIOS中断:0x10 | 重置显示模式功能: 0x00]
; 打印字符串[操作显存]
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
   mov byte [gs:0x02], 'B'
   mov byte [gs:0x04], 'R'

   jmp $

   times 510-($-$$) db 0
   dw 0xaa55
