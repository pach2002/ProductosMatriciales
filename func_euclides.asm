; Function
; calculate euclidean distance
; euclidean (X1, Y1, X2, Y2)
; using rdi, rsi, rdx, rcx at the same order

section .data

; Declare constants
    EXIT_SUCCESS   equ 0 ; succesful operation
    SYS_EXIT       equ 60 ; end

; utilities for functions
; -------
    LF equ 10 ; Line feed
    NULL equ 0 ; End of String

    STDIN equ 0 ; Standard input
    STDOUT equ 1 ; Standard out
    STDERR equ 2 ; Standard error

    SYS_read equ 0 ; Read
    SYS_write equ 1 ; Write
    SYS_close equ 3 ; Close File
    SYS_creat equ 85 ; Open/Create File

section .text
global _start
    _start:

    mov rdi, 3 ;x1
    mov rsi, 3 ;y1
    mov rdx, 3 ;x2
    mov rcx, 5 ;y2

    call EuclideanDistance ; Call function
    call printString       ; If it was correct, print it
    jmp last               ; end code

    last:
    ; Exit
        mov rax, SYS_EXIT
        mov rdi, EXIT_SUCCESS
        syscall

; Function
global EuclideanDistance
EuclideanDistance:
    ; Epilogue
    push rbx

    ; euclidean (X1, Y1, X2, Y2)
    ; using rdi, rsi, rdx, rcx

    ;sub X1 to X2
    sub rdx, rdi

    ;sub rsi to rcx
    sub rcx, rsi

    ;______________________________
    ; Square of both (rdx and rcx)
    xor rax, rax ; clean rax register

    mov rax, rdx    ; mov rdx content to rax
    mul rdx         ; apply square in rax
    xor rdx, rdx    ; clean rdx
    mov rdx, rax    ; rdx is now a square

    ;_______ repeat with rcx
    xor rax, rax

    mov rax, rcx
    mul rcx
    xor rcx, rcx
    mov rcx, rax    ; we have two squares

    ;______ add rdx to rcx
    add rdx, rcx
    jmp Next

    Next:
    ; get square root from rdx
    xor rax, rax    ; clean register
    
    mov rax, rdx    ; move final value into rax
    div rdx         ; divide value by him
    ; TODO: EL ERROR ESTÁ AQUI, ¿COMO SACAS CORRECTAMENTE UNA RAIZ CUADRADA?
    mov rdi, rax    ; move euclidean distance into rdi to print it
    jmp endProcess

    ; ------------------------
    ; Prologue
    endProcess:
        pop rbx
        ret
    ; ++++++++++++++++++++++++

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