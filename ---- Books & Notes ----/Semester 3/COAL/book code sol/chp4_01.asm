[org 0x0100]

		jmp start

_bits: dw 0,0

start:			mov ax, 0xA891
				mov cx, 0
				mov bx, 1000000000000000b		;Mask to test a particular bit
				mov dx, 1100000000000000b		;Mask used to take xor of the two different bits which will swap them 
				mov si, 0
				mov di, 0

loop1:			cmp bx,0
				jz end

				test bx,ax
				jnz save1
				jz  save0

l1:				shr bx,1    ;Shift the mask one bit to the right to test the next bit
				inc cx
				cmp cx,2    ;After two bits are tested then swap them.
				jz  swap
				jnz loop1


save1:			mov word [_bits + si], 1
				add si,2
				jmp l1

save0:			mov word [_bits + si], 0
				add si,2
				jmp l1


swap:			mov si,0
				mov cx,0

				mov di, [_bits]
				cmp di, [_bits + 2]
				jz  l2 					;If the bits are same then do nothing

				xor	ax,dx				;Otherwise swap those bits

l2:				shr dx,2                ;shift the mask two bits to the right for the next two bits
				jmp loop1

end:			mov ax, 0x4c00
				int 21h










;--------------------------------------------------------------
;Alternate Solution:	

;[org 0x0100]

; start:		mov ax, ABCD
;				mov bx, 1010101010101010b
;				mov dx, 0101010101010101b

;				and bx,ax
;				and dx,ax

;				shr bx,1
;				shl dx,1

;				or bx,dx

;				mov ax,bx

; end:			mov ax, 0x4c00
; 				int 21h

;--------------------------------------------------------------