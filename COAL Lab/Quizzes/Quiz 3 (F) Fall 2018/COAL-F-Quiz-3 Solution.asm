[org 0x0100]
jmp main

array: db 2,2,2,2,2
size: dw 5
number: dw 0
palindromeMessage: db 'The number is a palindrome',0
notPalindromeMessage: db 'The numer is not a palindrome', 0

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

printnum: 

push bp
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

start: 


ConvertToInteger:
push bp
mov bp, sp
pusha

;int i, k = 0;
;for (i = 0; i < n; i++)
 ;   k = 10 * k + a[i];
mov ax, 0 ;i
mov bx, 0
mov cx, 10

loopMul:
mul cx
mov dh, 0
mov dl, [array+bx]
add ax, dx
inc bx
cmp bx, [size]
jl loopMul

mov [bp+4], ax
popa
pop bp
ret 


 
kbisr:
	pusha
	push ds
	push cs
	pop ds
	
	cmp word[size], 16
	je exitkbisr;
	
	in al, 0x60
	cmp al, 0x1c
	je callRoutine
	mov bx, [size]
	cmp al, 2
	jl exitkbisr
	cmp al, 11
	jg exitkbisr
	sub al, 1
	mov [array+bx], al
	inc word[size]
	jmp exitkbisr
callRoutine:
call clrscr
sub sp,2
call ConvertToInteger
pop ax
push ax
call printnum
call isPalindrome
mov word[size],0

exitkbisr:
pop ds
popa
jmp far[cs:oldkbisr]

oldkbisr: dd 0

isPalindrome:
mov bx, [size]
mov si, -1

continue:
dec bx
inc si
cmp si, bx
jge printPalinrome
mov al, [array+si]
cmp al, [array+bx]

je continue
jmp printNotPalindrome

printPalinrome:
call clrscr ; call the clrscr subroutine
 mov ax, 30
 push ax ; push x position
 mov ax, 0
 push ax ; push y position
 mov ax, 1 ; blue on black attribute
 push ax ; push attribute
 mov ax, palindromeMessage
 push ax ; push address of message
 push word 26 ; push message length
 call printstr ; call the printstr subroutine
 jmp exitPalindrome


printNotPalindrome:
 mov ax, 30
 push ax ; push x position
 mov ax, 0
 push ax ; push y position
 mov ax, 1 ; blue on black attribute
 push ax ; push attribute
 mov ax, notPalindromeMessage
 push ax ; push address of message
 push word 30 ; push message length
 call printstr ; call the printstr subroutine
exitPalindrome:
 ret
printStr:
printstr: 
push bp
 mov bp, sp
 push es
 push ax
 push cx
 push si
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov al, 80 ; load al with columns per row
 mul byte [bp+10] ; multiply with y position
 add ax, [bp+12] ; add x position
 shl ax, 1 ; turn into byte offset
 mov di,ax ; point di to required location
 mov si, [bp+6] ; point si to string
 mov cx, [bp+4] ; load length of string in cx
 mov ah, [bp+8] ; load attribute in ah 
  cld ; auto increment mode
nextchar: lodsb ; load next char in al
 stosw ; print char/attribute pair
 loop nextchar ; repeat for the whole string
 pop di
 pop si
 pop cx
 pop ax
 pop es
 pop bp
 ret 10 
 
main:


xor ax, ax
mov es, ax
;saving oldkbisr
mov bx, [es:9*4]
mov [oldkbisr], bx
mov bx, [es:9*4+2]
mov [oldkbisr+2], bx
; hooking new kbisr
mov [es:9*4], word kbisr
mov	[es:9*4+2], cs
STI


mov dx, main
mov dx, 15
mov cl, 4
shr dx, cl
mov ax, 0x3100
int 0x21