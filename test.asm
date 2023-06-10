section .data
    filename db "input.txt", 0
    buffer times 256 db 0 ; Buffer to store the file contents

section .text
    global _start
    _start:
        ; Open the file
        mov rax, 2 ; System call number for open
        mov rdi, filename ; Pointer to the filename
        mov rsi, 0 ; Flags (O_RDONLY)
        xor rdx, rdx ; Mode (not used for read-only)
        syscall

        test rax, rax ; Check if file opening was successful
        js file_error

        mov rdi, rax ; File descriptor

        ; Read the file contents
        mov rax, 0 ; System call number for read
        mov rsi, buffer ; Buffer address
        mov rdx, 256 ; Maximum number of bytes to read
        syscall

        ; Calculate the length of the file contents
        xor rcx, rcx ; Counter for the length
        mov rdi, buffer ; Start of the buffer
        mov al, byte [rdi] ; Load the first byte
    count_length:
        test al, al ; Check for null termination
        jz print_contents
        inc rcx ; Increment the counter
        inc rdi ; Move to the next byte
        mov al, byte [rdi] ; Load the next byte
        jmp count_length

    print_contents:
        ; Print the contents of the buffer
        mov rax, 1 ; System call number for write
        mov rdi, 1 ; File descriptor (stdout)
        mov rsi, buffer ; Buffer address
        mov rdx, rcx ; Number of bytes to write
        syscall

        ; Close the file
        mov rax, 3 ; System call number for close
        syscall

        ; Exit the program
        mov rax, 60 ; System call number for exit
        xor rdi, rdi ; Exit status (0)
        syscall

    file_error:
        ; Handle file opening error here
        ; ...
