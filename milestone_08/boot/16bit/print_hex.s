;
; A simple boot sector program that loops forever.
;


print_hex:
	pusha

	mov	cx, 0
	mov	dx, bx
	
	mov	bx, HEX_VALUE + 5

	hex_loop:
		cmp	cx, 4
		je	print

		mov	ax, dx
		and	al, 0x0f
		add	al, 0x30
	
		cmp	al, 0x39
		jle	store_in_string

		add	al, 7

		store_in_string:
			mov	[bx], al
			dec	bx
			inc	cx
			ror	dx, 4

			jmp	hex_loop
	
	print:
		mov	bx, HEX_VALUE
		call	print_string


	popa
	ret


; 4 BYTE String to store the hex value
HEX_VALUE:
	db	"0x0000", 0
