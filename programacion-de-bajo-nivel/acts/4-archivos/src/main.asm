section .data
    file_path  DD "./alan.txt", 0

    line_1     DD "Parangaricutirimicuaro", 0xA, 0xD, "$"
    len_line_1 equ 25

    line_2     DD "Hipopotomonstrosequipedaliofobia", 0xA, 0xD, "$"
    len_line_2 equ 35

section .text
    global _start

_start:
    XOR eax, eax
    XOR ebx, ebx
    XOR ecx, ecx
    XOR edx, edx

creating_and_opening_file:
    MOV al, 5               ; sys_open() call
    MOV ebx, file_path
    MOV cl, 0101o           ; CW accesss mode
                            ; 100 stands for create accesss
                            ; 001 stands for write access

    MOV dx, 0b110_100_000   ; RW permissions for Owner  (6)
                            ; R  permissions for Group  (4)
                            ; No permissions for Others (0)

    INT 0x80                ; File descriptor saved in 'eax' after interruption

writing_line_1:
    MOV ebx, eax            ; File descriptor
    MOV eax, 4              ; sys_write() call
    MOV ecx, line_1         ; content
    MOV edx, len_line_1     ; content_size
    INT 0X80

writing_line_2:
    MOV eax, 4              ; sys_write() call
    MOV ecx, line_2         ; content
    MOV edx, len_line_2     ; content_size
    INT 0X80

; also takes file descriptor from 'ebx' (already saved)
closing_file:
    MOV eax, 6              ; sys_close() call
    INT 0x80

removing_file:
    MOV eax, 10             ; sys_unlink() call
    MOV ebx, file_path
    INT 0x80

exit:
    MOV eax, 1
    MOV ebx, 0
    INT 0x80
