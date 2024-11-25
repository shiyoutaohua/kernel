; loader-1.asm
%include "boot.inc"

SECTION loader vstart=LOADER_BASE_ADDR

   ; print string
   mov ax, 0xb800
   mov gs, ax
   
   mov byte [gs:0xa0], 'L'
   mov byte [gs:0xa1], 0x84
   
   mov byte [gs:0xa2], 'o'
   mov byte [gs:0xa3], 0x84
   
   mov byte [gs:0xa4], 'a'
   mov byte [gs:0xa5], 0x84
   
   mov byte [gs:0xa6], 'd'
   mov byte [gs:0xa7], 0x84
   
   mov byte [gs:0xa8], 'e'
   mov byte [gs:0xa9], 0x84
   
   mov byte [gs:0xaa], 'r'
   mov byte [gs:0xab], 0x84
   
   jmp $
   
