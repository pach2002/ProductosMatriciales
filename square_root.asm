section .data
    format db "%d", 10, 0     ; Cadena de formato para imprimir un entero seguido de un salto de línea

section .text
    global _start

_start:
    fld dword [dividend]     ; Cargar el dividendo en el coprocesador de punto flotante (FPU)
    fdiv dword [divisor]     ; Realizar la división con el divisor

    ; Alinear el resultado en la parte baja de la pila del FPU
    sub esp, 4
    fstp dword [esp]

    ; Convertir el resultado en un entero truncado
    fild dword [esp]

    ; Almacenar el resultado entero truncado en memoria
    mov dword [resultado], eax

    ; Imprimir el resultado entero truncado
    mov eax, 4               ; Número de llamada al sistema para escribir (stdout)
    mov ebx, 1               ; Descriptor de archivo para stdout
    mov ecx, resultado       ; Dirección del resultado entero truncado
    mov edx, 4               ; Número de bytes a escribir
    int 0x80                 ; Llamar al kernel

    ; Salir del programa
    mov eax, 1               ; Número de llamada al sistema para salir
    xor ebx, ebx             ; Código de estado de salida 0
    int 0x80                 ; Llamar al kernel

section .data
    dividend dd 10.0         ; Dividendo (valor flotante)
    divisor dd 3.0           ; Divisor (valor flotante)
    resultado dd 0           ; Almacenará el resultado entero truncado
