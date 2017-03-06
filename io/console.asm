;
;  console.asm
;  pure assembler console module
;


	MODULE		io
	INCLUDE		"z80_crt0.hdr"
	INCLUDE		"../variables.asm"

; Public scope functions and variables

	PUBLIC 		_charset_default	; for setting default charset during kernel bootstrap
	PUBLIC		_putc			; void __FASTCALL__	putc(char code)
	PUBLIC		_puts			; void __FASTCALL__	puts(char* str)
	PUBLIC		_scan_keyboard		; void 			scan_keyboard()

._puts
	ld	a,(hl)
	or	a
	ret	z
	push 	hl
	ld	l, a
	call 	_putc
	pop	hl
	inc	hl
	jr 	_puts

._putc
	ld 	a, l
	or 	a				; zero-terminated
	ret 	z				; 

	cp	KeycodeEnter			; carrige return
	jr 	nz, putc_letters

	ld 	hl, CursorY
	ld 	a, (hl)
	inc 	a 
	cp 	ScreenSizeY
	jr 	nz, putc_nowrap
	xor 	a
.putc_nowrap
	ld 	(hl), a
	ld 	hl, CursorX
	ld 	(hl), 0
	ret

.putc_letters
	cp 	KeycodeSpace
	ret 	m
	sub 	KeycodeSpace
	ld 	c, a
	ld 	b, 0				; char code in BC
	sla 	c				; multiply BC by 8
	rl 	b
	sla 	c
	rl 	b
	sla 	c
	rl 	b
	ld 	hl, CharsetAddr			; Getting current charset addr
	ld	a, (hl)
	inc 	hl
	ld 	h, (hl)
	ld	l, a
	add	hl, bc				; adding symbol offset
	push 	hl
	call	get_cursor_screen_addr
	pop 	de				; HL - screen addr, DE - charset table addr
	ld 	b, 8				; copy 8 bytes
.lt_loop
	ld 	a, (de)
	ld	(hl), a
	inc 	de
	inc	h				; legendary 'next_line' subroutine from 90s
	ld	a, $07				; thoroughly restored by intuition
	and	h
	jr	nz, lt_next
	ld	a, $20
	add 	a, l
	ld 	l, a
	and 	$E0
	jr 	z, lt_next
	ld 	a, h
	sub 	8
	ld 	h, a
.lt_next
	dec 	b
	jr 	nz, lt_loop
						; copied!

	ld 	hl, CursorX			; incrementing x
	ld 	a, (hl)
	inc 	a
	and 	ScreenSizeX-1
	ld 	(hl), a
	ret 	nz				; x not wrapped, no need to modify y

	ld 	hl, CursorY
	ld 	a, (hl)
	inc 	a				; incrementing y
	cp 	ScreenSizeX
	jr	nz, lt_y_nowrap
	xor 	a
.lt_y_nowrap
	ld 	(hl), a
	ret


.get_cursor_screen_addr
	ld 	hl, CursorY
	ld 	b, (hl)				; cursor_y in B
	ld 	a, $18
	and	b				; after masking, B has third of screen in bits 3,4
	add	a, $40				; high byte of screen start
	ld 	h, a				; high byte
	ld 	a, $07
	and	b
	sla 	a				; getting low byte
	sla 	a
	sla 	a
	sla 	a
	sla 	a
	ld 	l, a
	push 	hl
	ld 	hl, CursorX
	ld 	c, (hl)
	ld 	b, 0
	pop 	hl
	add 	hl, bc
	ret

._scan_keyboard
	call	getk
	ret


.getk
	ld 	hl, sc_fin
	push 	hl   ; for ret instead of jp XX
	ld 	hl, 0
	ld 	e, 0
.cshft
    	ld 	bc, $FEFE
    	in 	a, (c)
    	bit 	0, a
    	jr 	nz, sshft
    	inc 	e
.sshft
	ld	b, $7F
	in 	a, (c)
	bit	1, a
	jr 	nz, kspace
	inc 	e
	inc 	e
