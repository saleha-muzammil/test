[org 0x0100]

	jmp start

flag:	    db 0


start:		mov al, 0x0F 				;Byte to find

			mov bx, 0x0000				;Starting from segment 0x0000

l1:			mov es, bx
 
			mov cx, 0xFFFF
			mov di, 0

			repne scasb
			je found

			add bx, 1000
			cmp bx, 0000
			jz notFound
			jnz l1


found:		mov byte [flag], 1
			jmp exit


notFound:	jmp exit

exit:		mov ax, 0x4c00
			int 21h

