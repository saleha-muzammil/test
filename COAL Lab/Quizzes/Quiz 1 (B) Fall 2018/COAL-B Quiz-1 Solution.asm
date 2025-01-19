[org 0100h]
jmp start
imc:
inc bx
mov ax,bx
mov cx,bx
jmp sum1
modify:
jmp last
sum1:
mul cx
cmp dx,0
jnz modify
loop sum1
cmp dx,0
jz imc
start: 
mov ax,1
mov cx,ax
mov bx,ax
jmp sum1
last:
mov ax,4c00h
int 21h