org 100h

push arr
push sizearr
push word [a]
push word [l]
push word [r]
call xorq
mov ah,4ch
int 21h


xorq:
push bp
mov bp,sp


push bx
push cx
push si


mov ax,[bp+8]
mov bx,[bp+12]
mov si,[bp+6]
mov cx,[bp+4]
sub cx,si

push cx
push bx
push si

doit:
xor [bx+si], ax
add si,2
loop doit

pop si 
pop bx
pop cx

mov ax,[bx+si]
add si,2

doit2:
cmp ax,[bx+si]
ja toloop
mov ax,[bx+si]
toloop:
add si,2
loop doit2 

pop si
pop cx
pop bx


pop bp
ret 6


arr: dw 3,5,9
sizearr: dw 7
a: dw 4 
l: dw 0
r: dw 2

