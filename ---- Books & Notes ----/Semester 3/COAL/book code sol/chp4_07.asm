[org 0x0100]

start:		mov ax, 7
			mov bx, 0xABCD

			mov cx,ax
			mov dx,1000000000000000b
			shr dx,cl
			xor bx,dx

end:		mov ax, 0x4c00
			int 21h