;
; control.asm 
; pure assembler kernel control section
;

	MODULE 		runtime
	INCLUDE 	"z80_crt0.hdr"
	INCLUDE		"../variables.asm"

	EXTERN 		_dummy1
	EXTERN		_dummy2
	EXTERN		_create_process
	EXTERN		_charset_default

; Public scope functions

	PUBLIC 		_kernel_entry			; void		kernel_entry ();

; Constants

	DEFC		DUMMY_STACK = $8600

;
; kernel_entry()
; starts the kernel
;

._kernel_entry
	call 	clear_ram
	call 	set_defaults
	ld	hl, control_loop			; zero process (kernel loop)
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
                                ; continuously flow to zero process
.control_loop
	ei
	halt
	jr	control_loop

; clears ram
.clear_ram
	pop 	de					; saving return addr before wiping memory
	ld	hl, ScreenStart				; clears ram
	ld	bc, $BF00				; B is not C0 because C is actually makes one extra 256 cycle because of post zero checking
	xor	a
.cr_loop
	ld	(hl), a
	inc	hl
	dec	c
	jr 	nz, cr_loop
	dec	b
	jr	nz, cr_loop
	push 	de					; restoring the return addr (stack is wiped)
	ret

; setting kernels variables defaults
.set_defaults
	ld	de, _charset_default			; setting charset addr
	ld 	hl, CharsetAddr
	ld	(hl), e
	inc 	hl
	ld 	(hl), d
	ret