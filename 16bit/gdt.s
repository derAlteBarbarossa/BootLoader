; GDT
gdt_start:
	gdt_null:			; The first 8 Bytes of GDT should be null descriptor
		dd	0x0
		dd	0x0

	gdt_code:			; Code segment descriptor
		; limit=0xfffff, base = 0x0
		; 1st flags: 	P(Present)=1 (the segment is present in memory)
		;		DPL(Descriptor Privilege Level)=00
		;		S(Descriptor Type)=1 -> 1001b
		; type flags: Code=1 Conforming=0 Readable=1 Accessed=0 -> 1010b
		; 2nd flags: G(Granularity)=1 D/B(Default Operation Size)=1 
		; L(64-bit Code Segment)=0 AVL(Available)=0 -> 1100b
		dw	0xffff		; Segment limit (0:15)
		dw	0x0000		; Segment base (0:15)
		db	0x0		; Segment base (16:23)
		db	10011010b	; First Flag + Type
		db	11001111b	; Second Flag + Limit (16:19)
		db	0x0		; Segment base(24:31)

	gdt_data:
		; limit=0xfffff, base = 0x0
		; 1st flags: 	P(Present)=1 (the segment is present in memory)
		;		DPL(Descriptor Privilege Level)=00
		;		S(Descriptor Type)=1 -> 1001b
		; type flags: Code=0 Expand Down=0 Writeable=1 Accessed=0 -> 1010b
		; 2nd flags: G(Granularity)=1 D/B(Default Operation Size)=1 
		; L(64-bit Code Segment)=0 AVL(Available)=0 -> 1100b
		dw	0xffff		; Segment limit	(0:15)
		dw	0x0000		; Segment base (0:15)
		db	0x0		; Segment base (16:23)
		db	10010010b	; First Flag + Type
		db	11001111b	; Second Flag + Limit (16:19)
		db	0x0		; Segment Base (24:31)

	gdt_end:

gdt_descriptor:
	dw	gdt_end - gdt_start - 1
	dd	gdt_start	

; Define some handy constants for the GDT segment descriptor offsets, which
; are what segment registers must contain when in protected mode. For example,
; when we set DS = 0x10 in PM, the CPU knows that we mean it to use the
; segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our
; case is the DATA segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start	
