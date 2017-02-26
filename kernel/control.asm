;
; control.asm 
; pure assembler kernel control section
;

	MODULE 		control
	INCLUDE 	"z80_crt0.hdr"

	EXTERN 		_dummy1
	EXTERN		_dummy2
	EXTERN		_create_process

; Public scope functions

	PUBLIC 		_kernel_entry			; void		kernel_entry ();
	PUBLIC		_clear_ram			; void		clear_ram ();

; Constants

	DEFC		DUMMY_STACK = $8600
	DEFC		DUMMY2_STACK = $8680

;
; kernel_entry()
; starts the kernel
;

._kernel_entry
	ld	hl, $4000				; clears ram
	ld	bc, $C000
	xor	a
.cr_loop
	ld	(hl), a
	inc	hl
	dec	c
	jr 	nz, cr_loop
	dec	b
	jr	nz, cr_loop
	
	ld	hl, ke_loop				; zero process (kernel loop)
	push	hl
	ld	hl, 2
	add	hl, sp
	push	hl
	call	_create_process
	pop	bc
	pop	bc

	ld	hl, _dummy1				; first process
	push	hl
	ld	hl, DUMMY_STACK
	push	hl
	call	_create_process
	pop	bc
	pop	bc

	ld	hl, _dummy2				; second process
	push	hl
	ld	hl, DUMMY2_STACK
	push	hl
	call	_create_process
	pop	bc
	pop	bc

.ke_loop
	ei
	halt
	jr	ke_loop


