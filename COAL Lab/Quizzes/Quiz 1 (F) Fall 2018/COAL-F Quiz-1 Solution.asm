
[org 0x0100]
mov cx, 0
mov ax, 3500
mov ds,ax
mov bx, 1234
mov di,bx
mov cl, [asize]
add di, cxsub cl,1
mov si,0

go:
add ch,1
mov al, [array+si]
add si,1
cmp al,10
jb start

mov byte [ds:di], al
sub di,1
jmp mlabel

start:
mov byte [ds:bx], aladd bx,1

mylabel:
cmp ch,cl
jne go

mov ax, 0x4c00
int 0x21

array: db 7, 3, 8, 11, 2, 14, 6, 13, 10, 7
asize: db 10