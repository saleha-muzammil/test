;See which scan codes are take as input from key board
[org 0x0100]
jmp start
oldisr: dd 0 
clrscr: 
	 push es
	 push ax
	 push cx
	 push di
	 mov ax, 0xb800
	 mov es, ax ; point es to video base
	 xor di, di ; point di to top left column
	 mov ax, 0x0720 ; space char in normal attribute
	 mov cx, 2000 ; number of screen locations
	 cld ; auto increment mode
	 rep stosw ; clear the whole screen
	 pop di 
	 pop cx
	 pop ax
	 pop es
	 ret 
 


printnum: push bp
 mov bp, sp
 push es
 push ax
 push bx
 push cx
 push dx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov ax, [bp+4] ; load number in ax
 mov bx, 10 ; use base 10 for division
 mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
 div bx ; divide by 10
 add dl, 0x30 ; convert digit into ascii value
 push dx ; save ascii value on stack
 inc cx ; increment count of values
 cmp ax, 0 ; is the quotient zero
 jnz nextdigit ; if no divide it again
 mov di, 0 ; point di to top left column 
 nextpos: pop dx ; remove a digit from the stack
 mov dh, 0x07 ; use normal attribute
 mov [es:di], dx ; print char on screen
 add di, 2 ; move to next screen location
 loop nextpos ; repeat for all digits on stack
 pop di
 pop dx
 pop cx
 pop bx
 pop ax
 pop es
 pop bp
 ret 2 
 
 
 
 printnum2: push bp
 mov bp, sp
 push es
 push ax
 push bx
 push cx
 push dx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov ax, [bp+4] ; load number in ax
 mov bx, 10 ; use base 10 for division
 mov cx, 0 ; initialize count of digits
nextdigit2: mov dx, 0 ; zero upper half of dividend
 div bx ; divide by 10
 add dl, 0x30 ; convert digit into ascii value
 push dx ; save ascii value on stack
 inc cx ; increment count of values
 cmp ax, 0 ; is the quotient zero
 jnz nextdigit2 ; if no divide it again
 mov di, 160 ; point di to top left column 
 nextpos2: pop dx ; remove a digit from the stack
 mov dh, 0x07 ; use normal attribute
 mov [es:di], dx ; print char on screen
 add di, 2 ; move to next screen location
 loop nextpos2 ; repeat for all digits on stack
 pop di
 pop dx
 pop cx
 pop bx
 pop ax
 pop es
 pop bp
 ret 2 

 
; keyboard interrupt service routine
kbisr: 
 push ax
 push es
 mov ax, 0xb800
 mov es, ax ; point es to video memory
 in al, 0x60 ; read a char from keyboard port
 mov ah, 00h
 call clrscr
 push ax ; place number on stack
 call printnum 
 ;mov word [es:0], ax ; yes, print L at top left
 cmp al, 30
 je endd
 pop es
 pop ax 
 jmp far [cs:oldisr]
 endd:
 pop es
 pop ax 
 mov al, 0x20
 out 0x20, al ; send EOI to PIC
 iret
 
 


 start: 
xor ax, ax
mov es, ax ; point es to IVT base
mov ax, [es:9*4]
mov [oldisr], ax ; save offset of old routine
mov ax, [es:9*4+2]
 mov [oldisr+2], ax ; save segment of old routine 
cli
; comment and uncomment the next two lines to see the difference on how int16h and int 09h work
mov word [es:9*4], kbisr ; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2
sti ; enable interrupts 
 l1:
 mov ah, 0
 int 16h
 mov al, ah
 mov ah,0
 ;call clrscr
 push ax ; place number on stack
 call printnum2

 jmp l1 ; infinite loop 
