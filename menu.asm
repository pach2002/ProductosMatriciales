; Print Menu
; This menu contains 5 options to choose
; [1] create matrix
; [2] read matrix 
; [3] calculate euclidean distance
; [4] calculate manhattan distance
; [5] calculate chebyshev distance
; [6] exit 

section .data

;_______________________________
; extern functions
extern euclides  ; euclides function
extern manhatan  ; manhatan function
extern chebyshov ; chebyshov function
extern generateMatrix ; generateMatrix function
extern readMatrix     ; readMatrix function

; ______________________________
;Definition of constant values

    EXIT_SUCCESS equ 0 ;successful operation
    SYS_EXIT  equ 60 ;call code for terminate

    ; --------
    LF equ 10 ; Line feed
    NULL equ 0 ; Llamar fin de STring

    STDIN equ 0 ; Standard input
    STDOUT equ 1 ; Standard out
    STDERR equ 2 ; Standard error

    SYS_read equ 0 ; Read
    SYS_write equ 1 ; Write

    O_CREATE equ 0x40
    O_TRUNC equ 0x200
    O_APPEND equ 0x400

    O_READONLY equ 000000q ; Only read
    O_WRITEONLY equ 000001q ; Only Write
    O_READWRITE equ 000002q ; Read & Write

    S_IRUSR equ 00400q ; Allowed to read
    S_IWUSR equ 00200q ; Allowed to write
    S_IXUSR equ 00100q ; Allowed to execute

; _____________________________________________

; Definition of input variables

    input_x1 db 0
    input_y1 db 0
    input_x2 db 0
    input_y2 db 0
    input_size db 0
    input_option db 0

; ____________________________________________

; Definition of messages and utilities

exitMessage db " you choose exit program, bye!", LF, NULL
errorMessage db "create or read a matrix before pls", LF, NULL
chebyshevMessage db "you choose chebyshev distance", LF, NULL
manhattanMessage db "you choose manhattan distance", LF, NULL
euclideanMessage db "you choose euclidean distance", LF, NULL
createMessage db "you choose create your own Matrix", LF, NULL
readMessage db "you choose read a Matrix from a file", LF, NULL
invalidMessage db "INVALID DATA, TRY AGAIN", LF, NULL
notZeroMessage db "ERROR: NOT ZERO ALLOWED", LF, NULL
notDataMessage db "Introduce data to calculate distance", LF, NULL

; messages to values for 1st option
sizeMessage db "insert size of new matrix", LF, NULL
coordinatesMessage db "insert coordinates in order", LF, NULL
x1Message db "X1:", LF, NULL
y1Message db "Y1:", LF, NULL
x2Message db "X2:", LF, NULL
y2Message db "Y2:", LF, NULL
; ADD MORE ...

menuOptions db "[1] create matrix", LF, NULL
           db "[2] read matrix", LF, NULL
           db "[3] calculate euclidean distance", LF, NULL
           db "[4] calculate manhattan distance", LF, NULL
           db "[5] calculate chebyshev distance", LF, NULL
           db "[6] exit", LF, NULL

menuSize equ $ - menuOptions   ; Calculate the length of menuOptions


;Code Section
section .text
    global _start
    _start:

    ; print menu NOT using function
    mov rax, SYS_write   ; System call number for write
    mov rdi, STDOUT      ; Standard output file descriptor
    mov rsi, menuOptions ; Address of the menuOptions string
    mov rdx, menuSize    ; Length of the menuOptions string
    syscall

    mov rdi, input_option   ; move address variable for keyboard input
    call inputValue         ; call function to Input Value

    ; and now, mov to rax to compare (saved like ASCIII)
    movzx rax, byte[input_option]

    ; if it is 1 move to tag create
    cmp rax, 49
    je create

    ; if it is 2 move to tag read
    cmp rax, 50
    je read

    ; if it is 3 move to euclidean tag
    cmp rax, 51
    je euclidean

    ; if it is 4 move to manhattan tag
    cmp rax, 52
    je manhattan

    ; if it is 5 move to chebyshev tag
    cmp rax, 53
    je chebyshev

    ; if it is 6 move to exit tag
    cmp rax, 54
    je exit

    ; if it is another option, mov to invalid tag
    cmp rax, 54
    jg invalidData

    ; if it is 0, not allow insert 0.
    cmp rax, 48
    je notZero

    ;________________________________________
    ; if you choose create a new matrix:
    ; input a) size of matrix (r8 register)
    ;       b) coordinates 1st position (x1, y1) (rdi, rsi)
    ;       c) coordinates 2nd position (x2, y2) (rdx, rcx)

    insertValues:
        ; insert size
        mov rdi, sizeMessage ; message to insert size
        call printString

        mov rdi, input_size  ; insert size of matrix
        call inputValue

        ; el valor recibido dentro de la variable si entra como se solicita
        ; si le mandamos un 10, se guarda 49 y 48 (1 y 0 en ASCII)
        ; ¿Como convertimos ese 1 y 0 en decimal?

        ; convert ASCII value to integer
        sub byte [input_size], '0'

        ; before move data, compare if it isn't 0, cause you cannot create a new matrix with 0 size
        cmp byte[input_size], 0
        je notZero                 ; if equals 0, display error

        movzx r8, byte[input_size] ; Store value in registers to next functions (r8 for size)

        ; insert coordinates
        mov rdi, coordinatesMessage ; message to request coordinates
        call printString

            ; x1
            mov rdi, x1Message      ; message to request x1
            call printString

            mov rdi, input_x1
            call inputValue

            ; y1
            mov rdi, y1Message      ; message to request y1
            call printString

            mov rdi, input_y1 
            call inputValue

            ; x2 
            mov rdi, x2Message       ; message to request x2
            call printString

            mov rdi, input_x2
            call inputValue

            ; y2
            mov rdi, y2Message      ; message to request y2
            call printString

            mov rdi, input_y2
            call inputValue


            ;___ convert ASCII values to integer
            sub byte [input_x1], '0'
            sub byte [input_y1], '0'
            sub byte [input_x2], '0'
            sub byte [input_y2], '0'

            ;___ Store values in registers to next functions
            ;___ (rdi, rsi) (rdx, rcx) and jump to another function

            movzx rdi, byte[input_x1]
            movzx rsi, byte[input_y1]
            movzx rdx, byte[input_x2]
            movzx rcx, byte[input_y2]

            ; STORE REGISTERS (COORDINATES) IN STACK
            push rdi
            push rsi
            push rdx
            push rcx

            ; now, values in registers are available to create matrix
            call generateMatrix
            
            jmp _start   ; print menu again


