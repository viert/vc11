;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 20170113
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Sat Feb 25 23:01:46 2017



	MODULE	test


	INCLUDE "z80_crt0.hdr"


	SECTION	code_compiler


._get
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	de,5
	add	hl,de
	ex	de,hl
	ld	hl,4-2	;const
	add	hl,sp
	call	l_gint	;
	add	hl,de
	ret



._get2
	ld	hl,5	;const
	push	hl
	ld	hl,7	;const
	push	hl
	call	_get
	pop	bc
	pop	bc
	ret



._cs
	call	_get2
	ld	hl,2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ret



._empty
	ld	hl,9 % 256	;const
	push	hl
	call	_cs
	pop	bc
	ret




; --- Start of Static Variables ---

	SECTION	bss_compiler

	SECTION	code_compiler



; --- Start of Scope Defns ---

	PUBLIC	_cs
	PUBLIC	_get
	PUBLIC	_empty
	PUBLIC	_get2


; --- End of Scope Defns ---


; --- End of Compilation ---
