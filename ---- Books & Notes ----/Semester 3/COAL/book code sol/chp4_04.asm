[org 0x0100]

			mov ax, 0x1234
			mov bx, 0xABCD
			mov dx, 1000000000000000b
			mov si, 0
			mov cx, 0

;Calculating the no. of bits in bx

loop1:		cmp dx,0
			jz  part2

			test bx,dx
			jz  skip_inc

			inc  si

skip_inc:	shr  dx,1
			jmp  loop1



;complementing from left to right the least significant bits of ax (one at a time)

part2:      cmp si,0
            jz  end

            mov dx, 0000000000000001b


loop2:      xor ax,dx
            shl dx,1
            inc cx
            cmp cx,si
            jnz loop2


end:		mov ax, 0x4c00
			int 21h		