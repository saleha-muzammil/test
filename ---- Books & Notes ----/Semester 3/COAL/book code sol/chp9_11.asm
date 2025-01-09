;Write a TSR to calculate the current typing speed of the user.
;Current typing speed is the number of characters typed by the user in the last five seconds. 
;The speed should be represented by printing asterisks at the right border (80th column) of the screen
;starting from the upper right to the lower right corner (growing downwards). 
;Draw n asterisks if the user typed n characters in the last five seconds. The count should be updated every second.

;----------------------------------------------------------------------------------------------------------------------------------


;CTS - Current Typing Speed 




;-----------------------------------------------------------------------------------------------------------------------------------
[org 0x0100]

	jmp start


ms:		dw 0 						;Milli seconds

count:  dw 0, 0, 0, 0, 0 			;Count of the characters typed
					
tCount: dw -1  			;Note: The tCount of first second is initialized to -1 for one time because when you type the command and press ENTER
						;	   then the program gets loaded. And it takes you a few milliseconds to release the ENTER key
						;	   and since the program was loaded before, it counts this release of ENTER key as one. So this release count
						;      is ignored by initializing the count to -1

iNo : dw 0
				
location: db 0			;Location where the next star is to be printed
						

;-----------------------------------------------------------------------------------------------------------------

;Clear Screen
clrscr:			pusha
				push es

				mov ax, 0xb800
				mov es, ax
				xor di,di
				mov ax,0x0720
				mov cx,2000

				cld
				rep stosw
			
				pop es
				popa
				ret
;-----------------------------------------------------------------------------------------------------------------


;Program to print the stars
printStars:		pusha
				push es
	
				mov ax, 0xb800
				mov es, ax

				mov al, 80
				mul byte [cs:location]
				add ax, 159
				shl ax, 1

				mov di, ax

				mov cx, [cs:tCount]

				cmp cx, 0 
				jle return


l1:				mov byte [es:di], '*'
				inc byte [cs:location]
				add di, 160
				loop l1

return:			pop es
				popa
				ret



;-----------------------------------------------------------------------------------------------------------------



CTS:			pusha
	
				;These lines will execute for the very first five seconds
				cmp word [cs:iNo], 10
				jz l2

				add word [cs:ms], 55
				cmp word [cs:ms], 1000
				jl EOI2

				mov word [cs:ms], 0 			;Resetting the MilliSeconds to zero
				call printStars 				;Because the count is to be updated every second i.e 
												;the stars are to be printed after every second 

				mov ax, [cs:tCount]
				mov bx, [cs:iNo]

				mov word [cs:count + bx], ax

				mov word [cs:tCount], 0
				add word [cs:iNo], 2

				jmp EOI2			



l2:				add word [cs:ms], 55
				cmp word [cs:ms], 1000
				jl EOI2

				mov word [cs:ms], 0 			;Resetting the MilliSeconds to zero

				;Shifting the counts towards the right, to create a space for this current second

				mov dx, 0

				mov ax, [cs:count + 2]
				add dx, ax
				mov [cs:count], ax
				

				mov ax, [cs:count + 4]
				add dx, ax
				mov [cs:count + 2], ax


				mov ax, [cs:count + 6]
				add dx, ax
				mov [cs:count + 4], ax

				mov ax, [cs:count + 8]
				add dx, ax
				mov [cs:count + 6], ax

				mov ax, [cs:tCount]
				add dx, ax
				mov [cs:count + 8], ax

				jmp a1


EOI2:			jmp EOI 								;Intermediate Jump


				;Now dx contains the count of the last five seconds

a1:				mov [cs:tCount], dx

				call clrscr

				mov byte [cs:location], 0
				call printStars

				mov word [cs:tCount], 0
					

EOI:			mov al, 0x20
				out 0x20, al



exit:			popa
				iret



;-----------------------------------------------------------------------------------------------------------------

;Keyboard ISR

kbisr:	push ax

		in al, 0x60

		shl al, 1
		jnc EOI1

		inc word [cs:tCount] 		;If a key is released, only then increase the count

EOI1:	mov al, 0x20
		out 0x20, al
		
		pop ax

		iret

;-----------------------------------------------------------------------------------------------------------------




start:			mov ax, 0
				mov es, ax

				mov bx, 0

				call clrscr

				;Hooking the interrupts
				cli

				mov word [es: 9*4], kbisr
				mov [es:9*4+2], cs

				mov word [es:8*4], CTS
				mov [es:8*4+2], cs

				sti 


				;Code for making it TSR
				mov dx, start 					;End of resident portion
				add dx, 15						;round up to next para
				mov cl, 4
				shr dx, cl 						;number of paras

end:			mov ax, 0x3100					;terminate and stay resident
				int 21h

