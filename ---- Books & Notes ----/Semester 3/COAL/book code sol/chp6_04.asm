[org 0x0100]

	jmp start


arr: times 500 db 0


start:		call spacechecker


end:		mov ax, 0x4c00
			int 21h





spacechecker:			pusha

						mov ax, 0xb800
						mov es, ax

						;Attributes wali byte locations par tw kabhi space nahi miley gi.
						;Isi lye array ki odd numbered bits ko pehley hi 1 kar do.


						;Firstly setting all bits to 1

						mov cx, 2000
						mov ax, 1111111111111111b

_setAllBits:			or [arr + bx], ax

						add bx, 2
						loop _setAllBits


						mov bl, 0x20		;loading the space character


						;Now checking for spaces

						mov cx, 2000
						mov di, 0
						mov si, 0

						mov dl, 10000000b
						mov al, 01111111b

checkSpace:				cmp byte [es:di], bl
						jnz _bit1
						jz  _bit0


_bit0:					and [arr + si], al
						jmp l1


_bit1:					or [arr + si], dl
						jmp l1


l1:						shr dl, 2        ;Skipping the odd numbered bits as they are already set to 1
						shr al, 2        ;previously

						cmp dl, 0
						jnz l2

						mov dl, 10000000b
						mov al, 01111111b

						inc si	

l2:						add di, 2
						loop  checkSpace


return:					popa
						ret						
						


