; Solution to this problem was developed by https://github.com/farhana1i

[org 0x0100]

    jmp main

oldisr: dd 0        ; old isr offset and segment
buffer: times 2000 dw 0 ; buffer to save video memory

; to clear video screen
clrscr:
push    es
push    ax
push    di

mov     ax, 0xb800
mov     es, ax
mov     di, 0
nextchar:
mov     word [es:di], 0x720
add     di, 2
cmp     di, 4000
jne     nextchar

pop     di
pop     ax
pop     es
ret

; to add some delay
delay:
push    cx
push    di

mov     cx, 0xFF
delay1:
mov     di, 0xFFF
delay2:
dec     di
jnz     delay2
loop    delay1

pop     di
pop     cx
ret

; to store video memory in buffer
store_buffer:
push    bp
mov     bp, sp
push    ax
push    cx
push    si
push    di
push    es
push    ds

mov     ax, 0xb800  ; points to video memory
mov     ds, ax
mov     si, 0
mov     ax, cs
mov     es, ax
mov     di, buffer
mov     cx, 2000

cld
rep     movsw    ; move data from video memory to buffer

pop     ds
pop     es
pop     di
pop     si
pop     cx
pop     ax
pop     bp
ret

; load buffer
load_buffer:
push    bp
mov     bp, sp
push    ax
push    cx
push    si
push    di
push    es
push    ds

mov     ax, 0xb800      ; points to video memory
mov     es, ax
mov     di, 0
; points to buffer
mov     ax, cs
mov     ds, ax
mov     si, buffer
mov     cx, 2000

cld
rep     movsw       ; load buffer in video memory

pop     ds
pop     es
pop     di
pop     si
pop     cx
pop     ax
pop     bp
ret


; hook key board interrupt with interrupt chaining
kbISR:
push    ax
in      al, 0x60     ; read a char from keyboard 

cmp     al, 00011101b  ; snap code of ctrl == 29
JNE     nextCmp

CALL    store_buffer   ; store video memory in a buffer
CALL    clrscr         ; clear screen
jmp     exit

nextCmp:
cmp     al, 10011101b   ; snap code of ctrl == 29
JNE     noMatch

CALL    delay          ; add some delay
CALL    load_buffer    ; load buffer in video memory
jmp     exit

noMatch:
pop     ax
jmp     far [cs:oldisr] ; CALL the original ISR

exit:
mov     al, 0x20        ; send EOI
out     0x20, al
pop     ax
iret



main:
xor     ax, ax
mov     es, ax
; save old keyboard isr
mov     ax, [es:9*4]
mov     [oldisr], ax
mov     ax, [es:9*4+2]
mov     [oldisr+2], ax

; hook keyboard interrupt
cli
mov     word [es:9*4], kbISR
mov     [es:9*4+2], cs
sti

; to make program TSR
mov     dx, main
add     dx, 15
mov     cl, 4
shr     dx, cl
mov     ax, 0x3100
INT     0x21
