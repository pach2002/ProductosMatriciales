; Assembly test

;By Jellcaps

;14/Feb/2023

;Operaciones de entrada y salida. Abrir o crear un archivo

section .data

;----------
;Definicion de constantes
    EXIT_SUCCESS equ 0 ;successful operation
    SYS_EXIT  equ 60 ;call code for terminate

    ; --------
    LF equ 10 ; Line feed
    NULL equ 0 ; Llamar fin de STring
    TRUE equ 1
    FALSE equ 0

    STDIN equ 0 ; Standard input
    STDOUT equ 1 ; Standard out
    STDERR equ 2 ; Standard error

    SYS_read equ 0 ; Lectura
    SYS_write equ 1 ; Escritura
    SYS_open equ 2 ; Abrir archivo
    SYS_close equ 3 ; Cerrar archivo
    SYS_fork equ 57 ; Fork
    SYS_creat equ 85 ; Abrir archivo / Crear archivo
    SYS_time equ 201 ; Obtener el tiempo de la PC

    O_CREATE equ 0x40
    O_TRUNC equ 0x200
    O_APPEND equ 0x400

    O_READONLY equ 000000q ; Solo lectura
    O_WRITEONLY equ 000001q ; Solo escritura
    O_READWRITE equ 000002q ; Lectura y Escritura

    S_IRUSR equ 00400q ; Permiso de lectura
    S_IWUSR equ 00200q ; Permiso de escritura
    S_IXUSR equ 00100q ; Permiso de ejecucion

    ; --------
    ; Definir algunos Strings
    newline  db LF, NULL
    Header db LF, "Ejemplo de archivo de escritura", LF, LF, NULL
    Filename db "PruebaWrite.txt", NULL
    WWWAD db "https://www.google.com"
            db LF, LF, NULL
    Len dq $-WWWAD - 1
    fileDesc db 0

    WriteDone db "Escritura completada", LF, NULL
    ErrorMSG db "Error al abrir el archivo", LF, NULL
    ErrorMSG1 db "Error al escribir el archivo", LF, NULL
    Exito db "Si se pudo", LF, NULL

;Code Section (Texto)
section .text
    global _start
    _start:

    ; ------------
    mov rdi, Header
    call printString

    ; --------------
    ; Intentar abrir el archivo usando System Service para abrir el archivo
    OpenInputFile:
        mov rax, SYS_creat ; Abre o crea archivo
        mov rdi, Filename
        mov rsi, S_IRUSR | S_IWUSR | S_IXUSR
        syscall

        cmp ax, 0
        jl ErrorOpen

        mov qword [fileDesc], rax
        mov rdi, Exito
        call printString
        
        ;-------------------------
        ;Escribir al archivo
        ;En este ejemplo, los caracteres a escribir, estaran predefinidos en el string
        ;System Service -write
        ;Return;
        ;if error -> rax < 0
        ;if success -> rax = count of characters actually
        mov rax, SYS_write
        mov rdi, qword[fileDesc]
        mov rsi, WWWAD
        mov rdx, qword[Len]
        syscall
        
        cmp rax, 0


        jl ErrorWrite

        mov rdi, WriteDone
        call printString
        ;--------------------------
        ;Cierre del archivo
        ;System Service -close
        mov rax, SYS_close
        mov rdi, qword [fileDesc]
        syscall


        jmp last

    ErrorOpen:
        mov rdi, ErrorMSG
        call printString
        jmp last

    ErrorWrite:
        mov rdi, ErrorMSG1
        call printString
        jmp last

;Fin del programa
last:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

    ; ++++++++++++++++++++++++
    ; Funcion geneica para mostrar un String en pantalla
    ; El String debe de terminar en un NULO
    ; 
global printString
printString:
    ; Epilogo
    push rbx

    ; Conteo de caracteres en String
    mov rbx, rdi
    mov rdx, 0
    countStrLoop:
        cmp byte [rbx], NULL
        je countStrDone
        inc rdx
        inc rbx
        jmp countStrLoop

    countStrDone:
        cmp rdx, 0
        je prtDone
    ; ------------------------
    ; Llamar al sistema operativo para que imprima la cadena
    mov rax, SYS_write ; Codigo del sistema para escribir
    mov rsi, rdi ; Direccion de los caracteres a escribir
    mov rdi, STDOUT ; Standard out

    syscall

    ; ------------------------
    ; Imprimir String y regresar a la llamada rutina (Prologo)
    prtDone:
        pop rbx
        ret
    ; ++++++++++++++++++++++++