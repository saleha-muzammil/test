[org 0x0100]

		jmp start

_segment: 		dw 0x3000
_offset : 		dw 0x1000



start:			push word [_segment] ; 
				push word [_offset]  ; 
				call reverseArray

end:			mov ax, 0x4c00
				int  21h
	

reverseArray:	push bp	
				mov bp, sp 
				pusha

				mov cx, 0xFFFF				;To compare 64k words, the comparision should be done for 32k words only
			 	
				mov ds, [bp + 6]			;Starting Segment 
				mov si, [bp + 4]			;Starting Offset
				mov di, si					;Ending Offset

			 	mov ax, ds
			 	add ax, 0x2000				;going to the third segment
 				mov es, ax

 				std 						;set direction flag


 				cmp di, 0
 scenario0:		jnz loop1					;We have three overlapping segments

 scneario1:		mov dx, es
 				sub dx, 0x1000				;We have two non-overlapping segments
 				mov es, dx

 				mov di, 0xFFFE


loop1:			mov ax, [es : di]
 				movsw

 				add si, 2				;because 2 has been subtracted by movsw
 				mov [si], ax			;swapping values
 				add si, 2

		 		cmp si, 0xFFFF			;check if the segment has ended 
 				jne l1

 				mov dx, ds
 				add dx, 0x1000			;if ended move on to the next segment
		 		mov ds, dx

		 		mov si, 0				;resetting si
 			


l1:				cmp di, 0xFFFE			;if the last seg has ended 
 				jne l2
 				
 				mov dx, es
 				sub dx, 0x1000			;going to the 2nd segment backward
 				mov es, dx

 				mov di, 0xFFFE			;resetting to last word


l2:				loop loop1	 

	

return:			popa
				pop bp
				ret 4


