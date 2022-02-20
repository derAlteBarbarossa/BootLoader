;
; A simple boot sector program that loops forever.
;

loop:
	mov 	ah, 0x0e	; `Write Character in TTY Mode`

	mov	al, '!'
	int	0x10

	jmp 	$		; Jump to the current address



times 	510-($-$$) db 0	

dw 0xaa55
