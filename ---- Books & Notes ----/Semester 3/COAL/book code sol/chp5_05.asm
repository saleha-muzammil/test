[org 0x0100]

		jmp start



new_stack_segment: dw 0x1234
new_stack_offset:  dw 0xFFFE



start:				mov ax,0xABCD    ;Test values
					mov cx,0
		
					push ax
					push 123

					push word [new_stack_segment]
					push word [new_stack_offset]
		
					call switch_stack

					pop cx
					pop bx
		
end:				mov ax, 0x4c00
					int 21h  
		
		
		
switch_stack:		push bp
					mov bp,sp
					
					pusha
					
					mov bx,sp
					sub bx,2
					
					mov si,0xFFFC           ;si will be used to make a copy of the old stack and it is currently 	
											;pointing at the bottom element of the old stack
					
					mov sp, [bp + 4]		;new offset
					mov ss, [bp + 6]		;new stack segment
					

loop1:				push word [si]
					sub si,2
					cmp si,bx
					jnz loop1


return:				popa
					pop bp
					ret 4
	
					