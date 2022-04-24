%macro print 2
        mov eax,4
        mov ebx,2
        mov ecx,%1
        mov edx,%2
        int 80h
%endmacro

%macro scan 2
        mov eax,3
        mov ebx,1
        mov ecx,%1
        mov edx,%2
        int 80h
%endmacro

section .data
        b1 db 10,13,"Enter the 5-Digit BCD Number :- "
        b1_len equ $-b1
        
        b2 db 10,13,"The Hex of the given BCD is :- "
        b2_len equ $-b2
        
        nl db 10
        
section .bss
        numascii resb 6
        dispbuff resb 6
        ansbuff resb 6  
        
section .text
global _start:
_start:

bcdtohex:
        print b1,b1_len                
        scan numascii,6
        print b2,b2_len
     
        mov esi,numascii
                
        mov cx,5
        mov eax,0
        mov ebx,10
        mov edx,00
btoh1:
        mul ebx
        mov dl,[esi]
        sub dl,30h
        add ax,dx
        inc esi
        dec cx
        jnz btoh1
        
        mov bx,ax
        call htoa
       
mov eax,1
int 80h        
                
;----------------------------------------------

htoa:
        mov cx,4
        mov esi,dispbuff
d1:   
        rol bx,4
        mov al,bl
        and al,0fh
        cmp al,09h
        jbe d2
        
        add al,07h

d2:
        add al,30h
        mov [esi],al
        inc esi
        dec cx
        jnz d1
        
        print dispbuff,4
        print nl,1
ret