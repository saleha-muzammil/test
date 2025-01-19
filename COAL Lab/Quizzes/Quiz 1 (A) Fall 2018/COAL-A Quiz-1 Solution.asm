[org 0x0100]
;insertion sort
mov cx, 1
con1:
	cmp cx,[asize]
	jge ewhi1
	while1:
		mov bx,cx
		shl bx, 1
		con2:
			mov ax, [array+bx]
			mov dx, [array+bx-2]
			cmp dx, ax
			jle ewhi2
			cmp bx,0
			jle ewhi2
				while2:
					mov [array+bx-2], ax
					mov [array+bx],dx
					sub bx,2
					jmp con2
				ewhi2:
				inc cx
				jmp con1

	ewhi1:
	mov ax, 0x4c00
	int 0x21
array: dw -10,2,0,-15,3,7,14,1,-12,-11
asize: dw 10
