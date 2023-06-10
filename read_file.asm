; --------------------------------
; Create a function to read a file and print it

; rdi is register to bring message to print
section .data

;----------
;Definicion de constantes
    EXIT_SUCCESS equ 0 ;successful operation
    SYS_EXIT  equ 60 ;call code for terminate

    ; --------
    LF equ 10 ; Line feed
    NULL equ 0 ; End of String
    TRUE equ 1
    FALSE equ 0

    STDIN equ 0 ; Standard input
    STDOUT equ 1 ; Standard out
    STDERR equ 2 ; Standard error

    SYS_read equ 0 ; Read
    SYS_write equ 1 ; Write
    SYS_open equ 2 ; Open File
    SYS_close equ 3 ; Close File
    SYS_fork equ 57 ; Fork
    SYS_creat equ 85 ; Open/Create File
    SYS_time equ 201 ; Get Time

    O_CREATE equ 0x40
    O_TRUNC equ 0x200
    O_APPEND equ 0x400

    O_READONLY equ 000000q ; Only read
    O_WRITEONLY equ 000001q ; Only write
    O_READWRITE equ 000002q ; Read & Write

    S_IRUSR equ 00400q ; Allows read to users
    S_IWUSR equ 00200q ; Allows write to users
    S_IXUSR equ 00100q ; Allows exec to users

    ; --------
    ; Name for file and content
    newline  db LF, NULL
    Header db LF, "Intentamos leer la matriz", LF, LF, NULL
    Filename db "matriz.txt", NULL
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
    ; Try to Open file using system service
    OpenInputFile:


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