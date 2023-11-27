; mbr-1.asm
; 清屏功能[BIOS中断:0x10 | 滚屏功能: 0x06]
; 滚屏实际是用cs和ds中的坐标画了一个矩形,并根据al指定滚动行数,
; 并使用bx指定新增行的显示颜色等属性,默认黑底白字
SECTION mbr vstart=0x7c00
   mov ax, cs     ; 由BIOS远跳转MBR时, cs被置0
   mov sp, 0x7c00
   
   ; clean screen
   mov ax, 0x600  ; ah=0x06 清屏; al=0所有行
   mov cx, 0      ; 左上[0,0]
   mov dx, 0x184f ; 右下[24,79]
   int 0x10
   
   jmp $
   
   times 510-($-$$) db 0
   dw 0xaa55
   
