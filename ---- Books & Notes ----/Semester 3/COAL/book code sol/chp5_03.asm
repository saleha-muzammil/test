[org 0x0100]

start:			mov ax, 4
			
				sub sp,2
				push ax

				call fibonacci

				pop ax

end:			mov ax, 0x4c00
				int 21h



fibonacci:		push bp
				mov bp,sp

				sub sp,2

				pusha

				mov ax, [bp + 4]

basecase1:		cmp ax,1
				jnz basecase2
				mov word [bp + 6],1
				jmp return


basecase2:		cmp ax,0
				jnz calls				
				mov word [bp + 6],0
				jmp return


calls:			sub sp,2
				dec ax
				push ax 

call1:			call fibonacci

				pop word [bp - 2]             ;A local variable used to store the return value from the first 
											  ;recursive call

				sub sp,2
				dec ax
				push ax

call2:			call fibonacci
				pop dx

				add dx, [bp - 2]
				mov [bp + 6],dx

return:			popa
				add sp,2
				pop bp
				ret 2				


;--------------------------------------------------------
;Logic Explained

;Carefully read this function


;	int fibonacci (int n)
;	{	
;			int x;				;The local variable made to store the result from first recursive call
;
;			if( n == 1 )
;			   return 1;
;
;			if( n == 0 )
;			  return 0;
;
;		
;			x = fibonacci (n - 1);
;			x = x + fibonacci (n - 2);
;			
;			return x;
;	}

;-------------------------------------------------------
