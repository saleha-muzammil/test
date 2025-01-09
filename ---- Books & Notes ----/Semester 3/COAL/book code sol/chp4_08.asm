[org 0x0100]

			mov ax, 0x1234
			mov bx, 0

start:		mov dx, 1000000000000000b
			mov si, 0

;Counting the no. of one bits in ax

loop1:		cmp dx, 0
			jz  part2

			test ax,dx
			jz  skip_inc
			
			inc  si

skip_inc:	shr  dx,1
			jmp  loop1


part2:      mov ax,si
			inc bx
			cmp ax,1    	;It is mentioned in the question that ax will always have a non zero value.
							;Thats why the comparision with 0 is ommitted.
			jnz start

            
end:		mov ax, 0x4c00
			int 21h		