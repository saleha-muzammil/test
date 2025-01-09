[org 0x0100]

	jmp start

_segment:    dw 0xF8AB
_offset:	 dw 0xFFFF

start:	call clrscr
		
		push word [_segment]
		push word [_offset]

		call printaddr


end:	mov ax, 0x4c00
		int 21h





clrscr:			mov ax, 0xb800
				mov es, ax
				xor di,di
				mov ax,0x0720
				mov cx,2000

				cld
				rep stosw
			
				ret







;A mini sub routine to used by printaddr

print:			cmp bl, 9
				jle Decimal 
				jg  Hex
				

Decimal:		add bl, 0x30
				jmp l1
	
Hex:			add bl, 55
				jmp l1

l1:				mov word [es:di], bx
				add di, 2

return:			ret



;Main sub-routine

printaddr:		push bp
				mov bp,sp
				pusha

				mov ax, 0xb800
				mov es, ax

				;Calculating the Physical Address

				mov ax, [bp + 6]		;segment address
				mov bx, 0x10

				mul bx

				add ax, [bp + 4]        ;adding the offset
				adc dx, 0

				mov di, 0

				mov bh, 0x07





;Printing Most Signicant Nibble of PA present in dx

Nibble_1st:		mov bl, 00001111b
				and bl, dl
				call print



;Printing the ax part of PA 

Nibble_2nd:		mov bl, 11110000b
				and bl, ah
				shr bl, 4
				call print


Nibble_3rd:		mov bl, 00001111b
				and bl, ah
				call print


Nibble_4th:		mov bl, 11110000b
				and bl, al
				shr bl, 4
				call print


Nibble_5th:		mov bl, 00001111b
				and bl, al
				call print


_return:		popa
				pop bp
				ret 4