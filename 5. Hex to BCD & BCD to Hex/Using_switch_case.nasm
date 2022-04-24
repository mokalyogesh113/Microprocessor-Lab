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
        menu_msg db 10,"---------------------------Menu---------------------------"
               db 10,"1. Hex To BCD "
               db 10,"2. BCD to Hex "
               db 10,"3. Exit "
               db 10,"Enter Choice :- "           
        menu_msg_len equ $-menu_msg
        
        wrong_msg db 10,"You have Entered The wrong Choice !.... Please Enter the Choice Again ",10
        wrong_msg_len equ $-wrong_msg
        
        nl db 10
        
        h1 db 10,13,"Enter the 4-Digit Hex Number :- "
        h1_len equ $-h1
        
        h2 db 10,13,"The BCD of the given Hex Number is :- "
        h2_len equ $-h2
        
        b1 db 10,13,"Enter the 5-Digit BCD Number :- "
        b1_len equ $-b1
        
        b2 db 10,13,"The Hex of the given BCD is :- "
        b2_len equ $-b2
        
section .bss
        numascii resb 6
        dispbuff resb 6
        ansbuff resb 6  
        
section .text
global _start:
_start:

        print menu_msg,menu_msg_len
        scan numascii,2
        cmp byte[numascii],'1'
        je hextobcd     
        cmp byte[numascii],'2'
        je bcdtohex
        cmp byte[numascii],'3'
        je Exit
        print wrong_msg,wrong_msg_len
        jmp _start
        

hextobcd:
        
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
jmp _start
        

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
       
        jmp _start
        
Exit:             
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