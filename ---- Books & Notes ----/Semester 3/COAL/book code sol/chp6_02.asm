[org 0x0100]
	
		jmp start
	
	
character: dw '*'


start:					call clrscr

						push word [character]
			
						call clash
		 

end:					mov ax, 0x4c00
						int 21h
		
		
			
		
clrscr:					mov ax, 0xb800
						mov es, ax
						xor di,di
						mov ax,0x0720
						mov cx,2000

						cld
						rep stosw
			
						ret

			
			
	
	
clash:					push bp
						mov bp,sp
						pusha


						mov ax, 0xb800
						mov es, ax

						mov bx, 12


						;Calculating the starting position
						mov al, 80
						mul bl 	 
						shl ax, 1

						mov si, ax		
						mov di, si

						add di, 158

						mov cx, 38

						;Loading the characters
						mov al, [bp + 4]
						mov ah, 0x07

Printing1:				mov word [es:si], ax
						mov word [es:di], ax

						call _delay
						call _delay

						mov word [es:si], 0x0720
						mov word [es:di], 0x0720

						add si, 2
						sub di, 2

						loop Printing1

						mov cx, 38

Printing2:				mov word [es:si], ax
						mov word [es:di], ax

						call _delay
						call _delay

						mov word [es:si], 0x0720
						mov word [es:di], 0x0720

						sub si, 2
						add di, 2

						loop Printing2

						mov cx, 38

						jmp Printing1


_delay:					mov dx, 0xFFFF	

l1:						dec dx
						jnz l1

						ret


return:					popa
						pop bp
						ret 2
					 
					 