%macro print 2
mov eax,4
mov ebx,2
mov ecx,%1
mov edx,%2
int 0x80
%endmacro

section .data				;.data
pm db 10,13,"Positive Count is "
pm_len equ $-pm

nm db 10,13,"Negative Count is "
nm_len equ $-nm

newline db 10,13,""
len equ $-newline

arr dd 4h,5h,6h,-6h,76h,10h,55h,-100h,56h,-10h,-56h
n equ 10

section .bss				;.bss

p_count resb 1
n_count resb 1
char_count resb 1



section .text				;.text

global _start
_start:

mov esi,arr
mov edi,n
mov ebx,0
mov ecx,0

next_num:
mov eax,[esi]
rcl eax,1
jc negative

positive:
inc ebx
jmp next

negative:
inc ecx

next:
add esi,4
dec edi
jnz next_num

mov [p_count],ebx
mov [n_count],ecx

print pm,pm_len
mov eax,[p_count]
call disp32_proc

print nm,nm_len
mov eax,[n_count]
call disp32_proc

print newline,len 

mov eax,1
int 0x80

disp32_proc:
add al,30h
mov [char_count],eax
print char_count,1
ret