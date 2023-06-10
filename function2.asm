;The program defines and uses a function with 8 parameters.

;Yo mero alias el wey
;April 21,2023

;**************
;Some basic data declaratons
section .data

    ;----
    ;Define constants

    EXIT_SUCCESS    equ 0   ; successful operation
    SYS_exit        equ 60 ;call code for terminate
    
    ; Data declarations
    lst1 dd -3,1,2,4,5,7
    len1 dd 6
    min1 dd 0
    med11 dd 0
    med21 dd 0
    max1 dd 0
    sum1 dd 0
    ave1 dd 0

    lst2 dd -2,1,2,3,6,8,19
    len2 dd 7
    min2 dd 0
    med12 dd 0
    med22 dd 0
    max2 dd 0
    sum2 dd 0
    ave2 dd 0

    
;*****************
;Code Section
section .text
    global _start
    _start:
    ;---------------------------------
    ;   stats1(lst1, len1,min1,med11,med21,max2, sum2, ave2)
    push ave2           ; 8vo argument, add of ave1
    push sum2           ;7mo argument, add of sum1
    mov  r9,max2        ;6to argument, add of max1
    mov  r8,med22       ;5to argument. add of med21
    mov rcx,med21        ; 4to argument, addr of ave1
    mov rdx,min2        ; 3er argument, addr of sum1
    mov esi,dword[len2] ; 2do argument, value of len1
    mov rdi,lst2        ; 1er argument, addr of lst1
    call stats2

    ;---------------------------------
    ;   stats1(lst2, len2,min2,med21,med22,max1, sum1, ave1)
    push ave1           ; 8vo argument, add of ave1
    push sum1           ;7mo argument, add of sum1
    mov  r9,max1        ;6to argument, add of max1
    mov  r8,med21       ;5to argument. add of med21
    mov rcx,med11        ; 4to argument, addr of ave1
    mov rdx,min1        ; 3er argument, addr of sum1
    mov esi,dword[len1] ; 2do argument, value of len1
    mov rdi,lst1        ; 1er argument, addr of lst1
    call stats2


    
    last:
        mov rax, SYS_exit ; Call code for exit
        mov rdi, EXIT_SUCCESS ; Exit program with success
        syscall



;Example function to find and return
;the sum and average of an vector

;call:
;   stats1(arr, len, min, med1,med2,max,sum, average)
;---- Arguments -------
;   arr, address -> rdi
;   len, dword value -> esi
;   min, address -->rdx
;   med1, address -->rcx
;   med2, address -->r8
;   max, address -->r9
;   sum, address -> stack
;average, address -> stack

global stats2
stats2:
    push rbp ; prologue
    mov rbp,rsp
    push r12 ; calle saved

    ; ----- Get min and max 
    mov eax,dword[rdi]  ; get min
    mov dword[rdx],eax  ; return min

    mov r12, rsi   ;get len of arre
    dec r12
    mov eax,dword[rdi+r12*4];get max
    mov dword[r9],eax

    ; ---- Get medians

    mov rax, rsi
    mov rdx,0
    mov r12,2
    div r12    ;rax=len/2

    cmp rdx,0  ;even/odd len?
    je evenLen
    mov r12d,dword[rdi+ rax*4] ; get arr[len/2]
    mov dword[rcx],r12d        ;return med1
    mov dword[r8],r12d         ;return med2
    jmp averageCal

    evenLen:
    mov r12d,dword[rdi+ rax*4] ; get arr[len/2]
    mov dword[rcx],r12d        ;return med1
    dec rax
    mov r12d,dword[rdi+ rax*4] ; get arr[(len/2)-1]
    mov dword[r8],r12d         ;return med2


    averageCal:
        ;----- Calculate sum
        mov r12,0 ; counter- index
        mov rax,0 ; contain the result of sum loop
    
        sumCicle:
            add eax, dword[rdi+r12*4] ; eax += arr[i]
            inc r12
            cmp r12,rsi ; if (r12<rsi)
            jl sumCicle ;then jump sumCicle
    
        mov  r12,qword[rbp+16] ; get sum address
        mov dword[r12],eax     ;return sum
        
        ;----Calcuate average
        cdq
        idiv rsi ; calculate the average -> sum/len
        mov  r12,qword[rbp+24] ; get sum address
        mov dword[r12],eax     ;return average

    pop r12 ;epilogue -> calle restore value
    pop rbp     ;calle restore value
     
    ret
