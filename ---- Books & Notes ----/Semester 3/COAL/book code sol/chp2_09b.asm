; solution developed by https://github.com/PySaqib

[org 0x0100]

mov [0x0FFF], ax            ; copies the data from offset AX into offset 0x0FFF
                            ; do m2 DS:0FFF in DOSBOX input to verify.
                            ; you can view the value of AX to crosscheck.

mov ax, 0x4c00              ; exit.
int 0x21
