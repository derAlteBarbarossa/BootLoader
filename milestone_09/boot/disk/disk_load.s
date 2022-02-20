disk_load:
	pusha

	push	dx
	mov	ah, 0x02	; BIOS read sector function

	mov	al, dh		; Read 'dh' sectors
	mov	ch, 0x00	; Select Cylinder 1 (0-indexed)
	mov	dh, 0x00	; Select Head 1
	mov	cl, 0x02	; Start reading the 2nd sector
				; Bootloader is in the 1st sector
	
	int	0x13		; BIOS interrupt

	jc	sector_error

	pop	dx
	cmp	dh, al
	jne	disk_error 

	popa
	ret

sector_error:
	mov	bx, SECTOR_ERROR_MSG
	call	print_string
	jmp	$

disk_error:
	mov	bx, DISK_ERROR_MSG
	call	print_string
	jmp	$


DISK_ERROR_MSG:
	db	"Disk Read Error!\n", 0
SECTOR_ERROR_MSG:
	db	"Sector Read Error!\n", 0

RET_MSG:
	db	'Read data!', 0
