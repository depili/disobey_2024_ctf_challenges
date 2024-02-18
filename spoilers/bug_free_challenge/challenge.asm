	CPU	8051
	INCLUDE	p80c51fa.inc
	; INCLUDE ../paulmon2/paulmon_v3.0.inc

	ORG 	0000h

	EQU	DEST, 40h

start:
	CALL	serial_init
	MOV	20h, #80h
	MOV	21h, #0FFh
	MOV	22h, #80h
	MOV	23h, #(RND >> 8)
	MOV	24h, #(RND & 0ffh)
	MOV	25h, #1
	CALL	add1
	MOV	21h, #0F0h
	CALL	add2
	CALL	decrypt
	RET
add1:
	MOV	R0, #20h
	MOV	A, @R0
	ADD	A, #80h
	MOV	@R0, A
	INC	R0
	CLR	A
	ADDC	A, @R0
	JC	.carry
	RET
.carry:
	; Ghidra thinks this is unreachable
	MOV	24h, #((RND & 0ffh)+23)
	RET

add2:
	MOV	R1, #20h
	MOV	R0, #21h
.loop:
	SETB	CY
	CLR	A
	ADDC	A, @R0
	JC	.end
	MOV	@R0, A
	DJNZ	R1, .loop
	RET
.end:
	; Ghidra thinks this is unreachable
	MOV	25h, #2
	RET

decrypt:
	; MOV	A, 23h
	; CALL	pm.phex
	; MOV	A, 24h
	; CALL	pm.phex
	; MOV	A, 25h
	; CALL	pm.phex
	MOV	DPTR, #FLAG
	MOV	R1, #DEST
.copy_loop:
	CLR	A
	MOVC	A, @a+dptr
	JZ	.xor
	MOV	@R1, A
	INC	dptr
	INC	r1
	SJMP	.copy_loop
.xor:
	MOV	@R1, #0
	MOV	DPH, 23h
	MOV	DPL, 24h
	MOV	R1, #DEST
.xor_loop:
	CLR	A
	MOVC	A, @a+dptr
	XRL	A, @R1
	JZ	.end
	MOV	@R1, A
	MOV	R3, 25h
-	INC	dptr
	DJNZ	R3, -
	INC	R1
	SJMP	.xor_loop
.end:
	INC	R1
	MOV	@R1, #0
	MOV	R1, #DEST
.out_loop:
	MOV	A, @R1
	JZ	.return
	CALL	cout
	INC	R1
	SJMP	.out_loop
.return:
	RET

cout:
	jnb	ti, cout
	clr	ti		; clr ti before the mov to sbuf!
	mov	sbuf, a
	ret

serial_init:
	mov	T2CON, #00110100b		; TRCLK = 1, TCLK = 1, TR2 = 1, rest 0
	mov 	RCAP2H, #0FFH
	mov	RCAP2L, #0f3h
	mov	SCON, #01011010B		; SM1, REN, TB8, TI
	RET

RND:
	; 256 bytes of random data for xor key
	DB	244,221,121,139,9,72,109,99,149,49,178,45,225,101,166,86,154,57,235,6,21,213,68,26,205,130,237,121,238,252,118,175,192,249,120,163,139,181,227,244,25,35,130,65,42,65,55,237,2,166,33,219,238,18,6,143,239,139,190,229,118,88,87,197,101,202,85,33,190,181,8,56,175,7,246,213,146,152,171,5,88,96,189,123,221,254,42,124,251,182,153,245,64,204,165,115,144,71,13,255,199,59,108,101,49,65,204,143,170,99,234,125,12,78,210,122,63,186,95,98,84,197,179,211,225,45,63,229,16,60,166,148,48,63,12,234,163,124,245,113,63,101,193,55,148,94,177,18,159,184,0,174,135,36,127,9,142,227,16,184,23,216,141,163,236,228,195,46,111,71,251,231,12,73,156,208,40,187,140,151,6,32,173,219,28,62,218,87,101,40,142,81,158,200,94,72,178,131,18,145,132,156,0,239,78,251,180,106,57,170,10,160,216,54,26,27,40,149,102,75,200,169,180,46,192,228,23,226,74,13,72,181,173,154,70,163,103,27,119,56,99,63,244,222,242,45,245,1,215,90,248,241,181,134,105,172


FLAG:
;	DB	"DISOBEY[gh1Dr4 bUg 6074]",0
	DB	5Eh, 0CBh, 2Ah, 0B3h, 0EDh, 0BCh, 0FAh, 0EEh, 93h, 4Bh, 70h, 05h, 9Fh, 92h, 0FBh, 70h
	DB	0DAh, 0ECh, 0C5h, 6Eh, 0F5h, 0FDh, 15h, 0E8h, 38h, 0A8h, 51h, 02h, 7Ch, 10h, 0EFh, 2Ah
