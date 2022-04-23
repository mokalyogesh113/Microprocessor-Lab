%macro print 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 0x80
%endmacro

%macro scan 1
	mov eax,3
	mov ebx,1
	mov ecx,%1
	int 0x80
%endmacro

section .data
	msg_1 db 10,13,"Enter the String :- "
	msg_1_len equ $-msg_1
	
	msg_2 db 10,13,"The Length of the string is "
	msg_2_len equ $-msg_2
	
	new_line db 10
	new_line_len equ $-new_line
	
section .bss

	str1 resb 20
	count resb 1
	debuff resb 2

section .text
global _start 
_start:
	print msg_1,msg_1_len
	scan str1
	dec al
	
	mov [count],al
	
	print msg_2,msg_2_len
	mov bl,[count]
	call disp
	
	mov eax,1
	int 0x80
	
	
	disp:
		mov cl,2
		mov edi,debuff
		
	f1:
		rol bl,4
		mov al,bl
		and al,0fh
		cmp al,09h
		jbe f2
	
	add al,07h
	
	f2:
		add al,30h
		mov [edi],al
		inc edi
		dec cl
		jnz f1
	
	
	print debuff,2
	print new_line,new_line_len
	ret

