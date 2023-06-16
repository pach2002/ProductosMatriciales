; Funcion para poder leer la matriz del archivo e imprimirla en pantalla

;******************************
;Some basic data declaration
section .data
; ---------------------------
LF equ 10 ; Line feed
NULL equ 0 ;end of string
STDIN equ 0 ; Standar input
STDOUT equ 1 ;Standar output
STDERR equ 2 ;standar error

SYS_read equ 0 ; read
SYS_write equ 1 ; write
SYS_open equ 2 ; file open
SYS_close equ 3 ; file close
SYS_creat equ 85 ; file open/create

O_RONLY equ 000000q ;Read only

;-----------------------------------
;Define some strings
newline db LF,NULL
fileName db "MatrizGenerada.txt",NULL
fileDesc dq 0 ;Como la descripcion del archivo. Como la variable donde se guarda el archivo

section .bss
matrix resb 10000  ; Buffer que guardara la matriz leida
;-----------
; CODE SECTION
section .text
    global readMatrix
    readMatrix:
        ; Abrir el archivo en modo de solo lectura
        mov rax, SYS_open
        mov rdi, fileName
        mov rsi, O_RONLY
        syscall

        mov qword [fileDesc], rax   ; Guardar el descriptor del archivo

        ; Leer el contenido del archivo
        mov rax, SYS_read
        mov rdi, qword [fileDesc]   ; Descriptor del archivo
        mov rsi, matrix             ; Dirección de la matriz
        mov rdx, 10000        ; Tamaño máximo a leer
        syscall

        mov rdx, rax

        ; Imprimir el contenido en pantalla
        mov rax, SYS_write
        mov rdi, STDOUT             ; STDOUT (pantalla)
        mov rsi, matrix             ; Dirección de la matriz
        syscall

        ; Cerrar el archivo
        mov rax, SYS_close
        mov rdi, qword [fileDesc]
        syscall

        ret