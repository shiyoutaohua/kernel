; 打印单个字符
[bits 32]
section .text

global print_char
print_char:
   ; 获取光标位置高8位
   mov dx, 0x3d4
   mov al, 0x0e
   out dx, al
   mov dx, 0x3d5
   in al, dx
   mov ah, al
   ; 获取光标位置低8位
   mov dx, 0x3d4
   mov al, 0x0f
   out dx, al
   mov dx, 0x3d5
   in al, dx
   ; 光标位置存入bx
   mov bx, ax
   ; 从栈中获取待打印字符
   mov esi, [esp + 4]
   
   jmp $
