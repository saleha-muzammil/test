; solution developed by https://github.com/PySaqib

[org 0x0100]

                            ; NOTE: You cannot perform memory to memory operations in assembly.
                            ; We use a register to hold value temporarily.

mov ax, [0x0010]            ; copying contents of 0010 into AX.
mov word [0x002F], ax       ; copying contents at offset 002F from AX.

mov ax, 0x4c00              ; exit.
int 0x21
