; solution developed by https://github.com/PySaqib

[org 0x0100]

mov ax, 0                   ; setting AX to 0.
mov cx, 20                  ; the number of times we want the loop to run.

l1:                         ; main loop
    add ax, 20              ; adding our number.
loop l1                     ; looping directive
                            ; this does --cx and then jumps to l1

mov ax, 0x4c00              ; exit.
int 0x21
