;
; A simple boot sector program that loops forever.
;


[org 0x7c00]


mov	bx, HELLO_MSG
call	print_string
call	print_newline

mov	bx, GOODBYE_MSG
call	print_string
call	print_newline

jmp 	$

%include '../print/print_string.s'

; Data
HELLO_MSG:
	db	'Hello World!', 0

GOODBYE_MSG:
	db	'Goodbyte!', 0

times 	510-($-$$) db 0	

dw 0xaa55
