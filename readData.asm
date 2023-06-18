section .data
    LF equ 10 ; Line feed
    NULL equ 0 ; End of string
    STDIN equ 0 ; Standard input
    STDOUT equ 1 ; Standard output
    STDERR equ 2 ; Standard error

    SYS_read equ 0 ; Read
    SYS_write equ 1 ; Write
    SYS_open equ 2 ; File open
    SYS_close equ 3 ; File close
    SYS_creat equ 85 ; File open/create

    O_RONLY equ 000000q ; Read only

    newline db LF,NULL
    fileName db "MatrizCreada.txt",NULL
    fileDesc dq 0 ; File descriptor variable

    Onepos db 0
    Twopos db 0
    tamanio db 0

    value_x1 db 0
    value_y1 db 0
    value_x2 db 0
    value_y2 db 0

section .bss
    matrix resb 10000 ; Buffer to store the matrix
    matrixOrdered resb 10000   ; Buffer to order the matrix

section .text
    global readData
    readData:

        call readCoordinates

    ret
    
    ;jmp last

    ;last:
    ;Salir del programa
    ;mov rax, 60 ; Código de salida del programa
    ;xor rdi, rdi ; Valor de retorno 0
    ;syscall

    global readCoordinates
    readCoordinates:

    ; Abrir el archivo en modo de solo lectura
    mov rax, SYS_open
    mov rdi, fileName
    mov rsi, O_RONLY
    syscall

    mov qword [fileDesc], rax ; Guardar el descriptor del archivo

    ; Leer el contenido del archivo
    mov rax, SYS_read
    mov rdi, qword [fileDesc] ; Descriptor del archivo
    mov rsi, matrix ; Dirección de la matriz
    mov rdx, 10000 ; Tamaño máximo a leer
    syscall

    ; Cerrar el archivo
    mov rax, SYS_close
    mov rdi, qword [fileDesc]
    syscall

    ; Llamar la funcion para eliminar saltos de linea
    mov rdi, matrix
    mov rsi, matrixOrdered
    call mi_funcion

    ; Buscar x1y1
    mov rdi, matrixOrdered
    call encontrar_primer_49

    mov qword[Onepos], rsi 
    add rsi, 1              ; le añadimos uno, para que empiece en el siguiente byte

    ; Buscar x2y2

    mov rdi, matrixOrdered
    call encontrar_segundo_49

    mov qword[Twopos], rdx  ; ya contamos con los dos puntos

    ; Calcular los puntos de referencia (x1,y1,x2,y2)
    ; ¿Como hago eso?

    ; Recuperar el tamaño de la matriz

    mov rdi, matrixOrdered
    call count_and_sqrt

    ; dividir Onepos y Twopos por el tamanio
    ; lo que quede en rax son las filas y en rdx son las columnas

    ; pasar el valor por rdi, y cuando acabe la funcion, rax y rdx serán x1 y y1 respectivamente

    mov rsi, rax              ; este deberia ser un valor que se hace llegar por rax
    movsx rdi, byte [Onepos]  ; Extender el byte con signo a rdx
    call division_entera

    mov qword[value_x1], rdx
    mov qword[value_y1], rax

    ; Ahora a obtener el segundo punto 

    movsx rdi, byte [Twopos]  ; Extender el byte con signo a rdx
    call division_entera

    mov qword[value_x2], rdx
    mov qword[value_y2], rax

    ; mover valores a los registros usados
    ; Cargar el primer byte de value_x1 en rdi
    mov dl, byte [value_x1]
    mov rdi, rdx

    ; Cargar el primer byte de value_y1 en rsi
    mov dl, byte [value_y1]
    mov rsi, rdx

    ; Cargar el primer byte de value_x2 en rdx
    mov dl, byte [value_x2]
    mov rdx, rdx

    ; Cargar el primer byte de value_y2 en rcx
    mov dl, byte [value_y2]
    mov rcx, rdx

    ret


global mi_funcion
mi_funcion:
    xor ecx, ecx                ; Inicializar contador
    mov bl, 10                  ; Valor ASCII de salto de línea
    mov dl, 48                  ; Valor ASCII de '0'
    jmp loop_start

loop_start:
    cmp byte [rdi + rcx], 0     ; Comprobar si se alcanzó el final del primer espacio
    je loop_end

    mov al, byte [rdi + rcx]    ; Copiar el valor actual al registro al
    cmp al, bl                  ; Comparar con el valor de salto de línea
    je loop_next

    mov byte [rsi], al          ; Copiar el valor actual al segundo espacio
    inc rsi                     ; Incrementar la dirección del segundo espacio
    inc rcx                     ; Incrementar el contador
    jmp loop_start

