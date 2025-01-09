[org 0x0100]

	jmp start


address:	dd 0

;-----------------------------------------------------------------------------------------------------------------

;Clear Screen
clrscr:			push bp
				mov bp, sp

				pusha
				push es

				mov ax, 0xb800
				mov es, ax
				xor di,di
				mov ax,0x0720
				mov cx,2000

				cld
				rep stosw
			
				pop es
				

return:			mov ax, 0
				mov cx, 0

				cmp	ax, [bp+4]
				jz nearReturn

				cmp ax, [bp+6]
				jz farReturn

				cmp ax, [bp+8]
				jz interruptReturn


nearReturn:			popa
					pop bp
					ret 2

farReturn:			popa
					pop bp
					retf 2

interruptReturn:	mov ax, [bp + 6]
					mov [bp + 8], ax

					mov ax, [bp + 4]
					mov [bp + 6], ax

					mov ax, [bp + 2]
					mov [bp + 4], ax

					popa
					pop bp

					add sp, 2

					iret 
;-----------------------------------------------------------------------------------------------------------------





start:		xor ax, ax
			mov es, ax

			;Hooking the interrupt
			mov word [es:80h*4], clrscr
			mov word [es:80h*4+2], cs

			;Saving address for far call
			mov word [address], clrscr
			mov word [address + 2], cs

			push 0
			call clrscr 				;Near Call

			push 0
			call far [address]			;Far Call

			push 0
			int 80h 					;Interrupt Call (Extended Far Call)

			mov ax, 0x4c00
			int 21h