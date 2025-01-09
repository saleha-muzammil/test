;Write a subroutine to copy a given area on the screen at the center of the screen without using a temporary array.
;The routine will be passed top, left, bottom, and right in that order through the stack. 
;The parameters passed will always be within range the height will be odd and the width will be even so that it can be exactly centered.


[org 0x0100]

	jmp start


top:	dw 17
bottom: dw 20
left:	dw 15
right: 	dw 30


start:		push word [top]
			push word [left]
			push word [bottom]
			push word [right]

			call copyAtCenter

end:		mov ax, 0x4c00
			int 21h




;---------------------------------------------------------------------------------------------------


copyAtCenter:	push bp
				mov bp, sp 
				pusha

				push es
				push ds

				;bp+4 = right 
				;bp+6 = bottom
				;bp+8 = left
				;bp+10 = top

				mov ax, 0xB800
				mov es, ax

				;Center of screen

				;Row = 12
				;Col = 39,40

				mov bx, 39 				;Mid Col
				mov dx, 12				;Mid Row


				;Calculating Width 
				mov ax, [bp + 4]
				sub ax, [bp + 8]

				push ax 				;Saving width for later use 

				sub ax, 2
				shr ax, 1

				;Getting to the required starting column
				sub bx, ax


				;Calculating height
				mov ax, [bp + 6]
				sub ax, [bp + 10]

				push ax 				;Saving height for later use

				sub ax, 1
				shr ax, 1 


				;Getting to the required starting row
				sub dx, ax


				;Staring position of source
				mov al , 80
				dec byte [bp + 10]
				mul byte [bp + 10]    ;Top
				dec byte [bp + 8]
				add ax, [bp + 8] 	  ;Left
				shl ax, 1

				mov si, ax


				;Starting position of destination
				mov al, 80 					;Load al with columns per row 
				mul dl						;Multiply with y position
				add ax, bx 					;add x position
				shl ax, 1

				mov di, ax 				


				pop ax 			;Height
				pop cx 			;Width


				push es
				pop  ds 


				mov bx, 0

				;Now moving the area to the center

l1:				push si
				push di 
				
				push cx
				rep movsw
				pop cx

				pop di
				pop si

				add si, 160
				add di, 160

				inc bx
				cmp bx, ax
				jnz l1 



				pop ds
				pop es

return:			popa
				pop bp
				ret 8			
			