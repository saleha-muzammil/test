;A program to find the maximum and minimum number from an array of ten numbers

[org 0x0100]

jmp start

data: db 10,2,3,4,7,8,6,5,9,1
swap: db 0
max:  db 0
min:  db 0


start:  mov byte[swap],0
		mov bx,0

loop1:	mov al,[data+bx]

		cmp al,[data+bx+1]
		jbe noswap

swapp:	mov dl,[data+bx+1]
		mov [data+bx+1],al
		mov [data+bx],dl
		
		mov byte [swap], 1

noswap: add bl,1
		cmp bx,9
		jnz loop1

checkswap:		cmp byte[swap],0
				jnz start

store: mov al, [data]
	   mov [min],al
	   mov bl, [data+9]
	   mov [max],bl

	   mov ax,0x4c00
	   int 21h
