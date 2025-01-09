;Virtual Window on the Screen


[org 0x0100]

	jmp start


character:	dw 'H'
			
			   ;top, left, bottom, right, current row, current column, normal attribute, cursor attribute
address:	dw 0,	 20,	10	,	70,		10,			25,			     07,				10000111b 


start:		;call clrscr

			push word [character]
			push address

			call virtualWindow

exit:		mov ax, 0x4c00
			int 21h



;-----------------------------------------------------------------------------------------------------------------

;Clear Screen
clrscr:			pusha
				push es

				mov ax, 0xb800
				mov es, ax
				xor di,di
				mov ax,0x0720
				mov cx,2000

				cld
				rep stosw
			
				pop es
				popa
				ret
;-----------------------------------------------------------------------------------------------------------------

scrollUp:	pusha
			push es
			push ds



			;Calculating the starting point of the VW

			mov al, 80
			mul byte [si]
			add ax, [si+2]
			shl ax,  1

			push ax


			;Loading the video memory
			mov ax, 0xb800
			mov es, ax
			mov ds, ax  

			pop ax

			;Height times loop chaley ga
			mov dx, [bp - 2]
			inc dx

			cld



a1:			mov di, ax 				;Destination Point

			mov si, ax				;Source Point

			add si, 160


			;Width jitney character move hon ge har iteration mai
			mov cx, [bp - 4]
			
			rep movsw

			add ax, 160

			dec dx
			jnz a1


			;Width jitney character move hon ge har iteration mai
			mov cx, [bp - 4]

			sub ax, 160
			mov di,ax
			mov ax, 0x720

			rep stosw


			pop ds
			pop es
			popa
			ret

;-----------------------------------------------------------------------------------------------------------------

virtualWindow:	push bp
				mov bp, sp

				sub sp, 4			; Making three local variables for storing length and width
									; of the Virtual Window on the screen


				;bp - 2 			;Height
				;bp - 4				;Width 

				;bp + 4 			;Address 
				;bp + 6 			;Character

				;Address + 0 		;Top
				;Address + 2 		;Left
				;Address + 4 		;Bottom
				;Address + 6 		;Right
				;Address + 8 		;Current Row
				;Address + 10 		;Current Column
				;Address + 12 		;Normal Attribute
				;Address + 14 		;Cursor Attribute


				push es
				pusha



				mov si, [bp + 4]

				;Calculating Height
				mov ax, [si]
				mov bx, [si + 4]

				sub bx, ax

				mov [bp - 2], bx 	;Height



				;Calculating Width
				mov ax, [si + 2 ]
				mov bx, [si + 6]

				sub bx, ax

				mov [bp - 4], bx 	;Width



				;-------------------------------------------------------------


				;Calculating the required position

				mov ax, 0xb800
				mov es, ax

				;Exact Row
				mov ax, [si]
				add ax, [si + 8]

				mov bx, ax


				;Exact Column
				mov ax, [si + 2]
				add ax, [si + 10]

				mov dx, ax


				;Exact Position
				mov al, 80
				mul bl
				add ax, dx
				shl ax,  1
				mov di, ax


				;Loading al with the character to be written
				mov al, [bp + 6]

				mov ah, [si + 12]

				mov [es:di], ax


				inc dx

				cmp dx, [si + 6]
				jle l2

				mov dx, [si + 2]
				
				inc bx

				cmp bx, [si + 4]
				jle l2

				;call scroll Scroll Up 
				call scrollUp


				;Exact Position
l2:				mov al, 80
				mul bl
				add ax, dx
				shl ax,  1
				mov di, ax


				;Loading the character to be written
				mov ah, [si + 14]
				mov al, '_'

				mov [es:di], ax



return:			popa
				pop es

				add sp, 4

				pop bp
				ret 4
