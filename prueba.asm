section .data

;Define constantes
EXIT_SUCCES 	equ 0  ;Succeful operation
SYS_exit	    equ 60 ;call code for terminate

;*************************
;extern generateMatrix
extern manhatan
;Code Section
section .text
	global _start
	_start:
    ;---------------------------
    ;stats2(x1, y1, x2, y2, n)
    ; mov r8, 11        ;5to argument, add of med21
    mov rcx, 8       ;4to argument, addr of med11
    mov rdx, 8         ;3er argument, addr of min1
    mov rsi, 3  ;2do argument, value of len1
    mov rdi, 3        ;1er argument, addr of lst1

    ;call generateMatrix
    call manhatan

    last:
	mov rax, SYS_exit ;Call code for exit
	mov rdi, EXIT_SUCCES ;Exit program with succes
	syscall