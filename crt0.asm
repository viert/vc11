EXTERN 		_kernel_entry
EXTERN		_get_cp_stack_pointer
EXTERN		_switch_context

	org	$0000
	di
	ld	a, 63
	ld	i, a
	im	1
	jp	_kernel_entry

	defs $0038-ASMPC
	di
	push 	iy
	push 	ix
	push 	hl
	push 	de
	push 	bc
	push	af
	call	_switch_context
	call	_get_cp_stack_pointer
	ld	sp, hl
	pop	af
	pop	bc
	pop	de
	pop	hl
	pop	ix
	pop	iy
	ei
	reti