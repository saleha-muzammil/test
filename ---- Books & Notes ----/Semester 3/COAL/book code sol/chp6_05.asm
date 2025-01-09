[org 0x0100]

	jmp start


top: 	dw 10             ;Starting Row
bottom: dw 20		     ;Ending   Row
left:	dw 30			 ;Starting Column
right:	dw 60		     ;Ending Column


start:		call clrscr

			push word [top]
			push word [bottom]
			push word [left]
			push word [right]

			call drawrect

end:		mov ax, 0x4c00
			int 21h




clrscr:			mov ax, 0xb800
				mov es, ax				;Loading the video memory

				xor di,di

				mov ax,0x0720
				mov cx,2000

				cld
				rep stosw
			
				ret



drawrect:		push bp
				mov  bp, sp
				pusha


				; bp + 4  =  right
				; bp + 6  =  left
				; bp + 8  =  bottom
				; bp + 10 =  top


				;Calculating the top left position of the rectangle

				mov al, 80
				mul byte [bp + 10] 
				add ax,  [bp + 6]		 
				shl ax, 1
				mov di, ax

				push di					;Saving for later use


				mov ah, 0x07 			;Storing the attribute


				;Calculating the width of the rectangle

				mov cx, [bp + 4]
				sub cx, [bp + 6]

				push cx 				;Saving for later use

				mov al, '+'

loop1:			rep stosw






				pop bx

				pop di

				push bx

				dec bx	
				shl bx, 1

				add di, 160


				;Calculating the height of the rectangle

				mov cx, [bp + 8]
				sub cx, [bp + 10] 

				sub cx, 2 				;Excluding the top and bottom row
				
				mov al, '|' 

loop2:			mov si, di

				mov word [es:si], ax

				add si, bx

				mov word [es:si], ax

				sub si, bx

				add di, 160

				loop loop2





				pop cx

				mov al, '-'

loop3:			rep stosw


return:			popa
				pop bp
				ret 8		

