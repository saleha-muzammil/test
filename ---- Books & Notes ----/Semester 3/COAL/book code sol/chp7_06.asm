;  Write a subroutine “strcpy” that takes the address of two parameters via stack, 
;the one pushed first is source and the second is the destination. 
;The function should copy the source on the destination 
;including the null character assuming that sufficient space is reserved starting at destination.



[org 0x0100]



start: 		push src
			push dest

			call strcpy

end:		mov ax, 0x4c00
			int 21h



;-----------------------------------------------------------------------------------------------------------

strLen:			push bp
				mov bp, sp
				pusha

				push es

				push ds
				pop es

				mov di, [bp+4]		;Point di to string 
				mov cx, 0xFFFF		;Load Maximum No. in cx
				mov al, 0 			;Load a zero in al
				repne scasb			;find zero in the string

				mov ax, 0xFFFF 		;Load Maximum No. in ax
				sub ax, cx          ;Find change in cx
				dec ax				;Exclude null from length

				mov [bp+6], ax


				pop es

				popa
				pop bp
				ret 2

;-----------------------------------------------------------------------------------------------------------





strcpy:			push bp
				mov bp, sp
				pusha

				push es


				;bp + 6  = src address
				;bp + 4  = dest address


				mov si, [bp + 6]				;Setting si to source str


				push ds
				pop  es                         ;Setting es


				mov di, [bp + 4]				;Setting di to destination str


				sub sp, 2 
				push word [bp + 6]
				call strLen						;Calculating the length of source string
												;because ultimately the source and the destination will be of the same size

				pop cx

				inc cx							;Incrementing cx by one so that null character gets included in the string length

				rep movsb


				pop es

return:			popa
				pop bp
				ret 4

;-----------------------------------------------------------------------------------------------------------


src: 	db 'My name is NULL',0
dest:	db 000000000000000
