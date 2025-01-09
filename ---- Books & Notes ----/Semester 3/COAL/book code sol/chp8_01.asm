[org 0x0100]

	jmp start


isTSR:	dw 0
oldISR:	dd 0


;--------------------------------------------------------------------------

myISR:		cmp ah, 0x31 						;Agar tw 0x31 wali service call huwi tw kuch kaam karo, nahi tw humein koi kaam karney ki zaroorat
												;hi nahi because hum ne tw sirf 31h wali service pe kaam karna hai
												
			jnz chain

			cmp word [cs:isTSR], 0                 ;Agar tw humari myISR TSR ban chuki hai, phir ab kisi aur naye program ko TSR nahi banney dena
			jz makeitTSR                        ;Lekin agar humari myISR TSR nahi bani, tw pehley usey TSR banao
 

			mov ah, 0x4c

chain:		jmp far [cs:oldISR]



makeitTSR:	mov word [cs:isTSR], 1
			jmp far [cs:oldISR]


;---------------------------------------------------------------------------

start:		xor ax,ax
			mov es,ax

			;Saving the OLD ISR
			mov ax, [es:21h*4]
			mov [oldISR], ax

			mov ax, [es:21h*4 + 2]
			mov [oldISR + 2], ax			 

			;Hooking our ISR
			mov word [es:21h*4], myISR
			mov word [es:21h*4+2], cs

			mov dx, start
			add dx, 15
			mov cl, 4
			shr dx, cl

exit:		mov ax, 0x3100
			int 21h 