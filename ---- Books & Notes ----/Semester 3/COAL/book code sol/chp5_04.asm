[org 0x0100]

start:			mov ax, 6
			
				sub sp,2
				push ax

				call fibonacci

				pop ax

end:			mov ax, 0x4c00
				int 21h



fibonacci:		push bp
				mov bp,sp

				pusha

				mov ax, [bp + 4]

				mov word [bp + 6], 0  	;Initializing the return value to 0

case1:			cmp ax,1
				jnz case0
				mov word [bp + 6], 1
				jmp return


case0:			cmp ax,0
				jnz l1
				mov word [bp + 6], 0
				jmp return


l1:				mov dx, 0           
				mov bx, 0 			;bx= F(0) = 0
				mov cx, 1			;cx= F(1) = 1
			
	
loop1:			cmp ax,1
				jz return

				mov dx,cx
				add dx,bx
				mov [bp + 6],dx

				mov bx, cx
				mov cx, [bp + 6]

				dec ax
				jmp loop1

return:			popa
				pop bp
				ret 2				


;--------------------------------------------------------
;Logic Explained

;Carefully read this function


;	int fibonacci (int n)
;	{	
;			if( n == 1 )
;			   return 1;
;
;			if( n == 0 )
;			  return 0;
;
;			int f0 = 0;
;			int f1 = 1;
;			int fn = 0;
;	
;			for(int i=1 ; i<n ; i++)	
;			{
;				fn = f1 + f0		
;				f0 = f1
;				f1 = fn
;			}
;			
;			return fn;
;	}

;-------------------------------------------------------