.kspace
	bit	0, a
	jr 	nz, km
	ld 	l, 32
	ret
.km
	bit 	2, a
	jr 	nz, kn
	ld 	l, 77
	ret
.kn
	bit	3, a
	jr 	nz, kb
	ld 	l, 78
	ret
.kb
	bit 	4, a
	jr 	nz, kent
	ld 	l, 66
	ret
.kent
	ld 	b, $BF
	in 	a, (c)
	bit	0, a
	jr 	nz, kl
	ld 	l, 13
	ret
.kl
	bit	1, a
	jr	nz, kk
	ld	l, 76
	ret
.kk
	bit	2, a
	jr	nz, kj
	ld	l, 75
	ret
.kj
	bit	3, a
	jr	nz, kh
	ld	l, 74
	ret
.kh
	bit	4, a
	jr	nz, kp
	ld	l, 72
	ret

.kp
	ld	b, $DF
	in	a, (c)
	bit	0, a
	jr	nz, ko
	ld	l, 80
	ret
.ko
	bit	1, a
	jr	nz, ki
	ld	l, 79
	ret
.ki
	bit	2, a
	jr	nz, ku
	ld	l, 73
	ret
.ku
	bit	3, a
	jr	nz, ky
	ld	l, 85
	ret
.ky
	bit	4, a
	jr	nz, k0
	ld	l, 89
	ret

.k0
	ld	b, $EF
	in	a, (c)
	bit	0, a
	jr	nz, k9
	ld	l, 48
	ret
.k9
	bit	1, a
	jr	nz, k8
	ld	l, 57
	ret
.k8
	bit	2, a
	jr	nz, k7
	ld	l, 56
	ret
.k7
	bit	3, a
	jr	nz, k6
	ld	l, 55
	ret
.k6
	bit	4, a
	jr	nz, k1
	ld	l, 54
	ret

.k1
	ld	b, $F7
	in	a, (c)
	bit	0, a
	jr	nz, k2
	ld	l, 49
	ret
.k2
	bit	1, a
	jr	nz, k3
	ld	l, 50
	ret
.k3
	bit	2, a
	jr	nz, k4
	ld	l, 51
	ret
.k4
	bit	3, a
	jr	nz, k5
	ld	l, 52
	ret
.k5
	bit	4, a
	jr	nz, kq
	ld	l, 53
	ret

.kq
	ld	b, $FB
	in	a, (c)
	bit	0, a
	jr	nz, kw
	ld	l, 81
	ret
.kw
	bit	1, a
	jr	nz, ke
	ld	l, 87
	ret
.ke
	bit	2, a
	jr	nz, kr
	ld	l, 69
	ret
.kr
	bit	3, a
	jr	nz, kt
	ld	l, 82
	ret
.kt
	bit	4, a
	jr	nz, ka
	ld	l, 84
	ret

.ka
	ld	b, $FD
	in	a, (c)
	bit	0, a
	jr	nz, ks
	ld	l, 65
	ret
.ks
	bit	1, a
	jr	nz, kd
	ld	l, 83
	ret
.kd
	bit	2, a
	jr	nz, kf
	ld	l, 68
	ret
.kf
	bit	3, a
	jr	nz, kg
	ld	l, 70
	ret
.kg
	bit	4, a
	jr	nz, kz
	ld	l, 71
	ret
.kz
	ld	b, $FE
	in	a, (c)
	bit	1, a
	jr	nz, kx
	ld	l, 90
	ret
.kx
	bit	2, a
	jr	nz, kc
	ld	l, 88
	ret
.kc
	bit	3, a
	jr	nz, kv
	ld	l, 67
	ret
.kv
	bit	4, a
	jr	nz, nokey
	ld	l, 86
	ret
.nokey  
	pop	bc ; no need to ret to fin
	ld	l, 0
	ret
.sc_fin
	bit	0, e
	ret	z
	ld	de, 32
	add	hl, de
	ret

	INCLUDE "charset.inc"