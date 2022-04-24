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
        h1 db 10,13,"Enter the 4-Digit Hex Number :- "
        h1_len equ $-h1
        
        h2 db 10,13,"The BCD of the given Hex Number is :- "
        h2_len equ $-h2
                
        nl db 10
section .bss
        numascii resb 6
        dispbuff resb 6
        ansbuff resb 6  
        
section .text
global _start:
_start:

        print h1,h1_len
        scan numascii,5
        print h2,h2_len
        call atoh
        mov ax,bx
        mov bx,0Ah
        mov cx,00
htob1:     
        mov dx,0
        div bx
        push dx
        inc cx
        cmp ax,00h
        ja htob1
        
        mov esi,dispbuff
htob2:
        mov dx,0
        pop dx 
        add dx,30h
        mov [esi],dx
        inc esi 
        dec cx
        jnz htob2
        print dispbuff,6
        print nl,1             
mov eax,1
int 80h        
                
;----------------------------------------------

atoh:
        mov bx,0h
        mov cx,4
        mov esi,numascii
p1:
        rol bx,4
        mov al,[esi]
        cmp al,39h
        jbe p2
        sub al,07h
p2:
        sub al,30h
        add bx,ax
        inc esi
        dec cx
        jnz p1
ret
