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
        menu_msg db 10,13,"--------------------Menu--------------------"
                 db 10,13,"1. Multiplication using Successive Addition "
                 db 10,13,"2. Multiplication using Add and Shift "
                 db 10,13,"3. Exit"
                 db 10,13,"Enter choice :- "
        menu_msg_len equ $-menu_msg
        
        wrong_msg db 10,13,"Wrong Choice ",10
        wrong_msg_len equ $-wrong_msg
        
        m1 db 10,13,"Enter the 2-digit number "
        m1_len equ $-m1
        
        s_msg db 10,13,"The Multiplication using Successive Addition is :- "
        s_msg_len equ $-s_msg
        
        a_msg db 10,13,"The Multiplication using Add & Shift is :- "
        a_msg_len equ $-a_msg
        
        nl db 10
        
section .bss
        numascii resb 3
        dispbuff resb 4
        multi1 resb 2
        multi2 resb 2

section .text
global _start
_start:
        print menu_msg,menu_msg_len
        scan numascii,2
        
        cmp byte[numascii],'1'
        je succ_add
        
        cmp byte[numascii],'2'
        je add_shift
        
        cmp byte[numascii],'3'
        je Exit
        
        print wrong_msg,wrong_msg_len
        jmp _start
        
succ_add:                               ; Logic for multiplication using Successive Addition
        
        print m1,m1_len
        scan numascii,3
        mov bx,00
        call atoh
        
        mov [multi1],bl
        print m1,m1_len
        scan numascii,3
        print s_msg,s_msg_len
        call atoh
        
        mov eax,[multi1]
        mov ecx,00h
s1:        
        add ecx,eax
        dec bl
        jnz s1
        
        mov bx,cx
        call htoa
jmp _start                              

add_shift:                               ; Logic for multiplication using Add and Shift
        print m1,m1_len
        scan numascii,3
        mov bx,00
        call atoh
        mov [multi1],bl
        
        print m1,m1_len
        scan numascii,3
        call atoh
        mov [multi2],bl
        print a_msg,a_msg_len
        
        mov ah,00h
        mov al,[multi1]
        mov bl,[multi2]
        mov ecx,08
        mov edx,00h
a1:
        rcr bl,01
        jnc next1
        add dx,ax
next1:
        shl ax,01
        loop a1
        
        mov bx,dx
        call htoa
        
jmp _start

Exit:
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