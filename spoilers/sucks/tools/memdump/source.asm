	CPU 8085
	ORG 0bf02h


	LXI H, 0
loop:
	MOV A, M
	CALL HPR
	INX H
	MOV A, H
	ORA L
	JNZ loop
	RST 1


; Display A in hexidecimal
;
HPR:	PUSH	PSW		; Save low digit
	RRC			; Shift
	RRC			; high
	RRC			; digit
	RRC			; into low
	CALL	HOUT		; Display a single digit
	POP	PSW		; Restore low digit
HOUT:	ANI	0Fh		; Remove high digit
	CPI	10		; Convert to ASCII
	SBI	2Fh
	DAA
	JMP	OUT		; And output it

; Blocking print character to UART
OUT:
	PUSH	PSW		; Save char
OUT1:
	IN	9			; Get 8251 status
	RRC				; Test TX bit
	JNC	OUT1		; Not ready
	POP	PSW			; Restore char
	OUT	8			; Write 8251 data
	RET