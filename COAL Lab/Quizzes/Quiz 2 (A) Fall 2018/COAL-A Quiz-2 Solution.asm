org 0x0100
jmp main

oldkbisr: dd 0
oldtimerisr: dd 0

seconds: dw 0
timercount:dw 0

countforkeystroke:dw 1
keystatus:dw 0



printnumber:
push bp
mov bp,sp
push es
pusha

mov ax,0xb800
mov es,ax
mov ax,[bp+4]
mov bx,10
mov cx,0

nextdigit:
mov dx,0
div bx
add dl,0x30
push dx
inc cx
cmp ax,0
jnz nextdigit
mov di,0
nextpos:
pop dx
mov dh,0x07
mov [es:di],dx
add di,2
loop nextpos


popa
pop es
pop bp

ret 2
timerisr:
	inc word[timercount]
	mov ax,[countforkeystroke]
	mov bl,2
	div bl		
	
	cmp ah,0
	je skiptimer 
	
	mov ax,[timercount]
	mov bl,18
	div bl
	cmp ah,0
	jne skiptimer
	inc word[seconds]
	push word[seconds]
	call printnumber
	
skiptimer:

mov al,0x20
out 0x20,al
iret



kbisr:
in al,0x60
test al,0x80
je presscode

cmp word[keystatus],1
jne exitisr
inc word[countforkeystroke]
mov word[keystatus],0
jmp exitisr


presscode:
mov word[keystatus],1





exitisr:


mov al,0x20
out 0x20,al
iret




main:


xor ax,ax
mov es,ax
mov ax,[es:9*4]
mov [oldkbisr],ax
mov ax,[es:9*4+2]
mov [oldkbisr+2],ax
mov ax,[es:8*4]
mov [oldtimerisr],ax
mov ax,[es:8*4+2]
mov [oldtimerisr+2],ax

cli
mov word[es:9*4],kbisr
mov word[es:9*4+2],cs
mov word[es:8*4],timerisr
mov word[es:8*4+2],cs
sti

mov dx,main
add dx,15
mov cl,4
shr dx,cl
mov ax,0x3100
int 0x21










