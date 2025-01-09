;Write a program to make an asterisk travel the border of the screen, 
;from upper left to upper right to lower right to lower left and back to upper left indefinitely.


[org 0x0100]

jmp start


start:		call clrscr

			call borderAsterisk
	
			mov ax, 0x4c00
			int 21h


;Clear Screen
clrscr:				mov ax, 0xb800
					mov es, ax
					xor di,di
					mov ax,0x0720
					mov cx,2000

					cld
					rep stosw
			
					ret


;Delay
delay:				pusha
					mov cx, 0xFFFF

b1:					loop b1
	
					popa
					ret



borderAsterisk:		push bp
					mov bp, sp
					pusha


					;Loading the video memory
					mov ax, 0xb800
					mov es, ax

					mov di, 0

					mov ah, 01110000b
					mov al, '*'

					mov bh, 0x07
					mov bl, 0x20

LefttoRight:		mov cx, 80

l1:					mov [es:di], ax

					call delay

					mov [es:di], bx

					call delay

					add di, 2

					loop l1

					sub di, 2


RightToBottom:		mov cx, 25
		
l2:					mov [es:di], ax

					call delay

					mov [es:di], bx

					call delay

					add di, 160

					loop l2

					sub di, 160


BottomToLeft:		mov cx, 80

l3:					mov [es:di], ax

					call delay

					mov [es:di], bx

					call delay

					sub di, 2

					loop l3

					add di, 2


LefttoTop:			mov cx, 25
		
l4:					mov [es:di], ax

					call delay

					mov [es:di], bx

					call delay

					sub di, 160

					loop l4

					add di, 160

					;Then repeat the whole process again resulting in an infinite loop
					jmp LefttoRight


return:				popa
					pop bp
					ret





;--------------------------------------------------------------------------------
; ALTERNATE SOLUTION
; Solution to this problem was developed by https://github.com/farhana1i
;--------------------------------------------------------------------------------

; ; to display asterick movement every after 1 second
; [org 0x0100]

; jmp main

; seconds:    dw 0    ; number of seconds
; ticks:      dw 0    ; count of ticks
; isLeft:     db 0    ; left movement flag
; isRight:    db 0    ; right movement flag
; isTop:      db 0    ; up movement flag
; isBottom:   db 0    ; down movement flag
; col:        db 0    ; current row number
; row:        db 0    ; current column number

; ; to clear video screen
; clrscr:
; push    es
; push    ax
; push    di

; mov     ax, 0xb800
; mov     es, ax
; mov     di, 0
; nextchar:
; mov     word [es:di], 0x720
; add     di, 2
; cmp     di, 4000
; jne     nextchar

; pop     di
; pop     ax
; pop     es
; ret


; ; to print asteric
; ; DI == position
; printAsterick:
; push    ax
; push    es

; mov     ax, 0xb800
; mov     es, ax          ; points to video memory

; mov     word [es: di], 0x0720   ; clear previous location

; cmp     byte [col], 0
; JNE     nextCmp

; cmp     byte [row], 0
; JNE      checkUp
; mov     byte [isLeft], 1
; mov     byte [isRight], 0
; mov     byte [isTop], 0
; mov     byte [isBottom], 0
; jmp     update

; checkUp:
; cmp     byte [row], 24
; JNE     nextCmp
; mov     byte [isLeft], 0
; mov     byte [isRight], 0
; mov     byte [isTop], 1
; mov     byte [isBottom], 0
; jmp     update

; nextCmp:
; cmp     byte [col], 158
; JNE     update

; cmp     byte [row], 0
; JNE     checkRight
; mov     byte [isLeft], 0
; mov     byte [isRight], 0
; mov     byte [isTop], 0
; mov     byte [isBottom], 1
; jmp     update

; checkRight:

; cmp     byte [row], 24
; JNE     update
; mov     byte [isLeft], 0
; mov     byte [isRight], 1
; mov     byte [isTop], 0
; mov     byte [isBottom], 0
; jmp     update

; update:
; cmp     byte [isLeft], 1
; JNE     checkRightFlag
; add     di, 2
; add     byte [col], 2
; jmp     printScreen

; checkRightFlag:
; cmp     byte [isRight], 1
; JNE     checkUpFlag
; sub     di, 2
; sub     byte [col], 2
; jmp     printScreen

; checkUpFlag:
; cmp     byte [isTop], 1
; JNE     checkDownFlag
; sub     di, 160
; sub     byte [row], 1
; jmp     printScreen

; checkDownFlag:
; cmp     byte [isBottom], 1
; JNE     printScreen
; add     di, 160
; add     byte [row], 1
; jmp     printScreen


; printScreen:
; mov     ah, 0x07    ; attribute
; mov     al, '*'
; mov     word [es: di], ax

; pop es
; pop ax
; ret



; ; hook timer interrupt service routine
; timer:
; push    ax

; inc     word [cs: ticks]
; cmp     word [cs: ticks], 18        ; 18.2 ticks per second
; jne     exitTimer

; inc     word [cs: seconds]          ; increase total seconds by 1
; mov     word [cs: ticks], 0
; CALL    printAsterick

; exitTimer:
; mov     al, 0x20        ; send EOI
; out     0x20, al
; pop     ax
; iret
    

; main:
; ;call    clrscr      ; to clear screen
; mov     di, 0
; xor     ax, ax
; mov     es, ax

; ; hook interrupt
; cli
; mov     word [es: 8*4], timer
; mov     [es: 8*4+2], cs
; sti

; ; to make program TSR
; mov     dx, main
; add     dx, 15
; mov     cl, 4
; shr     dx, cl
; mov     ax, 0x3100
; INT     0x21












