[org 0x0100]

		jmp start


arr:	dw 0,0,0,0,0,0,0,0


start:		push word testFunct
			call addtoset

			push word testFunct
			call addtoset

			call callset

end:		mov ax, 0x4c00
			int 21h



;An implied operand say any register which stores the count of the offsets in the array
;will make the solution simpler

addtoset:		push bp
				mov bp, sp
				pusha

				mov ax, 0
				mov bx, 0

				mov dx, [bp + 4]                      ;Offset to be copied

loop1:			cmp ax, [arr + bx]
				jnz  skip

				mov [arr + bx], dx
				jmp return

skip:			add bx, 2
				cmp bx, 16
				jnz loop1


return:			popa
				pop bp
				ret 2



;An implied operand say any register which stores the count of the offsets in the array
;will make the solution simpler

callset:		push bp
				mov bp, sp
				pusha
				
				mov ax, 0
				mov bx, 0

_loop1:			cmp ax, [arr + bx]
				jz  skipcall

				call [arr + bx]

skipcall:		add bx, 2
				cmp bx, 16
				jnz _loop1
			

_return:		popa
				pop bp
				ret 



testFunct:		;Does nothing.

				ret
