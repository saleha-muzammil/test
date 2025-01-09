[org 0x0100]

	jmp start


XISR_Offset:		dw  0x0000
XISR_Segment:		dw  0x0000
N:					dw  0x80

;-----------------------------------------------------------------------------------------------------------------


hooker:		push bp
			mov bp, sp

			sub sp, 4				;Making two local variables, one for old offset and one for old segment of the ISR previously hooked at N

			pusha
			push es


			;bp - 2 				;Old segment
			;bp - 4					;Old offset

			;bp + 4					;XISR Offset
			;bp + 6 				;XISR Segment 
			;bp + 8 				;Interrupt No. 'N'


			xor ax, ax
			mov es, ax
			

			mov di, [bp + 8] 	 	;Interrupt No. 'N'


			;First of all saving the offset, segment of the ISR previously hooked at N

			shl di, 2 				;Multiplying by 4

			;Saving the offset
			mov bx, [es:di]
			mov [bp - 4], bx

			;Saving the segment
			mov bx, [es:di + 2]
			mov [bp - 2], bx



			;Loading the segment of XISR in es
			mov es, [bp + 6]


			;Chaining the XISR to the old ISR previously hooked at N

			mov bx, [bp + 4]            ;Offset of XISR

			mov ax, [bp - 4] 			;Offset 
			mov dx, [bp - 2]			;Segment
			

			mov [es:bx + 2], ax
			mov [es:bx + 4], dx


			;Now hooking XISR at N
			mov ax, 0
			mov es, ax

			mov di,[bp + 8]

			shl di, 2 					;Multiplying by 4


			mov ax,[bp + 4] 			;Offset of XISR
			mov [es:di], ax
			mov ax, [bp + 6] 			;Segment of XISR
			mov [es:di+ 2], ax


return:		pop es
			popa

			add sp, 4

			pop bp
			ret 6

;--------------------------------------------------------------------------------------------------------------------



;---------------------------------------------------------------------------------------------------------------------
XISR:	    pushf
			call 0:0

			popf
			ret


;---------------------------------------------------------------------------------------------------------------------

start:		push word [N]
		
			mov  word [XISR_Offset], XISR
			mov  word [XISR_Segment], cs

			push word [XISR_Segment]
			push word [XISR_Offset]

			call hooker


			mov ax, 0x4c00
			int 21h