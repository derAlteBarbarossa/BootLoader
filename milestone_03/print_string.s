;
; A simple boot sector program that loops forever.
;

print_string:
	pusha
	mov	ah, 0x0e	; To use TTY
	loop:
		mov	al, [bx]
		cmp	al, 0
		je	end
		int 	0x10
		inc	bx
		jmp	loop

	end:
		popa
		ret

