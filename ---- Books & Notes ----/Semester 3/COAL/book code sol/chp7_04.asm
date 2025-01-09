[org 0x0100]


start:				sub sp, 2							;return value

					call findEqualSegments

					pop bx								;ax = 1 indicates two equal segments are found otherwise
														;bx = 0

end:				mov ax, 0x4c00
					int  21h






findEqualSegments:	push bp 
					mov bp, sp
					pusha

					mov word [bp + 4], 0

					mov ax, 0
					mov dx, 0
					mov si, 0
					mov di, 0
					mov cx, 0xFFFF


					;Finding tw non-overlapping and equal segments

					;There are a total of 16 distinct segments in a memory of 1MB


					mov ds, ax						;Starting from the segment 0x0000 (1st Segment)
					mov ax, 0x1000					
					mov es, ax						;2nd Segment 

					cld

loop1:				repe cmpsb 						;repeat while equal cx times
					je areEqual 					;if the segments were equal 

check_ES:			mov ax, es
					cmp ax, 0xF000					;checking for the last segment (16th Segment)
					jz  check_DS


					mov ax, es						;Next non-overlapping segment
					add ax, 0x1000
					mov es, ax

					mov di, 0
					mov si, 0
					mov cx, 0xFFFF

					jmp loop1



check_DS:			mov ax, ds
					cmp ax, 0xF000				;If DS = 0xF000, it means we are at the last segment, and this 														;segment doesn't need to be compared with itself. So no further 													;processing is to be done and we haven't found two		 															;equal segments 

					jz return

					mov ax, ds 					;Next non-overlapping segment
					add ax, 0x1000
					mov ds, ax


					add ax, 0x1000
					mov es, ax

					mov si, 0
					mov di, 0
					mov cx, 0xFFFF
					jmp loop1	


areEqual:		    mov word [bp + 4], 1		;Two equal segments are found 
									

return:				popa
					pop bp
					ret



;Two overlapping and equal segments can be found, but the processing takes too much time.
;Anyways, the code for that is given below
;instead of adding 0x1000, now 0x0001 is being added and instead of comparing with 0xF000, now the comparision
;is being done with 0xFFFF



;					mov ds, ax						;Starting from the segment 0x0000 (1st Segment)
;					mov ax, 0x0001					
;					mov es, ax						;2nd Segment 

;					cld

;loop1:				repe cmpsb 						;repeat while equal cx times
;					je areEqual 					;if the segments were equal 
;
;check_ES:			cmp es, 0xFFFF					;checking for the last segment
;					jz  check_DS
;
;
;					mov ax, es						;Next overlapping segment
;					add ax, 0x0001
;					mov es, ax
;
;					mov di, 0
;					mov si, 0
;					mov cx, 0xFFFF
;
;					jmp loop1
;
;
;
;check_DS:			cmp ds, 0xFFFF				;If DS = 0xFFFF, it means we are at the last segment, and this 														;segment doesn't need to be compared with itself. So no further 													;processing is to be done and we haven't found two		 															;equal segments 
;
;					jz return
;
;					mov ax, ds 					;Next overlapping segment
;					add ax, 0x0001
;					mov ds, ax
;
;
;					add ax, 0x0001
;					mov es, ax
;
;					mov si, 0
;					mov di, 0
;					mov cx, 0xFFFF
;					jmp loop1
