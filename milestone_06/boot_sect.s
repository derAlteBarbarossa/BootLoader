;
; A simple boot sector program that loops forever.
;
[org 0x7c00]

main:

	mov 	bp, 0x9000 
	mov 	sp, bp

	mov 	bx, MSG_REAL_MODE
	call 	print_string
	call	print_newline
	
	call 	switch_to_pm

%include '../print/print_string.s'
%include '../pm/gdt.s'
%include '../pm/print_string_32.s'
%include '../pm/switch.s'

[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov 	ebx , MSG_PROT_MODE
	call 	print_string_pm		; Use our 32-bit print routine. 
	jmp 	$ 			; Hang.

; Global variables
MSG_REAL_MODE	db	"Started in 16-bit Real Mode", 0
MSG_PROT_MODE 	db 	"Successfully landed in 32-bit Protected Mode", 0

times 	510-($-$$) db 0	

dw 0xaa55
