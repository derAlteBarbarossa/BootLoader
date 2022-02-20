;
; A simple boot sector program that loops forever.
;


[org 0x7c00]

loop:
	mov 	ah, 0x0e	; `Write Character in TTY Mode`

	mov	bx, the_secret
	mov	al, [bx]	

	int	0x10

	jmp 	$		; Jump to the current address



the_secret:
	db	'X'

times 	510-($-$$) db 0	

dw 0xaa55
