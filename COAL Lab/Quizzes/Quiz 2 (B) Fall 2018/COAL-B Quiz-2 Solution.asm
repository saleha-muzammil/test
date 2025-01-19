[org 0x0100]
	
	jmp start
	
; subroutine for swapping colors
Swapcolor:

	push bp
	mov bp,sp
	push es
	push ax
	push di
	
	
	xor di,di
	mov ax, 0xb800
	mov es,ax
	
	mov cx, 2000
	mov ax, 0x7000
	
label1:
		xor word[es:di], ax
		add di, 2
		loop label1
		
		pop di
		pop ax
		pop es
		pop bp
		ret		
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
kbisr:

	push ax
	push es
	mov ax, 0xb800
	mov es, ax ; point es to video memory

	in al, 0x60 ; read a char from keyboard port
	cmp al, 0x2a ; is the key left shift pressed
	jne noswap 
	
	call Swapcolor
	jmp exit
	
noswap:
		cmp al, 0xaa
		jne exit
		
		call Swapcolor
		
exit:	
	
		mov al, 0x20
		out 0x20, al ; send EOI to PIC
		pop es
		pop ax
		iret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
		xor ax, ax
		mov es, ax 
		cli 
		mov word [es:9*4], kbisr
		mov [es:9*4+2], cs 
		sti
		
		
		mov dx, start ; end of resident portion
		add dx, 15 ; round up to next para
		mov cl, 4
		shr dx, cl
		
		mov ax, 0x4c00
		int 21h
		
		
		