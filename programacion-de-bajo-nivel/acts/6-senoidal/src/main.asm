.model small
.data
    ; Constantes
    COLOR EQU 0x0f

    ; Variables
    tmp dw 0

    seno db 100, 108, 116, 124, 132, 140, 148, 155, 162, 168, 174, 179, 184, 188, 192, 195, 197, 198, 199, 198, 196, 193, 190, 186, 182, 177, 171, 165, 158, 151, 144, 136, 128, 120, 112, 104, 95, 87, 79, 71, 63, 55, 48, 41, 34, 28, 22, 17, 13, 9, 6, 3, 1, 0, 1, 2, 4, 7, 11, 15, 20, 25, 31, 37, 44, 51, 59, 67, 75, 83, 91, 100, 100, 108, 116, 124, 132, 140, 148, 155, 162, 168, 174, 179, 184, 188, 192, 195, 197, 198, 199, 198, 196, 193, 190, 186, 182, 177, 171, 165, 158, 151, 144, 136, 128, 120, 112, 104, 95, 87, 79, 71, 63, 55, 48, 41, 34, 28, 22, 17, 13, 9, 6, 3, 1, 0, 1, 2, 4, 7, 11, 15, 20, 25, 31, 37, 44, 51, 59, 67, 75, 83, 91, 100, 100, 108, 116, 124, 132, 140, 148, 155, 162, 168, 174, 179, 184, 188, 192, 195, 197, 198, 199, 198, 196, 193, 190, 186, 182, 177, 171, 165, 158, 151, 144, 136, 128, 120, 112, 104, 95, 87, 79, 71, 63, 55, 48, 41, 34, 28, 22, 17, 13, 9, 6, 3, 1, 0, 1, 2, 4, 7, 11, 15, 20, 25, 31, 37, 44, 51, 59, 67, 75, 83, 91, 100, 100, 108, 116, 124, 132, 140, 148, 155, 162, 168, 174, 179, 184, 188, 192, 195, 197, 198, 199, 198, 196, 193, 190, 186, 182, 177, 171, 165, 158, 151, 144, 136, 128, 120, 112, 104, 95, 87, 79, 71, 63, 55, 48, 41, 34, 28, 22, 17, 13, 9, 6, 3, 1, 0, 1, 2, 4, 7, 11, 15, 20, 25, 31, 37, 44, 51, 59, 67, 75, 83, 91, 100, 100, 108, 116, 124, 132, 140, 148, 155, 162, 168, 174, 179, 184, 188, 192, 195, 197, 198, 199, 198, 196, 193, 190, 186, 182, 177, 171, 165, 158, 151, 144, 136, 128, 120, 112, 104, 95, 87, 79, 71, 63, 55, 48, 41, 34, 28, 22, 17, 13, 9, 6, 3, 1, 0, 1, 2, 4, 7, 11, 15, 20, 25, 31, 37, 44, 51, 59, 67, 75, 83, 91, 100

    n equ $-seno

.code
    MOV ax, @data
    MOV ds, ax

    MOV ah, 0
    MOV al, 0x13
    INT 0x10

    MOV cx, n
    MOV si, 1

repite:
    MOV tmp, cx
    MOV cx, si
    MOV dl, seno(si + 1)
    MOV al, COLOR
    MOV ah, 0xC
    INT 0x10

    INC si
    MOV cx, tmp

    loop repite