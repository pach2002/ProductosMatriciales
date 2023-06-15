section .data
    matrix_rows equ 3
    matrix_cols equ 4

section .bss
    matrix resd matrix_rows * matrix_cols

section .text
    global _start
_start:
    ; Accessing matrix elements
    mov ecx, 0   ; Row index
row_loop:
    cmp ecx, matrix_rows
    jge exit_loop
    
    mov edx, 0   ; Column index
col_loop:
    cmp edx, matrix_cols
    jge next_row
    
    ; Calculate the offset for the current element
    mov eax, ecx
    imul eax, matrix_cols
    add eax, edx
    imul eax, 4   ; Multiply by 4 to get the byte offset (assuming a 32-bit integer)

    ; Access matrix element at [ecx][edx]
    mov ebx, [matrix + eax]
    
    ; Perform operations on the element if needed
    ; ...

    inc edx
    jmp col_loop

next_row:
    inc ecx
    jmp row_loop

exit_loop:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
