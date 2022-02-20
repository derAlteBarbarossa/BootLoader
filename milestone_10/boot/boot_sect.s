;
; A simple boot sector program that loops forever.
;
[org 0x7c00]
KERNEL_OFFSET	equ	0x1000		; This is the memory offset to which we will load our kernel

boot_loader:

	mov	[BOOT_DRIVE], dl	; BIOS stores our boot drive in DL, so it’s
					; best to remember this for later.

	mov 	bp, 0x9000 		; Set-up the stack.
	mov 	sp, bp

	mov 	bx, MSG_REAL_MODE	; Announce that we are starting
	call 	print_string		; booting from 16-bit real mode
	call	print_newline
	
	call	load_kernel		; Load our kernel

	call 	switch_to_pm		; Switch to protected mode, from which
					; we will not return


	jmp	$

%include 'boot/16bit/print_string.s'
%include 'boot/disk/disk_load.s'
%include 'boot/switch_to_pm/gdt.s'
%include 'boot/switch_to_pm/switch.s'
%include 'boot/pm/print_string_32.s'

[bits 16]
; load_kernel
load_kernel:
	mov 	bx, MSG_LOAD_KERNEL 
	call 	print_string
	call	print_newline

	mov	bx, KERNEL_OFFSET
	mov	dh, 0x20
	mov	dl, [BOOT_DRIVE]
	call	disk_load
	ret


[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov 	ebx , MSG_PROT_MODE
	call 	print_string_pm		; Use our 32-bit print routine. 

	
	call	KERNEL_OFFSET		; Now jump to the address of our loaded
					; kernel code , assume the brace position , 
					; and cross your fingers. Here we go!

	jmp	$

; Global variables
BOOT_DRIVE	db	0
MSG_REAL_MODE	db	"Started in 16-bit Real Mode", 0
MSG_PROT_MODE 	db 	"Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL	db	"Loading kernel into memory.", 0

times 	510-($-$$) db 0	

dw 0xaa55
