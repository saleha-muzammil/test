[org 0x0100]
	
		mov ax,0111101011001001b
		mov bl,00001110b
		mov dx,1
		
l1:		cmp dx,5
		je not_found		
		mov cx,0x000F
		and cx,ax
		shr ax,4
		cmp cl,bl
		je exit
		inc dx
		jmp l1
		

not_found: mov dx,0
		
exit:	mov ax,0x4c00
		int 0x21

