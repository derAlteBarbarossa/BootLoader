;
; A simple boot sector program that loops forever.
;


;[org 0x7c00]

main:
	mov	bx, 0x7c0
	mov	ds, bx

	mov	bx, 0x1234
	call	print_hex

	call	print_newline

	mov	bx, 0x4321
	call	print_hex

	call	print_newline

	jmp	$

%include '../print/print_hex.s'
%include '../print/print_string.s'

times 	510-($-$$) db 0	

dw 0xaa55
