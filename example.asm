section .data
    EXIT_SUCCESS   equ 0 ; operación exitosa
    SYS_EXIT       equ 60 ; finalizar

    ola db 57 ; '1', '2'

    ;HAY QUE CONVERTIRLO EN UNA MACRO
    ;DE ESTA MANERA, PODEMOS USARLO

section .text
global _start
_start:
    sub byte [ola], '0' ; Restar el valor ASCII '0' al primer dígito
    sub byte [ola+1], '0' ; Restar el valor ASCII '0' al segundo dígito

    mov al, byte [ola] ; Mover el primer dígito a AL
    mov ah, 0 ; Limpiar AH

    mov bl, 10 ; Multiplicador para el primer dígito (10^1)
    mul bl ; Multiplicar AL por BL

    add al, byte [ola+1] ; Sumar el segundo dígito a AL

    ; Ahora AL contiene el valor decimal '12'

    jmp last

last:
    ; Salida
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall
