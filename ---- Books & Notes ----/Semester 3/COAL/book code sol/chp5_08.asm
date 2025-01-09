[org 0x0100]

	jmp start

arr: dw 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64


start:		mov ax, 13

			sub sp,2

			push ax

			call myalloc

			pop ax


			push ax			 ;Index
			push 13          ;Bits

			call myfree


end:		mov ax, 0x4c00
			int 21h



;------------------------------------------------------------------


myalloc:	push bp
			mov bp,sp

			sub sp,4 								;creating space for two local variables
													;bp - 2 will be used to store the index temporarily
													;bp - 4 will be used to hold the status of zeroes whether they   
													;  		are currently being checked or not.


			pusha

			mov ax, 0
			mov bx, 0
			mov cx, 0

			mov word [bp - 2], -1                   ;index is -1 by default

			mov si, [bp + 4] 						;No. of zeroes to be checked

			cmp si, 0                               ;If no. zero bits to be checked is 0, then do nothing
			jz  dreturn

			mov dx, 1000000000000000b 				;mask for testing bits

			
			mov word [bp - 4], 0                    ;Currently we don't have a zero at hand


loop1:		test byte [arr + bx] , dh
			jnz  reset

			cmp word [bp - 4],1                     ;If some zeroes are at hand then don't store a new index
			jz  loop2

zeroFound:	mov word [bp - 2], cx					;Storing the index of the first zero found
			mov word [bp - 4], 1                    ;Currently a zero is found .
			
loop2:		inc ax									;No. of zeroes currently checked
			cmp ax,si
			jz  changeto1

l1:			inc cx
	
			cmp cx, 0x400 							;0x400bits is equivalent to 1024 bits
			jz  return                              ;Means you are at the end of the arr 

			shr dh,1
			cmp dh,0
			jz  update

			jmp loop1


update:		mov dx, 1000000000000000b
			add bx, 1
			jmp loop1


reset:		mov ax, 0
			mov word [bp - 2], -1
			mov word [bp - 4],  0
			jmp l1

dreturn: 	jmp return                            ;Used because of short range jump issue at line 53

; After finding that many consecutive zero bits in the array , making them one

changeto1: 	mov ax,0
			mov bx,0
			mov cx,0
			mov dx,8

			mov ax, [bp - 2]	;starting bit (index)

			div dl

			mov dx, 0

			mov dl,al
			mov bx,dx           ;Now bx contains the byte number which contains the starting index

			mov dx,1000000000000000b

			cmp ah,0
			jnz scenario1


scenario0:	;Desired Byte doesn't split into two bytes
	
loop3:		or byte [arr + bx], dh

			inc cl		
			cmp cl, [bp + 4]
			jz  return

			shr dh,1
			cmp dh,0
			jz  update1
			jmp loop3
	

;Desired Byte splits into two bytes 

scenario1:	mov cl, ah
			shr dx, cl

			jmp loop3


update1:	mov dx,1000000000000000b
			add bx,1
			jmp loop3



return:		mov ax, [bp - 2]
			mov [bp + 6], ax

			popa
			
			add sp, 4
			pop bp

			ret  2

;--------------------------------------------------------------




myfree:		push bp
			mov bp,sp
			pusha

			mov ax,0
			mov bx,0
			mov cx,0
			mov dx,8

			mov ax, [bp + 6]

			div dl

			mov dx, 0

			mov dl,al
			mov bx,dx           ;Now bx contains the byte number which contains the starting index

			mov dx,0111111111111111b

			cmp ah,0
			jnz _scenario1


_scenario0:	;Desired Byte doesn't split into two bytes
	
_loop3:		and byte [arr + bx], dh

			inc cl		
			cmp cl, [bp + 4]
			jz  _return

			shr dh,1
			cmp dh,0
			jz  _update1
			jmp _loop3
	

;Desired Byte splits into two bytes 

_scenario1:	mov cl, ah
			shr dx, cl

			jmp _loop3


_update1:	mov dx,0111111111111111b
			add bx,1
			jmp _loop3



_return:		popa
				pop bp
				ret 4

;-------------------------------------------------------------


