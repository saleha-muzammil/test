[org 0x0100]
mov ax, 1 	;mask
mov bx, array
mov cx, 1	;count in cx register

check1:
cmp al, 00000000b
jne outer
mov ax, 1
add bx, 2
inc cx
cmp cx,[asize]
jg end

outer:
mov dx, ax
or dx, [bx]
cmp dx, ax
je check2

remch1:
shl ax,1
jmp check1

check2:
cmp cx, [asize]
je lastitem
mov di,cx
dec di
shl di,1
mov si, [array+di+2]
mov [array+di],si
jmp remch1

lastitem:
mov di,cx
dec di
shl di,1
mov byte [array+di],10

end:
mov ax, 0x4c00
int 0x21
array: dw 9,18,1,2,12,27,32,16,63,128
asize: dw 10
