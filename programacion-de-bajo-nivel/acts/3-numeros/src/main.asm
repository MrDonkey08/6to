; Constantes
SYS_EXIT   equ 1
SYS_READ   equ 3
SYS_WRITE  equ 4
STDIN	  equ 0
STDOUT	 equ 1

NUM_DIGITS equ 4
NUM_CHARS  equ NUM_DIGITS + 1

; Variables inicializadas
section .data
	msg_1 DB "Digita el primer número: ", 0
	len_1 equ $- msg_1

	msg_2 DB "Digita el segundo número: ", 0
	len_2 equ $- msg_2

	msg_3 DB "El resultado de la suma es: ", 0
	len_3 equ $- msg_3

; Variables sin inicializar
section .bss
	num_1_str RESB NUM_CHARS
	num_2_str RESB NUM_CHARS

	num_1 RESB 1
	num_2 RESB 1

	res_str RESB NUM_DIGITS
	res RESB 1

section .text
	global _start

_start:
	; Impresión de msg_1
	PUSH DWORD msg_1
	PUSH DWORD len_1
	CALL printf

	; Ingreso de num_1_str
	PUSH DWORD num_1_str
	PUSH DWORD NUM_CHARS
	CALL scanf

	; Conversión de num_1_str a valor
	CALL ascii_to_num_1

	; Impresión de msg_2
	PUSH DWORD msg_2
	PUSH DWORD len_2
	CALL printf

	; Ingreso de num_2_str
	PUSH DWORD num_2_str
	PUSH DWORD NUM_CHARS
	CALL scanf

	; Conversión de num_2_str a valor
	CALL ascii_to_num_2

	; Suma: num_1_str + num_2
	PUSH DWORD [num_1]
	PUSH DWORD [num_2]
	CALL sum

	; Impresión de msg_3
	PUSH DWORD msg_3
	PUSH DWORD len_3
	CALL printf

	; Convertir resultado en ascii
	CALL num_to_ascii

	; Impresión de resultado
	PUSH DWORD res_str
	PUSH DWORD NUM_DIGITS
	CALL printf

exit:
	MOV eax, SYS_EXIT
	MOV ebx, 0
	INT 0x80

; Funciones

printf:
	PUSH ebp
	MOV ebp, esp

	MOV eax, SYS_WRITE
	MOV ebx, STDOUT
	MOV ecx, [ebp + 12]
	MOV edx, [ebp + 8]
	INT 0x80

	POP ebp
	RET

scanf:
	PUSH ebp
	MOV ebp, esp

	MOV eax, SYS_READ
	MOV ebx, STDIN
	MOV ecx, [ebp + 12]
	MOV edx, [ebp + 8]
	INT 0x80

	MOV BYTE [ecx + 3], 0

	POP ebp
	RET

ascii_to_num_1:
	centenas_1:
		MOV al, [num_1_str]
		SUB al, '0'

		MOV cl, 100
		MUL cl
		ADD bl, al

	decenas_1:
		MOV al, [num_1_str + 1]
		SUB al, '0'

		MOV cl, 10
		MUL cl
		ADD bl, al

	unidades_1:
		MOV al, [num_1_str + 2]
		SUB al, '0'
		ADD bl, al

	MOV [num_1], bl

	RET

ascii_to_num_2:
	centenas_2:
		MOV al, [num_2_str]
		SUB al, '0'

		MOV cl, 100
		MUL cl
		ADD bl, al

	decenas_2:
		MOV al, [num_2_str + 1]
		SUB al, '0'

		MOV cl, 10
		MUL cl
		ADD bl, al

	unidades_2:
		MOV al, [num_2_str + 2]
		SUB al, '0'
		ADD bl, al

	MOV [num_2], bl

	RET

num_to_ascii:
	MOV eax, [res]

	MOV BYTE [res_str], '0'

	centenas_3:
		MOV ebx, 100
		MOV edx, 0
		DIV ebx
		ADD eax, '0'
		MOV [res_str + 1], eax

	decenas_3:
		MOV eax, edx
		MOV ebx, 10
		MOV edx, 0
		DIV ebx
		ADD eax, '0'
		MOV [res_str + 2], eax

	unidades_3:
		ADD edx, '0'
		MOV [res_str + 3], edx

	RET

sum:
	PUSH ebp
	MOV ebp, esp

	MOV al, [ebp + 12]
	MOV bl, [ebp + 8]

	ADD bl, al
	MOV [res], bl

	POP ebp
	RET
