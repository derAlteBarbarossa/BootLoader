;
; A simple boot sector program that loops forever.
;


[org 0x7c00]

main:
	mov	[BOOT_DRIVE], dl	; BIOS stores the boot drive at dl

	mov	bp, 0x8000
	mov	sp, bp

	mov	bx, 0x9000
	
	mov	dh, 2
	mov	dl, [BOOT_DRIVE]
	call	disk_load


	mov	bx, [0x9000]
	call	print_hex

	call	print_newline
	
	mov	bx, [0x9000 + 512]
	call	print_hex

	call	print_newline

	pop	bx

	jmp	$

%include	'../disk/disk_load.s'
%include	'../print/print_string.s'
%include	'../print/print_hex.s'

BOOT_DRIVE:
	db	0

times 	510-($-$$) db 0	

dw 0xaa55

times 256 dw 0xdada ; sector 2 = 512 bytes
times 256 dw 0xface ; sector 3 = 512 bytes
