[org 0x0100] 

jmp start 

oldisr: dd 0
tick_count: dw 0
sec_count: dw 0

roll_no: db '17L-4171'
len_roll: dw 8

correct: db 'Please Give Correct Input'
len_corr: dw 25

o_press: dw 0

on_check: dw 0
of_check: dw 0

flag: dw 0
;It will take the address of string and its length and print it onto topleft of screen
top_left_print:		push bp
					mov bp,sp
					pusha
					
					push cs
					pop ds
					
					mov cx,[bp+4];length of string
					mov si,[bp+6];base address of string
					
					mov ax,0xb800
					mov es,ax
					mov di,0;for top left corner
					mov ah,0x07
					
					l1:
					lodsb
					stosw
					loop l1 
					
					popa
					pop bp
					ret 4

;It will take the address of string and its length and print it onto bottomleft of screen
bottom_left_print:	push bp
					mov bp,sp
					pusha
					
					push cs
					pop ds
					
					mov cx,[bp+4];length of string
					mov si,[bp+6];base address of string
					
					mov ax,0xb800
					mov es,ax
					mov di,3840;for bottom left corner
					mov ah,0x07
					
					l2:
					lodsb
					stosw
					loop l2 
					
					popa
					pop bp
					ret 4

clrscr:	pusha

		mov ax,0xb800
		mov es,ax
		
		mov di,0
		
		mov cx,2000
		mov ax,0x0720
		
		cld
		rep stosw
		
		popa
		ret

;;;;;keyboard interrupt;;;;;
kbisr: pusha

		push cs
		pop ds
		
		in al,0x60
		cmp al,0x98;release code of 'o'
		jne nextcmp
		mov word [cs:o_press],1
		jmp kb_exit
		
nextcmp: cmp al,0xB1;release code of 'n'
		 jne nextcmp1
		 cmp word [cs:o_press],1
		 jne not_o1
		 mov word [cs:on_check],1
		 
not_o1:	mov word [cs:o_press],0 		 
		 jmp kb_exit
		 
nextcmp1: cmp al,0xA1;release code of 'f'
		 jne kb_nomatch
		 cmp word [cs:o_press],1
		 jne not_o2
		 mov word [cs:of_check],1
		 
not_o2:	 mov word [cs:o_press],0 		 
		 jmp kb_exit
		  
kb_nomatch: test al,0x80;checking for interrupt on press
			jz skip
			mov word [cs:o_press],0
skip:		popa
			jmp far [cs:oldisr]

kb_exit: mov al,0x20
		 out 0x20,al
		 popa
		 iret
		
;;;timer interrupt;;;;;;
timer:	pusha
		push cs
		pop ds
		
		inc word [cs:tick_count]
		cmp word [cs:tick_count],18
		jne tim_exit
		mov word [cs:tick_count],0
		inc word [cs:sec_count]
		cmp word [cs:sec_count],4
		jne tim_exit
		mov word [cs:sec_count],0
		
		call clrscr
		
		cmp word [cs:on_check],1;if on was typed
		jne next_check
		mov word [cs:on_check],0
		mov word [cs:flag],1
		push roll_no
		push word [cs:len_roll]
		call top_left_print
		;jmp tim_exit
		
next_check: cmp word [cs:of_check],1;if of was typed
			jne no_typed
			mov word [cs:of_check],0
			push roll_no
			push word [cs:len_roll]
			call bottom_left_print
			jmp tim_exit
			
no_typed:	cmp word [cs:flag],1
			je tim_exit
			push correct
			push word [cs:len_corr]
			call top_left_print
			push correct
			push word [cs:len_corr]
			call bottom_left_print
		
tim_exit: 
		mov word [cs:flag],0
		mov al,0x20
		out 0x20,al
		popa
		iret


start: 	xor ax, ax 
		mov es, ax ; point es to IVT base 
		
		mov ax,[es:9*4]
		mov [oldisr],ax
		mov ax,[es:9*4+2]
		mov [oldisr+2],ax
		
		cli 
		mov word [es:9*4], kbisr
		mov [es:9*4+2], cs ; hook keyboard interrupt 

		mov word [es:8*4], timer 
		mov [es:8*4+2], cs ; hook timer interrupt 
		sti 
		
		mov dx,start
		add dx,15
		shr dx,4
		mov ax,0x3100
		int 0x21