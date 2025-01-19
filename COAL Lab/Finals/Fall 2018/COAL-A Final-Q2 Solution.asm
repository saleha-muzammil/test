[org 0x0100]
jmp main

equation: times 13 db 32 ;initalize to all spaces at start.

inputRoutine:
push bp
mov bp, sp
pusha

	mov bx, equation
	mov si, 0 ;acts as an index.
	
	whileTakingInput:
	
		mov ah, 0
		int 16h
		
		cmp al, 27 ;if esc.
		je endTakingInput
		
			mov [bx + si], al
			inc si
		jmp whileTakingInput
		
	endTakingInput:

	mov word[bp + 4], equation
	
popa
mov sp, bp
pop bp
ret


formNumber:
push bp
mov bp, sp
pusha

	mov bx, [bp + 4] ;the label from where to form number.
	mov si, 0 ;index into label.
	mov ax, 0 ;accumulation.
	
	notSpace:
	mov dl, [bx + si]
	cmp dl, 32 ;if space
	je spaceEncountered
	
		mov cl, 10
		mul cl
		
		sub dl, 48 ;convert ascii to digit.
		add al, dl
		
		inc si
		
		jmp notSpace
	
	spaceEncountered:
	mov [bp + 6], ax
	
popa
mov sp, bp
pop bp
ret 2


tokenizerRoutine:
push bp
mov bp, sp
pusha

	mov bx, [bp + 4] ; equation.
	
	mov si, bx ;si holds operators positon
	
	push word 0
	push word bx
	call formNumber
	pop ax ;the first number.
	
	add bx, 4
	
	add si, 2
	
	cmp ax, 9
	jle num1dig1
	
		inc bx 
		inc si
		
	
	num1dig1:
	
	push word 0
	push bx
	call formNumber
	pop cx
	

	
	add bx, 4
	cmp cx, 9
	jle num2dig1
	
		inc bx
		
	num2dig1:
	
	push word 0
	push word bx
	call formNumber
	pop dx

	
	;after the above code ax has num1, cx has num2 and dx has num3 while si points at opperator.
	mov di, 1 ;indicates operation true.
	
	cmp byte[si], 42
	jne notProd
	
		mul cl ;num2 is in cx.
		cmp al, dl
		je notProd
		mov di, 0
		
		
	notProd:
	
	cmp byte[si], 43
	jne notPlus
	
		add ax, cx
		cmp al, dl
		je notPlus
		mov di, 0
	
	notPlus:
	
	cmp byte[si], 45
	jne notMinus
	
		sub ax, cx
		cmp al, dl
		je notMinus
		mov di, 0
	
	notMinus:
	
	cmp di, 1
	jne false
	
		push word 6
		push word 6
		push word okay
		push word 4
		call printstr
		jmp endFunc
		
	false:
		push word 6
		push word 6
		push word notOkay
		push word 8
		call printstr
	endFunc:

popa
mov sp, bp
pop bp
ret 2

okay: db 'OKAY'
notOkay: db 'NOT OKAY'

; subroutine to clear the screen
clrscr: push es
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
; subroutine to print a number on screen
; takes the row no, column no, and number to be printed as parameters

printnum: push bp
mov bp, sp
push es
push ax
push bx
push cx

push dx
push di
mov di, 80 ; load di with columns per row
mov ax, [bp+8] ; load ax with row number
mul di ; multiply with columns per row
mov di, ax ; save result in di
add di, [bp+6] ; add column number
shl di, 1 ; turn into byte count
add di, 8 ; to end of number location
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 16 ; use base 16 for division
mov cx, 4 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
cmp dl, 0x39 ; is the digit an alphabet
jbe skipalpha ; no, skip addition
add dl, 7 ; yes, make in alphabet code
skipalpha: mov dh, 0x07 ; attach normal attribute
mov [es:di], dx ; print char on screen
sub di, 2 ; to previous screen location
loop nextdigit ; if no divide it again
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 6

; subroutine to print a string
; takes row no, column no, address of string, and its length
; as parameters

printstr: 
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push si
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 80 ; load di with columns per row
mov ax, [bp+10] ; load ax with row number
mul di ; multiply with columns per row
mov di, ax ; save result in di
add di, [bp+8] ; add column number
shl di, 1 ; turn into byte count
mov si, [bp+6] ; string to be printed
mov cx, [bp+4] ; length of string
mov ah, 0x07 ; normal attribute is fixed
nextchar: mov al, [si] ; load next char of string
mov [es:di], ax ; show next char on screen
add di, 2 ; move to next screen location
add si, 1 ; move to next char
loop nextchar ; repeat the operation cx times
pop di
pop si
pop dx
pop cx
pop bx
pop ax

pop es
pop bp
ret 8


main:

call clrscr

push word 0 ;dummy for return.
call inputRoutine
pop bx ;equation

push word 3
push word 3
push bx
push word 12
call printstr


push bx
call tokenizerRoutine





mov ax, 0x4c00
int 21h

