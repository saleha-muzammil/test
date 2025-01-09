[org 0x0100]

		jmp start

buffer:			db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
startingBit:	db 105

start:			mov dx,1111111100000000b
				mov bx,8
				mov cx,0
				mov ax,0
				mov si,0

				mov al, [startingBit]

				div bl

				mov bx, 0

				mov bl,al
			 	mov si,bx

				cmp ah,0
				jz  scenario0
				jnz scenario1


;Desired Byte doesn't split into two bytes

scenario0:   	mov bl, [buffer + si]

			 	mov ax,bx	
			 	jmp end


;Desired Byte splits into two bytes 

scenario1:		mov cl, ah  
				mov bh, [buffer + si]        ;Done to 
				mov bl, [buffer + si + 1]    ;maintain the order of bytes in bx
				shl bx, cl
				and dx, bx

				mov ax, 0
				mov al, dh
				jmp end	


end:			mov ax,0x4c00
				int 21h				