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
        real_msg db 10,13,"You are in Real Mode ",10
        real_msg_len equ $-real_msg
        
        protected_msg db 10,13,"You are in Protected Mode ",10
        protected_msg_len equ $-protected_msg
        
        g_msg db 10,13,"The Contents of the GDTR is :-  "
        g_msg_len equ $-g_msg
        
        l_msg db 10,13,"The Contents of the LDTR is :-  "
        l_msg_len equ $-l_msg
         
        i_msg db 10,13,"The Contents of the IDTR is :-  "
        i_msg_len equ $-i_msg
        
        t_msg db 10,13,"The Contents of the TR is   :-  "
        t_msg_len equ $-t_msg
        
        nl db 10
        
        colon db " : "
        colon_len equ $-colon
        
section .bss
        msw resb 1
        gdtr resd 3
        ldtr resd 3
        idtr resd 1
        tr resd 1
        dispbuff resb 4

section .text
global _start
_start:
        smsw [msw]
        mov eax,[msw]
        rcr eax,1
        jc p
r:
        print real_msg,real_msg_len
        jmp Exit

p:
        print protected_msg,protected_msg_len
        
        sgdt [gdtr]                     ;Printing the GDTR values
        print g_msg,g_msg_len
        mov bx,[gdtr+4]
        call htoa
        mov bx,[gdtr+2]
        call htoa
        print colon,colon_len
        mov bx,[gdtr+0]
        call htoa
        print nl,1
         
        sldt [ldtr]                     ;Printing the LDTR values
        print l_msg,l_msg_len
        mov bx,[ldtr+4]
        call htoa
        mov bx,[ldtr+2]
        call htoa
        print colon,colon_len
        mov bx,[ldtr+0]
        call htoa
        print nl,1
        
        sidt [idtr]
        print i_msg,i_msg_len
        mov bx,[idtr]
        call htoa
        print nl,1
        
        str [tr]
        print t_msg,t_msg_len
        mov bx,[tr]
        call htoa
        print nl,1
        
Exit:
        mov eax,1
        int 80h
        

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
        ;print nl,1
ret