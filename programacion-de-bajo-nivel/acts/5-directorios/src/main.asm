section .data
    ; Constantes
    BUFFER_SIZE equ 256

    ; Variables
    parent_dir DB "..", 0
    dir   DB "alan", 0
    file  DB "juarez.txt", 0

    msg_1 DB "El directorio actual es: ", 0xA, 0
    len_1 equ $-msg_1

    new_line DB 0xA, 0xA, 0

section .bss
    buffer RESB BUFFER_SIZE ; Buffer to hold the cwd
    wd RESB BUFFER_SIZE     ; Buffer to hold the cwd

    timestamp RESD 1
    file_descriptor RESD 1

section .text
    global _start

_start:
    ; Cleaning of registers (initializing them at 0)
    XOR eax, eax
    XOR ebx, ebx
    XOR ecx, ecx
    XOR edx, edx

get_cwd:
    ; Get current working directory
    MOV eax, 183            ; sys_getcwd() syscall number
    MOV ebx, wd
    MOV ecx, BUFFER_SIZE
    INT 0x80

create_dir:
    MOV eax, 39             ; sys_mkdir() syscall number
    MOV ebx, dir
    MOV cx, 0b110_100_000   ; RW permissions for Owner  (6)
                            ; R  permissions for Group  (4)
                            ; No permissions for Others (0)
    INT 0x80

change_dir:
    MOV eax, 12             ; sys_chdir() syscall number
    MOV ebx, dir            ; Pointer to the directory name
    INT 0x80

get_new_cwd:
    ; Get current working directory
    MOV eax, 183            ; sys_getcwd() syscall number
    MOV ebx, buffer
    MOV ecx, BUFFER_SIZE
    INT 0x80

print_new_cwd:
    ; Print msg_1
    MOV eax, 4              ; sys_write() syscall number
    MOV ebx, 1              ; File descriptor 1 (stdout)
    MOV ecx, msg_1
    MOV edx, len_1
    INT 0x80

    ; Get cwd
    MOV eax, 4              ; sys_write() syscall number
    MOV ebx, 1              ; File descriptor 1 (stdout)
    MOV ecx, buffer
    MOV edx, BUFFER_SIZE
    INT 0x80

    ; new_line
    MOV eax, 4              ; sys_write() syscall number
    MOV ebx, 1              ; File descriptor 1 (stdout)
    MOV ecx, new_line
    MOV edx, 2
    INT 0x80

create_file:
    MOV eax, 8              ; sys_creat() syscall number
    MOV ebx, file
    MOV ecx, 0b110_100_000  ; RW permissions for Owner  (6)
                            ; R  permissions for Group  (4)
                            ; No permissions for Others (0)
    INT 0x80                ; Missing INT 0x80 added here

open_file:
    MOV eax, 5              ; sys_open() syscall number
    MOV ebx, file
    MOV ecx, 1              ; Write access
    MOV edx, 0b110_100_000  ; RW permissions for Owner  (6)
                            ; R  permissions for Group  (4)
                            ; No permissions for Others (0)
    INT 0x80

    MOV [file_descriptor], eax

; FIX: Convert the timestamp to a date and save it on file instead
; NOTE: I couldn't convert it because it's too complex. I leave it as timestamp
; HACK: I may use a C library. Instead of convert it manually

read_date:
    MOV eax, 13             ; sys_time() syscall number
    XOR ebx, ebx            ; Null pointer to store in eax
    INT 0x80

    MOV [timestamp], eax


write_file:
    MOV eax, 4              ; sys_write() syscall number
    MOV ebx, [file_descriptor]
    MOV ecx, timestamp      ; Pass the address of the timestamp
    MOV edx, 4              ; Writing 4 bytes for the timestamp
    INT 0x80

close_file:
    MOV eax, 6              ; sys_close() syscall number
    MOV ebx, [file_descriptor]
    INT 0x80

change_parent_dir:
    MOV eax, 12             ; sys_chdir() syscall number
    MOV ebx, parent_dir     ; Pointer to the directory name
    INT 0x80

print_cwd:
    ; Print msg_1
    MOV eax, 4              ; sys_write() syscall number
    MOV ebx, 1              ; File descriptor 1 (stdout)
    MOV ecx, msg_1
    MOV edx, len_1
    INT 0x80

    ; Get cwd
    MOV eax, 4              ; sys_write() syscall number
    MOV ebx, 1              ; File descriptor 1 (stdout)
    MOV ecx, wd
    MOV edx, BUFFER_SIZE
    INT 0x80

    ; new_line
    MOV eax, 4              ; sys_write() syscall number
    MOV ebx, 1              ; File descriptor 1 (stdout)
    MOV ecx, new_line
    MOV edx, 2
    INT 0x80

exit:
    MOV eax, 1              ; sys_exit() syscall number
    XOR ebx, ebx            ; Exit code 0
    INT 0x80
