;
; A simple boot sector program that loops forever.
;

%include '../print/print_string.s'

print_hex:
	pusha
	
	mov	ax, bx

	mov	cl, 3		; As the out put would have 4 digits
	mov	bx, HEX_VALUE
	add	bx, 5

	push	bx		; Store the base address for further address calculations

	loop_1:			; To iterate over the memory

		mov	ah, 0
		mov	bl, 0x10
		div	bl
		 
		mov	ch, 16

		loop_2:		; To find the correct hex value

			dec	ch
			cmp	ah, ch
			jne	loop_2

			cmp	ah, 0x09
			jg	bigger_than_9
			jle	less_than_10


			bigger_than_9:
				mov	dl, ah
				sub	dl, 0x0A
				add	dl, 'A'
				jmp	write_hex_val
	
			less_than_10:
				mov	dl, ah
				add	dl, '0'	
				jmp	write_hex_val

			write_hex_val:
				pop	bx
				mov	dl, [bx]		
				dec	bx
				push	bx			
				jmp	continue

		
		continue:
			dec	cl
			cmp	cl, 0
			jge	loop_1

	
	mov	bx, HEX_VALUE
	call	print_string

	popa
	ret

; 4 BYTE String to store the hex value
HEX_VALUE:
	db	"0x", "XXXX", 0
