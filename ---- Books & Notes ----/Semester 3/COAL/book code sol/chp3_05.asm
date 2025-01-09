;Binary Search

[org 0x0100]

	jmp start1

data:  db 1,2,3,4,5,6,7,8,9,10,11
start: db  0
end:   db  10
key:   db  -1

start1:	mov al,[key] 

loop1: mov cl,[start]
	   cmp cl,[end]
	   ja end1 	 				;Checking if(start<=end), if not then jump to end1

	   mov dl,[start]
	   add dl,[end] 			;dl is basically now start + end
	   sar dl,1  				;here dl is being divided by 2
	   mov bl,dl  				;bl is mid and is calculated by (start + end)/2


	  cmp  al, [data + bx]
	  je store 					; agar data mil gaya tw program end kar do
	  ja step1 					; agar data greater hai current element sey
	  jb step2 					; agar data smaller hai current element sey

step1: add dl,1  				;mid + 1 kar do
	   mov [start],dl 			;start ko ab mid + 1 kar do taakey hum mid se aagey jaga par dekhein
	   jmp loop1

step2: sub dl,1 				;mid -1 kar do
	   mov[end],dl				;end ko ab mid - 1 kar do taakey hum mid se previous jaga par dekhein
	   jmp loop1


store: mov ax, 1
	   mov ax,0x4c00
	   int 21h

end1:  mov ax,0
	   mov ax,0x4c00
	   int 21h 
