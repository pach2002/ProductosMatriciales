; if it is 1 move to tag create
    cmp rax, 1
    je create

    ; if it is 2 move to tag read
    cmp rax, 2
    je read

    ; if it is 3 move to euclidean tag
    cmp rax, 3
    je euclidean

    ; if it is 4 move to manhattan tag
    cmp rax, 4
    je manhattan

    ; if it is 5 move to chebyshev tag
    cmp rax, 5
    je chebyshev

    ; if it is 6 move to exit tag
    cmp rax, 6
    je exit

   ; option 1
create:
    mov rdi, createMessage  ; print create option
    call printString
    jmp last

; option 2
read:
    mov rdi, readMessage    ; print read option
    call printString
    jmp last

; option 3
euclidean:
    mov rdi, euclideanMessage ; print option message
    call printString
    jmp last

; option 4
manhattan:
    mov rdi, manhattanMessage ; print option message
    call printString
    jmp last

; option 5
chebyshev:
    mov rdi, chebyshevMessage ; print option message
    call printString
    jmp last

; option 6
exit:
    mov rdi, exitMessage ; print exit message
    call printString