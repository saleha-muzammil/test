[org 0x0100]
jmp start
size1: dw 5
Array: db 0x07,'h',0x07,'e',0x07,'l',0x07,'l',0x07,'o'

oldisr: dd 0
;==========================================================;
clrscn:
push ax
push bx
push cx
push dx
push si
push di
push es
push ds

push cs
pop ds

push 0xb800
pop es
xor di,di
mov cx,2000
mov ax,0x0720
rep stosw

pop ds
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
;==========================================================;
PrintatTop:
push ax
push bx
push cx
push dx
push si
push di
push es
push ds

push cs
pop ds

push 0xb800
pop es
xor si,si
xor di,di
mov cx,[cs:size1]
print:
mov ah,[cs:Array+si]
mov al,[cs:Array+si+1]
add si,2
mov word[es:di],ax
add di,2
loop print

pop ds
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
;=============================================================;
PrintatTopReverse:
push ax
push bx
push cx
push dx
push si
push di
push es
push ds

push cs
pop ds

push 0xb800
pop es
xor si,si
xor di,di
mov cx,[cs:size1]
printR:
mov ah,[cs:Array+si]
mov bl,0x08
mov bh,0x80
or bl,ah
or bh,ah
shl bl,4
shr bh,4
and ah,bh
and ah,bl
mov al,[cs:Array+si+1]
add si,2
mov word[es:di],ax
add di,2
loop printR

pop ds
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
;===========================================================;
PrintatBottom:
push ax
push bx
push cx
push dx
push si
push di
push es
push ds

push cs
pop ds

push 0xb800
pop es
xor si,si
mov di,3840
mov cx,[cs:size1]
printBottom:
mov ah,[cs:Array+si]
mov al,[cs:Array+si+1]
add si,2
mov word[es:di],ax
add di,2
loop printBottom

pop ds
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
;================================================================;
PrintatBottomReverse:
push ax
push bx
push cx
push dx
push si
push di
push es
push ds

push cs
pop ds

push 0xb800
pop es
xor si,si
mov di,3840
mov cx,[cs:size1]
printBottomR:
mov ah,[cs:Array+si]
mov bl,0x08
mov bh,0x80
or bl,ah
or bh,ah
shl bl,4
shr bh,4
and ah,bh
and ah,bl

mov al,[cs:Array+si+1]
add si,2
mov word[es:di],ax
add di,2
loop printBottomR

pop ds
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
;===============================================================;
kbisr:
push ax
push es

in al, 0x60
cmp al,0x44
jne nextcmp
call clrscn
call PrintatTop
jmp exit
nextcmp:
cmp al,0xC4
jne nextcmp2
call clrscn
call PrintatTopReverse

jmp exit
nextcmp2:
cmp al,0x2a
jne nextcmp3
call clrscn
call PrintatBottom

jmp exit
nextcmp3:
cmp al,0xaa
jne nomatch
call clrscn
call PrintatBottomReverse

jmp exit
nomatch:
pop es
pop ax
jmp far[cs:oldisr]

exit:
mov al,0x20
out 0x20,al
pop es
pop ax
iret

start:

xor ax,ax
mov es,ax
mov ax,[es:9*4]
mov [oldisr],ax
mov ax,[es:9*4+2]
mov [oldisr+2],ax
cli
mov word[es:9*4],kbisr
mov word[es:9*4+2],cs
sti

mov dx,start
add dx,15
mov cl,4
shr dx,cl
mov ax,0x3100
int 21h