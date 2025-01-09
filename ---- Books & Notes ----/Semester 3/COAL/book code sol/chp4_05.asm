[org 0x0100]

		jmp start

multiplicand:		dd -00001300,00000000
multiplier:			dd 00000500
result:				dd 00000000, 00000000


;Check for signed numbers

start:				mov si,0

					cmp byte [multiplicand + 3], 0   ;Compare the Most Significant Byte with 0, because it will tell 
													 ;you whether the number is positive or negative
					jge l1

					;If multiplicand is negative then take 2's complement of the Multiplicand

					not word [multiplicand]
					not word [multiplicand + 2]
					add word [multiplicand], 1
					inc si


l1:					cmp byte [multiplier + 3], 0     ;Compare the Most Significant Byte with 0, because it will tell 
													 ;you whether the number is positive or negative
					jge l2					
					
					;If multiplier is negative then take 2's complement of the Multiplier
					
					not word [multiplier]
					not word [multiplier + 2]
					add word [multiplier], 1
					inc si					



l2:					mov dx, [multiplier]  			;LSW (Least Significant Word) of mulitplier

					mov cl,32
					mov bx,1


checkbit:			test bx, dx
					jz  skip


					mov ax, [multiplicand]
					add [result],ax
					mov ax, [multiplicand + 2]
					adc [result + 2],ax
					mov ax, [multiplicand + 4]
					adc [result + 4],ax
					mov ax, [multiplicand + 6]
					adc [result + 6],ax


skip:				shl word [multiplicand]	   ,1
					rcl word [multiplicand + 2],1
					rcl word [multiplicand + 4],1
					rcl word [multiplicand + 6],1


					shl bx,1
					dec cl

					cmp cl,16
					jz update

					cmp cl,0
					jnz checkbit
					jz end


update:				mov bx,1
					mov dx,[multiplier + 2]  ;MSW (Most Significant Word) of mulitplier	
					jmp checkbit


end:				cmp si,1
					jnz _end 


					;2's complement of the result
					
					not word [result]
					not word [result + 2]
					not word [result + 4]
					not word [result + 6]
					add word [result],1

_end:				mov ax, 0x4c00
					int 21h

