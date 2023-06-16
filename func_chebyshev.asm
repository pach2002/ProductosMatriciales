; |3-10|+|6-5|
; 7+1
; 8
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

    message db "La Distancia Chebyshev es de: ", 0 ; init message
    RDXvalue db 0 ; storage for rdx value like a string
    LF_DB db LF, 0 ; end of line and null

section .text
global chebyshov
    chebyshov:

    call ChebyshevDistance ; Call function

    ; Convert rdx value in chars
    mov rax, rdx
    mov rbx, 10 ; decimal
    xor rcx, rcx ; counter
    convertLoop:
        xor rdx, rdx
        div rbx
        add dl, '0' ; turns to ASCII
        dec rcx
        mov byte [RDXvalue + rcx], dl ; Store value in variable
        test rax, rax
        jnz convertLoop

    ; Add rdx value in message
    mov rdi, message
    mov rsi, RDXvalue
    call appendStringC

    ; add End Line to message
    ; mov rdi, message
    ; mov rsi, LF_DB
    ; call appendString

    mov rdi, message
    call printStringC       ; If it was correct, print it

    mov rdi, LF_DB         ; print END OF THE LINE
    call printStringC
    
    ;jmp last               ; end code

    ; last:
    ; Exit
        ;mov rax, SYS_EXIT
        ;mov rdi, EXIT_SUCCESS
        ;syscall
;_______________________________________________________________________
; Function to Calculate Manhattan Distance
; input:  Chebyshev (X1, Y1, X2, Y2) using rdi, rsi, rdx, rcx
; output: RDX WITH FINAL VALUE
global ChebyshevDistance
ChebyshevDistance:
    ; Epilogue
    push rbx

    ; x1 - x2
    sub rdi, rdx

    ; y1 - y2
    sub rsi, rcx

    ;___________________
    ; if value in x is negative, get the absolute value |x1-x2|
    NegativeX:
    neg rdi
    jmp IsAbsolute

    ; if value in y is negative, get the absolute value |y1-y2|
    NegativeY:
    neg rsi
    jmp IsAbsolute
   

    IsAbsolute:
    ; if (rdi < 0) mov to another tag
    ; if (rsi < 0) mov to anotthe tag too
    cmp rdi, 0
    jl NegativeX

    cmp rsi, 0
    jl NegativeY

    ;___ If values are positive now, continue

    ; Compare two values and what are the highest
    ; MAX (|x1-x2|, |y1-y2|)

    cmp rdi, rsi    ; if rdi >= rsi
    jge MaxX 

    cmp rdi, rsi    ; if rdi <= rsi
    jle MaxY

    ; ------------------------
    ; Prologue
    endProcess:
        pop rbx
        ret

    MaxX:
        mov rdx, rdi    ; mov rdi to rdx, cause X is the highest
        jmp endProcess  ; end program

    MaxY:
        mov rdx, rsi    ; mov rsi to rdx, cause Y is the highest
        jmp endProcess  ; end program
    ; ++++++++++++++++++++++++

;___________________________________________________________
; Function to print a standar output
; input: rdi - value to display
global printStringC
printStringC:
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
global appendStringC
appendStringC:
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