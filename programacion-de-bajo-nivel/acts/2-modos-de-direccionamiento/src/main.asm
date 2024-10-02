section .data
	lista DW 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 0; 0 se usa como valor NULL

section .text
	global _start

_start:
	; Limpiando los registros
	XOR eax, eax ; acumulador
	XOR ebx, ebx ; base
	XOR ecx, ecx ; contador
	XOR edx, edx ; datos

	; Inmediato
	MOV eax, 0xFF; Valor a registro 'ax'

	; De registro
	MOV ebx, eax ;  Registro 'ax' a 'dx'

	; Base relativa más índice
	MOV [lista + 3], bx ; Se guarda la fuente (12) dentro de la 3ra dirección
	                    ; de memoria después de la variable índice

	SUB ax, bx ; Resta: ax -= bx (0xFF + 3 = 0x102). Resultado se guarda en ax

	; Directo
	MOV [0x804a004], ax ; De registro a dirección en memoria. Se almacenará el
	                    ; valor de 'ax' en el 5to valor de 'lista' (valores de
	                    ; 2 bytes)

	                    ; 0x804a000 es la dirección de memoria principal de
	                    ; .data section

	; De registro relativo
	MOV cx, [lista + 1] ; 2da dirección de memoria después del lnicio de la
	                    ; lista (valor 3)

	MOV ebx, lista ; Dirección de memoria de variable lista y, por ende, de
	               ; inicio de .data section

	; Base más índice
	MOV [ebx + 2], ax ; Se sustiuirá el 2do elemento por el valor de 'ax' (datos
	                  ; de 2 bytes)


	; Registro indirecto
	MOV [ebx], ecx ; Modificará el primer valor de 'lista'

	; Registro relativo
	MOV dx, [ebx + 4] ; Guardará el 3er valor de lista en 'ax' (datos de 2
	                  ; bytes)

	; Indice escalado
	MOV [ebx + 6 * 2], dx ; Se reemplazará el 7mo elemento por el valor de 'dx'
	                      ; (Se multiplica * 2 porque son datos de 2 bytes)

	MOV eax, 1
	MOV ebx, 0
	INT 0x80
