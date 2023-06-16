; Funcion para poder generar la matriz solicitada

;******************************
;Some basic data declaration

section .data
;-----
;Define constants (equ = equals)
EXIT_SUCESS equ 0   ;successful operation
SYS_exit equ 60  ;call code for terminate

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

;For files
O_CREAT equ 0x40

O_RONLY equ 000000q ;Read only
O_WRONLY equ 000001q ;Write only
O_RDWR equ 000002q ;read and write

S_IRUSR equ 00400q  ;Lectura
S_IWUSR equ 00200q  ;Escritura
S_IXUSR equ 00100q  ;Ejecucion

;-----------------------------------
;Define some strings
newline db LF,NULL
fileName db "MatrizGenerada.txt",NULL
fileDesc dq 0 ;Como la descripcion del archivo. Como la variable donde se guarda el archivo
writeDone db "Matrix successfully generated",LF,NULL
errMsgWrite db "Error generating matrix",LF,NULL

zero db '0',NULL ;El cero que imprimiremos
one db '1',NULL ;El 1 para los puntos

n dq 0
puntox1 dq 0
puntoy1 dq 0
puntox2 dq 0
puntoy2 dq 0

;-----------
; CODE SECTION
section .text
    global generateMatrix
    generateMatrix:
    ; Obtenemos los datos de la llamada de la funcion y lo almacenamos en
    ; variables precreadas
    mov qword[n], r8
    mov qword[puntox1], rdi
    mov qword[puntoy1],rsi
    mov qword[puntox2], rdx
    mov qword[puntoy2], rcx
    ;------------------------------
    ;Abrimos el archivo
    openInputFile:
        mov rax,SYS_creat ;File open/create
        mov rdi,fileName ;File name string
        mov rsi, S_IRUSR | S_IWUSR | S_IXUSR
        syscall

        mov qword[fileDesc],rax  ;Guardamos el descriptor del archivo
        
    ;Seccion para la generacion de matriz
    generar:
        ;-------------------------------------
        ; Codigo que nos ayudará con la impresion de la matriz

        ;Movemos las filas que tendra la matriz (n) a r10 para el bucle
        mov r10, 0
        mov r10, qword[n]
   
        mov r9, 0    ; Columnas de la matriz, verificamos que este limpio

        ;Bucle que imprime las filas
        bucle_filas:
        cmp r10,0 ;Comparamos que no se haya acabado las filas que debemos imprimir
        jl fin_filas ; En caso de que hayamos acabado ir al final de impresion de filas

        ;Movemos a r9 el valor de n, esto porque en cada fila debe empezar con n
        mov r9, qword[n]  
            ;Bucle para imprimir las columnas
            bucle_columnas:
            cmp r9,0 ;Comparamos que no se hayan escrito todas
            jl fin_columnas ;Si ya se acabo saltar al fin de columnas
                
            ;Al ir de reversa r9, se calculara la x para verificar los puntos
            ;Calculamos la posicion x actual, x = |r9-n|
            mov rax, r9  
            sub rax, qword[n]
            neg rax

            cmp rax, qword[puntox1]  ; Comparamos con x1
            je checar_y1    ; Si es igual, ir a verificar y1
            cmp rax, qword[puntox2] ; Comparamos con x2
            je checar_y2    ; Si es igual, ir a verificar y2
            jmp imprimirZero ; Si no coincide, imprimir 0 y pasar a la siguiente columna

            ;Al ir de reversa r10, se calculara la y para verificar los puntos           
            checar_y1:
            ;Calculamos la posicion y actual, y = |r10-n|
            mov rax, r10 
            sub rax, qword[n]
            neg rax

            cmp rax, qword[puntoy1]  ; Comparamos con y1
            je imprimirOne  ; Si es igual, imprimir 1
            jmp imprimirZero ; Si no coincide, imprimir 0 y pasar a la siguiente columna

            checar_y2:
            ;Calculamos la posicion y actual, y = |r10-n|
            mov rax, r10 
            sub rax, qword[n]
            neg rax
            
            cmp rax, qword[puntoy2] ; Comparamos con y2
            je imprimirOne  ; Si es igual, imprimir 1
            jmp imprimirZero ; Si no coincide, imprimir 0 y pasar a la siguiente columna


                imprimirZero:
                mov rax, SYS_write
                mov rdi, qword[fileDesc]  ; Descriptor de archivo
                mov rsi, zero  ; Puntero a '0'
                mov rdx, 1  ; Cuantos caracteres a escribir
                syscall

                jmp siguienteColumna

                imprimirOne:
                mov rax, SYS_write
                mov rdi, qword[fileDesc]  ; Descriptor de archivo
                mov rsi, one  ; Puntero a '0'
                mov rdx, 1  ; Cuantos caracteres a escribir
                syscall

                siguienteColumna:
                dec r9
                jmp bucle_columnas

            ;Fin de la impresion de columnas, es decir hay que imprimir un
            ;Salto de linea
            fin_columnas:
                mov rax, SYS_write
                mov rdi, qword[fileDesc]  ; Descriptor de archivo
                mov rsi, newline  ; Puntero a nueva línea
                mov rdx, 1  ; Tamaño a escribir (1 byte)
                syscall

                dec r10
                jmp bucle_filas

        ;Seccion para cuando no hayan mas filas por escribir
        fin_filas:        
            ;Para saber si lo escribio
            cmp rax,0
            jl errorWrite

            mov rdi, writeDone
            call printStringX

            ;----------------------
            ;Close the file
            ;System service -close
            mov rax, SYS_close
            mov rdi, qword[fileDesc]
            syscall

            jmp last

    ;Errores de write
        errorWrite:
            mov rdi, errMsgWrite 
            call printStringX
            jmp last


;***************************************************************
;Done, terminate function.
last:
    mov r8, qword[n]
    mov rdi, qword[puntox1]
    mov rsi, qword[puntoy1]
    mov rdx, qword[puntox2]
    mov rcx,  qword[puntoy2]
    ret

; ***************************************
; Generic function to display a string to the screen
; String must be NULL terminated

global printStringX

printStringX:
    ; epilogue
    push rbx

    ;Count characters in string
    mov rbx, rdi ; Guardamos la direccion de la cadena
    mov rdx, 0 ; contador

    countStrLoop:
        cmp byte[rbx],NULL
        je countStrDone

        inc rdx ;contador
        inc rbx ;aumentar uno a la direccion de inicio
        jmp countStrLoop

    countStrDone:
        cmp rdx,0
        je ptrDone

        ;Call OS to output string
        mov rax, SYS_write ;System code for write
        mov rsi, rdi ;Rdi tiene la direccion de la cadena
        mov rdi, STDOUT
        ;rdx ya tiene el valor del numero de caracteres

        syscall

    ;----------------
    ;String printed, return to calling routine ----prologue
    ptrDone:        
        pop rbx
        ret