; option 1
create:
    mov rdi, createMessage  ; print create option
    call printString
    jmp insertValues        ; mov to tag insertValues

; option 2
read:
    mov rdi, readMessage    ; print read option
    call printString
    
    call readMatrix         ; read file "MatrizGenerada.txt"

    jmp _start

    ;_____________________________________________________________
    ; if user choose a calculus, check if coordinates exist
    ; if x1 != 0 : ir al calculo
    ; else : imprimir el menú

; option 3
euclidean:

    mov rdi, euclideanMessage ; print option message
    call printString

    ; CLEAN REGISTER
    ;xor rax, rax
    ;xor rbx, rbx

    ; RESTORE VALUES
    pop rcx
    pop rdx
    pop rsi
    pop rdi

    call euclides              ; call extern function

    movzx rdi, byte[input_x1]
    movzx rsi, byte[input_y1]
    movzx rdx, byte[input_x2]
    movzx rcx, byte[input_y2]

    ; STORE REGISTERS (COORDINATES) IN STACK
    push rdi
    push rsi
    push rdx
    push rcx

    jmp _start                 ; return to menu

; option 4
manhattan:

    mov rdi, manhattanMessage ; print option message
    call printString

    ; CLEAN REGISTER
    ;xor rax, rax
    ;xor rbx, rbx

    ; RESTORE VALUES
    pop rcx
    pop rdx
    pop rsi
    pop rdi

    call manhatan              ; call extern function

    movzx rdi, byte[input_x1]
    movzx rsi, byte[input_y1]
    movzx rdx, byte[input_x2]
    movzx rcx, byte[input_y2]

    ; STORE REGISTERS (COORDINATES) IN STACK
    push rdi
    push rsi
    push rdx
    push rcx

    jmp _start                 ; return to menu


; option 5
chebyshev:
    
    mov rdi, chebyshevMessage ; print option message
    call printString

    ; CLEAN REGISTER
    ; xor rax, rax
    ; xor rbx, rbx

    ; RESTORE VALUES
    pop rcx
    pop rdx
    pop rsi
    pop rdi

    jmp next

    next:
    call chebyshov              ; call extern function

    jmp next1

    next1:
    movzx rdi, byte[input_x1]
    movzx rsi, byte[input_y1]
    movzx rdx, byte[input_x2]
    movzx rcx, byte[input_y2]

    ; STORE REGISTERS (COORDINATES) IN STACK
    push rdi
    push rsi
    push rdx
    push rcx

    jmp _start                 ; return to menu


; option 6
exit:
    mov rdi, exitMessage ; print exit message
    call printString
    jmp last

invalidData:
    mov rdi, invalidMessage ; print "invalid data" message
    call printString
    jmp _start              ; start again, printing menu

notZero:
    mov rdi, notZeroMessage ; print error if value is 0
    call printString
    jmp last

notData:
    mov rdi, notDataMessage  ; print if program don´t have coordinates
    call printString
    jmp _start               ; return to menu

last:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

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

;___________________________________________________________
; Function to READ a standar INPUT (3 BYTE MAX INPUT)
; (2 BYTES FOR VALUES AND 1 BYTE FOR END LINE)
; input: rdi - address to store characters
global inputValue
inputValue:
    ; Epilogue
    push rbx

    ; System call to read a byte
    mov rax, SYS_read       ; System call number for read
    mov rsi, rdi            ; Memory address to store the first input value
    mov rdi, STDIN          ; File descriptor for standard input
    mov rdx, 3              ; Maximum number of bytes to read
    syscall

    ;; Debe haber alguna forma de leer el tamaño de bytes a insertar


    jmp readDone

    ; ------------------------
    ; Imprimir String y regresar a la llamada rutina (Prologo)
    readDone:
        pop rbx
        ret
    ; ++++++++++++++++++++++++