; Julio Pech 25/03/2023

; Basic declaration

; Default

 ;; MACRO SPACE

    ; Calculate average from a list
    %macro average_list 1

        xor rax, rax      ; initial rax to storage average
        xor rcx, rcx      ; initial rcx to counter
        
        Addloop:                  
            mov rbx, qword[%1+rcx*8]    ; move value from lst into rbx 
            cmp rbx, 0                  ; if value in list is empty, jump to average
            je average
            ;; else !!!
            inc rcx                      ; increment counter by 1
            add rax, rbx                 ; add value from rbx to rax accumulated
            ; GO TO addloop
            jmp Addloop                  ; return to addloop to repeat process

        average:
            div rcx                      ; divide the amount of value by counter

    %endmacro

    ; MACRO REFURBISHED
    ; average <lst> <len> <ave> <max>
    %macro average 4

        xor eax, eax        ; initial eax to 0
        mov ecx, dword[%2]  ; length of list
        mov r12, 0          ; counter
        mov rbx, %1       ; move lst into rbx
        mov edx, dword[%4]       ; mov into rdx %4

        %%sumloop:
            add eax, dword[rbx+r12*4] ; mov value from lst into eax
            cmp dword[rbx+r12*4], edx  ; compare actual with max
            jg %%maxvalue             ; if actual is higher than max
                                      ; go to tag %%maxvalue                      
            inc r12                   ; increment r12
            loop %%sumloop

        %%maxvalue:
            mov %4, dword[rbx+r12*4] ; mov actual valye into max position
            inc r12
            jmp %%sumloop


        ; convierte el registro ax en 2
        cdq                           ; force to fusion eax and edx register
        idiv dword[%2]                ; div by 32 bits value
        mov dword[%3], eax            ;

            

    %endmacro

section .data

; Declare constants
    EXIT_SUCCESS   equ 0 ; succesful operation
    SYS_EXIT       equ 60 ; end

    ; variable declarations
    lst1 dd 4,5,2,3,2
    len1 dd 5
    ave1 dd 0
    max1 dd 0

    lst2 dd 2,6,3,-2,1,8,9
    len2 dd 7
    ave2 dd 0
    max2 dd 0

section .text

global _start
    _start:

    ; call macro
    average lst1, len1, ave1, max1

    average lst2, len2, ave2, max2

    last:
    ; Exit
        mov rax, SYS_EXIT
        mov rdi, EXIT_SUCCESS
        syscall

    