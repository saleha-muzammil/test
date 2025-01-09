; solution developed by https://github.com/PySaqib

[org 0x0100]

mov ax, [0x0025]            ; copies the data from offset 0025 into AX
                            ; do m2 DS:0025 in DOSBOX input to verify.

mov ax, 0x4c00              ; exit.
int 0x21
