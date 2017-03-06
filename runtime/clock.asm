;
; clock.asm
; simple pure assembler kernel clock 
;
	MODULE runtime
	INCLUDE "../variables.asm"

	PUBLIC		_inc_clock

._inc_clock
	ld 	hl, Clock
	inc 	(hl)
	ret 	nz
	inc 	hl
	inc	(hl)
	ret 	nz
	inc 	hl
	inc	(hl)
	ret 	nz
	inc 	hl
	inc	(hl)
	ret