loop_next:
    inc rcx                     ; Incrementar el contador sin copiar el valor actual
    jmp loop_start

loop_end:
    mov byte [rsi], 0           ; Colocar un byte nulo al final del segundo espacio
    ret

; Función 2


    global encontrar_primer_49
encontrar_primer_49:
    push rbp
    mov rbp, rsp

    xor rax, rax   ; Contador de bytes
    xor rsi, rsi   ; Número de bytes del primer '49' encontrado

inicio_bucle:
    mov dl, byte [rdi + rax]  ; Cargar byte actual
    cmp dl, 49                ; Comparar con '49'
    jne continuar_bucle       ; Saltar si no es '49'

    mov rsi, rax              ; Guardar número de bytes del primer '49' encontrado
    jmp fin_bucle             ; Saltar al final

continuar_bucle:
    inc rax                   ; Incrementar contador de bytes
    cmp byte [rdi + rax], 0   ; Comprobar si se llegó al final del espacio reservado
    jne inicio_bucle          ; Volver al inicio del bucle si no se llegó al final

fin_bucle:
    pop rbp
    ret

; FUNCION 2

section .text
    global encontrar_segundo_49

encontrar_segundo_49:
    push rbp
    mov rbp, rsp

    mov rax, rsi   ; Usar el valor guardado en RSI como posición inicial
    xor rdx, rdx   ; Número de bytes del segundo '49' encontrado

inicio_bucle_2:
    mov dl, byte [rdi + rax]  ; Cargar byte actual
    cmp dl, 49                ; Comparar con '49'
    jne continuar_bucle_2       ; Saltar si no es '49'

    mov rdx, rax              ; Guardar número de bytes del segundo '49' encontrado
    jmp fin_bucle_2             ; Saltar al final

continuar_bucle_2:
    inc rax                   ; Incrementar contador de bytes
    cmp byte [rdi + rax], 0   ; Comprobar si se llegó al final del espacio reservado
    jne inicio_bucle_2          ; Volver al inicio del bucle si no se llegó al final

fin_bucle_2:
    pop rbp
    ret

; funcion division

global division_entera   ; Punto de entrada para la función
division_entera:
    push rbp                ; Guardamos el valor de rbp en la pila
    mov rbp, rsp            ; Establecemos rbp como el nuevo puntero base de pila

    mov rax, rdi            ; Movemos el dividendo (valor en rdi) a rax
    cqo                     ; Expandimos el signo de rax a rdx para la división

    idiv rsi                  ; Realizamos la división entre rax y el divisor (valor en rsi)

    mov rsp, rbp            ; Restauramos el puntero base de pila
    pop rbp                 ; Restauramos el valor de rbp desde la pila
    ret                     ; Retornamos de la función

;___________________________________________
; Función para saber el tamaño de la matriz

global count_and_sqrt
count_and_sqrt:
    push rbp
    mov rbp, rsp

    xor rax, rax   ; Inicializar contador a 0
    xor rbx, rbx   ; Inicializar índice a 0

count_loop:
    cmp qword [rdi + rbx], 0   ; Comparar si el valor es cero
    je end_count                 ; Saltar a end_count si el valor es cero

    inc rax                      ; Incrementar contador si el valor no es cero

    inc rbx                      ; Incrementar el índice
    cmp qword [rdi + rbx], 0   ; Comparar si hemos llegado al final del espacio reservado
    jne count_loop               ; Saltar a count_loop si no hemos terminado

end_count:
    mov rbx, rax                 ; Mover el contador a rbx
    xor rax, rax                 ; Reinicializar rax a 0

sqrt_loop:
    inc rax                      ; Incrementar rax para probar la raíz cuadrada siguiente
    cmp rax, rbx                 ; Comparar rax con el contador
    jg end_sqrt                  ; Saltar a end_sqrt si rax es mayor que el contador

    imul rdx, rdx                ; Limpiar rdx para almacenar el residuo
    mov rdx, rax                 ; Mover rax a rdx
    imul rdx, rdx                ; Calcular el cuadrado de rdx
    cmp rdx, rbx                 ; Comparar el cuadrado con el contador
    jle sqrt_loop                ; Saltar a sqrt_loop si el cuadrado es menor o igual

    dec rax                      ; Decrementar rax si el cuadrado es mayor que el contador
    jmp end_sqrt                 ; Saltar a end_sqrt

end_sqrt:
    pop rbp
    ret
