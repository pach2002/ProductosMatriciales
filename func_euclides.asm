
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

    mensaje db "La Distancia Eucliadana es la Raiz de: ", 0 ; mensaje inicial
    valorRDX db 0 ; espacio para almacenar el valor de rdx como cadena de caracteres
    LF_DB db LF, 0 ; salto de línea y carácter nulo

section .text
global _start
    _start:

    mov rdi, 2 ;x1
    mov rsi, 5 ;y1
    mov rdx, 10 ;x2
    mov rcx, 8 ;y2

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
    mov rdi, mensaje
    mov rsi, valorRDX
    call appendString

    ; Añadir salto de línea al mensaje
    mov rdi, mensaje
    mov rsi, LF_DB
    call appendString

    mov rdi, mensaje
    call printString       ; If it was correct, print it
    jmp last               ; end code

    last:
    ; Exit
        mov rax, SYS_EXIT
        mov rdi, EXIT_SUCCESS
        syscall
;_______________________________________________________________________
; Function to Calculate Euclidean Distance (Before Final Square Root)
; input: euclidean (X1, Y1, X2, Y2) using rdi, rsi, rdx, rcx
; output: RDX WITH FINAL VALUE
global EuclideanDistance
EuclideanDistance:
    ; Epilogue
    push rbx

    ;sub X1 to X2
    sub rdx, rdi

    ;sub rsi to rcx
    sub rcx, rsi

    ;_____________________________
    ; Square of both (rdx and rcx)
    xor rax, rax ; clean rax register

    mov rax, rdx    ; mov rdx content to rax
    mul rdx         ; apply square in rax
    mov rbx, rax    ; rbx is now a square
    ; using rbx to store temporally square because rdx
    ; is used on multiplication instruction
    ; if i use it, i will lost the value

    ;_______ repeat with rcx
    xor rax, rax

    mov rax, rcx
    mul rcx
    mov rcx, rax    ; we have two squares

    jmp next

    next:
    ;_______ add rdx to rcx [(x2-x1)2 + (y2-y1)2]
    add rbx, rcx    
    mov rdx, rbx ; rdx is the final value
    jmp endProcess  ; prepare for the next func

    ; ------------------------
    ; Prologue
    endProcess:
        pop rbx
        ret
    ; ++++++++++++++++++++++++

;___________________________________________________________
; Function to print a standar output
; input: rdi - value to display
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
;_____________