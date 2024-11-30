; Macros
%macro assign 2
    MOV ax, [%2]
    MOV [%1], ax
%endmacro

%macro negate 1
    MOV ax, [%1]
    NEG ax
    MOV [%1], ax
%endmacro

%macro inc_var 1
    MOV ax, [%1]
    INC ax
    MOV [%1], ax
%endmacro

%macro dec_var 1
    MOV ax, [%1]
    DEC ax
    MOV [%1], ax
%endmacro

%macro compare_2_vars 2
    MOV cx, [%1]
    CMP cx, [%2]
%endmacro

%macro compare_var_and_num 2
    MOV cx, [%1]
    CMP cx, %2
%endmacro

%macro add_and_assign 3
    MOV ax, [%2]
    ADD ax, [%3]
    MOV [%1], ax
%endmacro

%macro sub_and_assign 3
    MOV ax, [%2]
    SUB ax, [%3]
    MOV [%1], ax
%endmacro

%macro add_3_nums_and_assign 4
    MOV ax, [%2]
    ADD ax, [%3]
    ADD ax, [%4]
    MOV [%1], ax
%endmacro

%macro sub_3_nums_and_assign 4
    MOV ax, [%2]
    SUB ax, [%3]
    SUB ax, [%4]
    MOV [%1], ax
%endmacro

; Macro para dibujar un píxel
%macro draw_pixel 2
    MOV cx, [%1]  ; columna
    MOV dx, [%2]  ; fila

    MOV al, GREEN  ; color verde
    MOV ah, 0ch    ; función para poner píxel
    INT 0x10       ; interrupción de video
%endmacro

; Macro para dibujar un círculo
%macro draw_circle 3
    assign y_off, %3
    assign balance, %3
    negate balance

    draw_circle_loop:
        add_and_assign x_plus_x, %1, x_off
        sub_and_assign x_minus_x, %1, x_off
        add_and_assign y_plus_y, %2, y_off
        sub_and_assign y_minus_y, %2, y_off

        add_and_assign x_plus_y, %1, y_off
        sub_and_assign x_minus_y, %1, y_off
        add_and_assign y_plus_x, %2, x_off
        sub_and_assign y_minus_x, %2, x_off

        draw_pixel x_plus_y, y_minus_x
        draw_pixel x_plus_x, y_minus_y
        draw_pixel x_minus_x, y_minus_y
        draw_pixel x_minus_y, y_minus_x
        draw_pixel x_minus_y, y_plus_x
        draw_pixel x_minus_x, y_plus_y
        draw_pixel x_plus_x, y_plus_y
        draw_pixel x_plus_y, y_plus_x

        add_3_nums_and_assign balance, balance, x_off, x_off

        compare_var_and_num balance, 0
        JL balance_negative

        dec_var y_off
        sub_3_nums_and_assign balance, balance, y_off, y_off

        balance_negative:
            inc_var x_off

            compare_2_vars x_off, y_off
            JG end_drawing
            JMP draw_circle_loop

        end_drawing:
%endmacro

section .data
    ; Constantes
    GREEN equ 0xA

    ; Variables inicializadas
    x DW 80 ; coordenada X del centro
    y DW 80 ; coordenada Y del centro
    r DW 20 ; radio del círculo

    balance DW 0
    x_off DW 0
    y_off DW 0

    x_plus_x DW 0
    x_minus_x DW 0
    y_plus_y DW 0
    y_minus_y DW 0

    x_plus_y DW 0
    x_minus_y DW 0
    y_plus_x DW 0
    y_minus_x DW 0

section .text
    global _start

_start:
    org 0x100

    MOV ah, 0    ; función para establecer modo de video
    MOV al, 0x13 ; modo 0x13 = 320x200 píxeles, 256 colores
    INT 0x10     ; configurar el modo de video

    draw_circle x, y, r

    ; Esperar pulsación de tecla
    MOV ah, 0
    INT 0x16

    ; Volver al modo texto
    MOV ah, 0    ; función para establecer modo de video
    MOV al, 3    ; modo texto estándar
    INT 0x10     ; configurar el modo
