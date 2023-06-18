section .data

;Define constantes
EXIT_SUCCES 	equ 0  ;Succeful operation
SYS_exit	    equ 60 ;call code for terminate

;*************************
;extern generateMatrix
extern readCoordinates
;Code Section
section .text
	global _start
	_start:

    call readCoordinates
    ;jmp last

    ;last:
	;mov rax, SYS_exit ;Call code for exit
	;mov rdi, EXIT_SUCCES ;Exit program with succes
	;syscall