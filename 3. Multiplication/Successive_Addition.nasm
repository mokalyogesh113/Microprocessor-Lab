%macro print 2
        mov eax,4
        mov ebx,1
        mov ecx,%1
        mov edx,%2
        int 80h
%endmacro

%macro scan 2
        mov eax,3
        mov ebx,2
        mov ecx,%1
        mov edx,%2
        int 80h
%endmacro

section .data
        m1 db 10,13,"Enter the 2-digit number "
        m1_len equ $-m1
        
        m2 db 10,13,"The Multiplication using Successive Addition is :- "
        m2_len equ $-m2
        
        nl db 10
        
section .bss
        numascii resb 3
        dispbuff resb 4
        multi1 resb 2
        
section .text
global _start
_start:
        print m1,m1_len
        scan numascii,3
        mov bx,00
        call atoh
        
        mov [multi1],bl
        print m1,m1_len
        scan numascii,3
        print m2,m2_len
        call atoh
        
        mov eax,[multi1]
        mov ecx,00h
Addup:        
        add ecx,eax
        dec bl
        jnz Addup
        
        mov bx,cx
        call htoa
mov eax,1
int 80h

atoh:
        mov bx,00
        mov cx,2
        mov esi,numascii
p1:
        rol bl,04
        mov al,[esi]
        cmp al,39h
        jbe p2
        sub al,07h
p2:
        sub al,30h
        add bl,al
        inc esi
        dec cx
        jnz p1
ret

htoa:
        mov esi,dispbuff
        mov cx,4
d1:
        rol bx,4
        mov al,bl
        and al,0fh
        cmp al,09h
        jbe d2
        add al,07h
d2:     add al,30h
        mov [esi],al       
        inc esi
        dec cx
        jnz d1
        
        print dispbuff,4
        print nl,1
ret


