;
; proc.asm 
; pure assembler functions for processes manipulation
;

	MODULE 		proc
	INCLUDE 	"z80_crt0.hdr"
	INCLUDE		"../variables.asm"

; Public scope functions

	PUBLIC 		_find_empty_slot		; p_descriptor_t*		find_empty_slot	();
	PUBLIC		_create_process			; p_descriptor_t* 		create_process	(void* code_start, void* stack_start);
	PUBLIC		_get_process_descriptor		; p_descriptor_t* __FASTCALL__	get_process_descriptor (unsigned char p_num);
	PUBLIC		_get_process_descriptor_current ; p_descriptor_t*		get_process_descriptor_current ();
	PUBLIC		_reap_process			; void				reap_process ();
	PUBLIC		_switch_context			; void				switch_context ();
	PUBLIC		_get_cp_stack_pointer		; void*				get_cp_stack_pointer ();

;
; find_empty_slot returns process descriptor addr in HL or 0 if it's not found
; modifies af, bc, de, ix
;
._find_empty_slot
	ld	b, 8				; counter (max 8 processes to search in)
	ld	ix, ProcessTable		; the process table starts
.fes_loop
	ld	a, (ix+6)			; 6th byte is the 'exists' field
	or	a
	jr	z, fes_found
	dec	b 				; decrement counter
	jr 	z, fes_not_found
	ld 	de, ProcessDescriptorSize	; size of process descriptor
	add	ix, de
	jr	fes_loop
.fes_not_found
	ld	ix, 0
.fes_found
	push	ix				;  c compiler compatibility:
	pop	hl				;  result must be returned in hl
	ret

;
; create_process creates a new process starting at code_start, pointing stack at stack_start
; returns process descriptor addr or 0 in case if process cannot be created
; p_descriptor_t* create_process(void* code_start, void* stack_start)
;
;
._create_process
	di					; prevent process switching
	call 	_find_empty_slot		; getting empty process descriptor addr
	ld	a, h
	or	a				; checking if process descriptor addr high byte is zero (in that case there are no empty slots)
	jr	z, cpr_error
	push 	hl
	pop	ix				; ix now points to process descriptor
	ld	hl, 4
	add 	hl, sp 				; hl now points to code_start parameter
	push 	hl
	call	l_gint
	push	hl
	pop	de				; saving code_start to DE for further use
	ld	(ix+0), l
	ld	(ix+1), h
	pop	hl
	dec 	hl
	dec 	hl				; hl now points to stack_start parameter
	call 	l_gint
						; preparing stack procedure
						; when kernel switches processes it pushes all registers so that stack looks like
						; af, bc, de, hl, ix, iy, process return address, reaper address
						; (when process finishes its task it should return to process reaper code)
	ld 	bc, _reap_process
	dec 	hl				; storing reaper addr to process stack
	ld 	(hl), b
	dec 	hl
	ld 	(hl), c
	dec	hl				; storing process code start addr to process stack
	ld	(hl), d				; so kernel would be able to return after process switching
	dec	hl
	ld 	(hl), e
	ld	bc, -12
	add	hl, bc				; making space for af,bc,de,hl,ix,iy
	ld	(ix+4), l			; storing stack pointer to process descriptor
	ld 	(ix+5),	h
	ld	(ix+6), True			; setting process descriptor 'exists' field to 1
	ld	(ix+7), StatusRunning		; setting process descriptor 'status' field to running

.cpr_error
	ld	hl, 0
.cpr_ret
;	ei
	ret

; 
; p_descriptor_t* get_process_descriptor_current()
; NOTICE FALLTHROUGH TO get_process_descriptor(...)
;
._get_process_descriptor_current
	ld	hl, ProcessCurrent
	ld	l, (hl)
	ld	h, 0
;
; p_descriptor_t* __FASTCALL__ get_process_descriptor(unsigned char p_num)
;
._get_process_descriptor

	ld 	a, 7				; masking everything but 3 lower bits
	and	l
	ld 	l, a
	sla	l
	sla	l				; multiply p_num by 8 (64 max, no need to increment h)
	sla	l
	push	bc
	ld	bc, ProcessTable
	add	hl, bc
	pop	bc
	ret

;
; void reap_process()
; reaps current process
; and stays in infinite loop waiting for kernel to switch to the next process
;
._reap_process
	di					; preventing process switching
	call 	_get_process_descriptor_current
	xor	a
	ld	b, 8
.rp_fill					; filling process descriptor with zeroes
	ld	(hl), a
	inc 	hl
	dec	b
	jr	nz, rp_fill
	ei					; enabling interrupts
.rp_infinite
	jr	rp_infinite


;
; void switch_context();
; main kernel process switching mechanism
; one existing and running process must present in processes table otherwise
; there's nowhere to switching
;

._switch_context
	ld	hl, ProcessCurrent
	ld	b,(hl)				; current process number
	ld	hl, 2				; get current stack pointer
	add 	hl, sp				; without ret to kernel INT handler
	push	hl
	pop 	de				; storing to DE for further use	
	call 	_get_process_descriptor_current
	ld	a, 4				; process descriptor stack pointer storage
	add 	a, l
	ld 	l, a
	ld	(hl), e
	inc	hl
	ld	(hl), d
.sctx_search
	inc	b
	ld	a, 7
	and	b
	ld	b, a
	ld	l, a
	ld	h, 0
	call	_get_process_descriptor
	ld	a, 6
	add	a, l
	ld	l, a
	ld	a,(hl)				; get process 'exists' field
	or	a
	jr 	z, sctx_search
	inc	l
	ld	a,(hl)				; get process 'status' field
	cp	StatusRunning
	jr	nz, sctx_search
	ld	hl, ProcessCurrent
	ld	(hl), b	
	ret

;
; void* get_cp_stack_pointer()
; returns value of current process stack pointer taken from process descriptor
;
._get_cp_stack_pointer
	call	_get_process_descriptor_current
	ld	a, 4
	add	a, l
	ld	l, a
	call	l_gint
	ret
