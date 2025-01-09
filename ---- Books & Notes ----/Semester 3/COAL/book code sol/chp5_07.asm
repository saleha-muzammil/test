[org 0x0100]

		jmp start


arr:	dw 0,0,0,0,0,0,0,0


start:		push word testFunct
			call addtoset

			push word testFunct
			call addtoset

			pusha
			call callset
			popa

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

callset:	   mov ax, 0
			   mov bx, 14

_loop1:		   cmp ax, [arr + bx]
			   jz _skip

			   push word [arr + bx]

_skip:		   sub bx,  2
			   cmp bx, -2
			   jnz _loop1

_return: 	   ret




testFunct:		;Does nothing.

				ret
