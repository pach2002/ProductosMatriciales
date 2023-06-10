section .data

; Declare constants
    EXIT_SUCCESS   equ 0 ; successful operation
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

section .data
    mensaje db "El valor de rdx es: ", 0 ; mensaje inicial
    valorRDX db 0 ; espacio para almacenar el valor de rdx como cadena de caracteres
    LF_DB db LF, 0 ; salto de línea y carácter nulo

section .text
global _start
    _start:

    mov rdi, 3 ;x1
    mov rsi, 3 ;y1
    mov rdx, 3 ;x2
    mov rcx, 5 ;y2

    call EuclideanDistance ; Call function

    ; Convertir el valor de rdx a cadena de caracteres
    mov rax, rdx
    mov rbx, 10 ; base decimal
    xor rcx, rcx ; contador de dígitos
    convertLoop:
        xor rdx, rdx
        div rbx
        add dl, '0' ; convertir dígito a ASCII
        dec rcx
        mov byte [valorRDX + rcx], dl ; almacenar dígito en valorRDX
        test rax, rax
        jnz convertLoop

    ; Añadir el valor de rdx al mensaje
    mov rdi, valorRDX
    call appendString

    ; Añadir salto de línea al mensaje
    mov rdi, LF_DB
    call appendString

    ; Llamar a printString para imprimir el mensaje
    mov rdi, mensaje
    call printString

    jmp last               ; end code

last:
    ; Exit
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

;___________________________________________________________
; Function to print a standard output
; input: rdi - value to display
global printString
printString:
    ; Epilogue
    push rbx

    ; Count characters in String
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
    ; Call operating system to print the string
    mov rax, SYS_write ; System code for write
    mov rsi, rdi ; Address of the characters to write
    mov rdi, STDOUT ; Standard out

    syscall

    ; ------------------------
    ; Print String and return to calling routine (Prologue)
    prtDone:
        pop rbx
        ret
;___________________________________________________________

; Function to Calculate Euclidean Distance (Before Final Square Root)
; input: euclidean (X1, Y1, X2, Y2) using rdi, rsi, rdx, rcx
; output:
global EuclideanDistance
EuclideanDistance:
    ; Epilogue
    push rbx

    ; sub X1 to X2
    sub rdx, rdi

    ; sub rsi to rcx
    sub rcx, rsi

    ; Square of both (rdx and rcx)
    xor rax, rax ; clean rax register

    mov rax, rdx    ; mov rdx content to rax
    mul rdx         ; apply square in rax
    xor rdx, rdx    ; clean rdx
    mov rdx, rax    ; rdx is now a square

    ; Repeat with rcx
    xor rax, rax

    mov rax, rcx
    mul rcx
    xor rcx, rcx

    ; ------------------------
    ; Prologue
    pop rbx
    ret
;___________________________________________________________

; Function to append a string to the end of another string
; input: rdi - destination string, rsi - source string
global appendString
appendString:
    ; Epilogue
    push rbx

    ; Find the end of the destination string
    mov rbx, rdi
    mov rdx, 0
    findEndLoop:
        cmp byte [rbx], NULL
        je findEndDone
        inc rdx
        inc rbx
        jmp findEndLoop

    findEndDone:
        ; Copy the source string to the end of the destination string
        mov rcx, rsi
        mov rsi, rbx
        mov rbx, rdx
        copyLoop:
            mov dl, [rcx]
            mov [rsi], dl
            inc rcx
            inc rsi
            dec rbx
            jnz copyLoop

        ; Add a null terminator to the end of the concatenated string
        mov byte [rsi], NULL

    ; ------------------------
    ; Prologue
    pop rbx
    ret
;___________________________________________________________
