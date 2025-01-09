;Program to calculate factorial

[org 0x0100]

	jmp start

num : dw 4
fact: dw 0

start: 		mov ax,[num] ; ax is x    (ax is 4)
			mov bx,0     ;used instead of result
			 		
loop1:		cmp ax,1 	 ;(1 ya 1 se less har number par is label par move kar jayo)
			jle fact0

	   		mov dx,ax	; (mai ax sey aik kam dx mai rakhwa deta hun i.e x-1 )
	   		sub dx,1    ;  (is case mai dx is 3)
	   		mov cx,dx   ; cx is x - 1


multiply:	shr cx,1
			jnc noaddition
			add bx,ax

noaddition:	cmp cx,0
			jz next

			shl ax,1
			jmp multiply		

next: 		sub dx,1 ; (ab next 12 ne multiply hona hai 2 se , isi lye dx jo ke 3 tha usey subtract kar key 2 kya)
			mov ax,dx
			cmp ax,1 ; 	(doobara match kar lya ke kahin ax 1 ya 1 se less tw nahi ho gaya. Agar ho gaya tw bas 		   		 ;    multiplication end kar do)
			jle fact0

			mov ax,bx	;for example in case of fact 4 (4*3*2*1), pehley 4*3 huwa aur us ka result 12 bx mai aya
						; ab 12*2 hona hai isi lye bx ko ax mai rakhwa dya takey ax=12 ho aur phir cx=2 ho aur woh  ;phir multiply hon

			mov bx,0     ;Next multiplication ke lye result ko doobara se initialize kar dya 0 pey
	   		mov cx,dx    ;cx is x - 1 (is case mai ab cx 2 ho ga) 
	   		jmp multiply ; (now 12*2 will be done)
				

fact0:		cmp bx,0
			jnz movebx

			mov word [fact],1
       		jmp end

movebx:		mov [fact],bx		

end:		mov ax,0x4c00
			int 21h