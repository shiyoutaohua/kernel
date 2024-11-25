; 直接调用Linux中断打印字符串
; nasm -f elf demo1.asm -o demo1.o
; ld -melf_i386 -o demo1 demo1.o
; chmod 755 demo1
; ./demo1

hole_str:
   db "hello world !", 0xa
   var_str_len equ $ - hole_str

global _start
_start:
   mov eax, 4
   mov ebx, 1
   mov ecx, hole_str
   mov edx, var_str_len
   int 0x80;
   
   mov eax, 1
   int 0x80
