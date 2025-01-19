[org 0x0100]
jmp start

week: db ‘Sunday’, ‘Monday’, ‘Tuesday’, ‘Thursday’, ‘Friday’, ’Saturday’, ‘Sunday’, 0

myisr:
	push cs
	pop ds
	mov ah, 0
	int 0x16
	cmp al,0x31	;request for weekday?
	jne nextcmp
	mov ah,0x2a
	int 21h
	cmp al,0	;is it sunday
	jne l1
	mov bp,week
	mov cx,6

	l0:	;print week,date,month or year
		mov ah,0x13
		mov al,1
		mov bh,0
		mov bl,7
		mov dx, 0x0000
		push cs
		pop es
		int 0x10
		iret

	l1:
		cmp al,1 	;is it monday
		jne l2
		add week, 6
		mov bp,week
		mov cx,6
		jmp l0

	l2:
		cmp al,2	;Tuesday?
		jne l3
		add week, 12
		mov bp,week
		mov cx,7
		jmp l0

	l3:
		cmp al,3	;Wednesday?
		jne l4
		add week, 19
		mov bp,week
		mov cx,9
		jmp l0

	l4:
		cmp al,4	;Thursday
		jne l5
		add week, 28
		mov bp,week
		mov cx,8
		jmp l0

	l5:
		cmp al,5	;Friday
		jne l6
		add week, 36
		mov bp,week
		mov cx,6
		jmp l0

	l6:				;Saturday?
		add week, 42
		mov bp,week
		mov cx,8
		jmp l0

	nextcmp:	;Request for date?
		cmp al,0x32
		jne nextcmp1
		mov dh,0
		mov bp, dx
		jmp l0

	nextcmp1:	;Request for Month
		cmp al,0x33	
		jne nextcmp2
		mov dl,0
		mov bp,dx
		jmp l0

	nextcmp2:	;Year
		cmp al, 0x34
		jne exit
		mov bp,cx
		jmp l0

start:
call clrscr
xor ax, ax
mov es,ax
mov word [es:0x85*4], myisr
mov [es:0x85*4+2], cs
int 0x85

exit:
mov ax, 0x4c00
int 0x21

