	CPU 8085UNDOC

BASE EQU 8000h
STACK EQU 0c000h
DEST EQU 0d000h
DEST2 EQU 0e000h
HL_STORE EQU 0ee00h
DE_STORE EQU 0ef00h

	ORG BASE

	DI
	JMP START

	ORG BASE+38h ; RST 8
	JMP RETURN_PC


	ORG BASE+100h
START:
	LXI H, STACK
	SPHL
	CALL UART_INIT
	CALL RETURN_PC
rSP:
	LDHI	NEW_STACK - rSP	; "undocumented" instruction just DE = HL + imm8
	XCHG
	SPHL
	RET

FLAG:
	; DB "DISOBEY[sometimes vendors don't tell about all of the features!]"
	DB 002h, 047h, 00Ch, 043h, 0FFh, 046h, 013h, 048h, 02Bh, 044h, 029h, 03Ch, 038h, 031h, 03Ch, 029h, 04Ah, 0D6h, 0A0h, 0C5h, 0A9h, 0BBh, 0B4h, 0BEh, 0B5h, 06Bh, 0F9h, 076h, 0F8h, 02Fh, 045h, 0DBh, 099h, 0CCh, 0A0h, 0CCh, 054h, 00Dh, 055h, 01Ah, 05Bh, 019h, 007h, 05Ah, 012h, 05Ah, 0C6h, 0A9h, 0BDh, 063h, 011h, 057h, 00Eh, 012h, 054h, 011h, 050h, 024h, 051h, 021h, 044h, 02Fh, 0F2h, 06Bh
FLAG_END:

FLAG_OUTPUT3:				; Setup for decrypting the previously encrypted flag
	LXI	H, DEST
	LXI D, DEST2
	MVI C, FLAG_END - FLAG
	MVI B, 42h
	RET

NEW_STACK:
	DW FLAG_OUTPUT1
	DW FLAG_OUTPUT4
	DW FLAG_OUTPUT3
	DW FLAG_OUTPUT4

	; Some random data
	DB 0f2h, 092h, 0f3h, 032h, 080h, 0bfh, 0fch, 023h, 095h, 0b2h, 03ch, 036h, 069h, 033h, 0a7h, 030h, 014h, 0b9h, 0efh, 066h, 068h, 013h, 096h, 091h, 0a5h, 063h, 023h, 0ech, 0fch, 09ch, 0c8h, 06dh, 07h, 0a4h, 0e1h, 095h, 092h, 0bbh, 0eh, 0e1h, 0fdh, 0d6h, 09dh, 0c1h, 0f8h, 02ch, 08bh, 0b5h, 06ch, 068h, 051h

RETURN_PC:	; Get the calling program counter to HL
	POP H
	PUSH H
	RET

FLAG_OUTPUT4:				; Flag decryption routine
	MOV A, M
	SHLD HL_STORE

	MOV D, B
	MOV E, C

	MVI B, 80h
	MOV C, D
	MVI H, 0
	MOV L, A
	DAD B
	MOV A, L

	MOV B, D
	MOV C, E

	LXI D, HL_STORE
	LHLX D					; "undocumented" instruction; HL = (DE)
	CALL UART_OUT
	MOV B, M
	INX H
	INX D
	DCR C
	JNZ FLAG_OUTPUT4
	RST 1

	; some more random data
	DB 078h, 010h, 042h, 0dah, 066h, 069h, 0ddh, 0eah, 0b7h, 02h, 012h, 032h, 05eh, 036h, 0fch, 0f5h, 040h, 084h, 0ech, 012h, 0eeh, 03bh, 023h, 01dh, 0abh, 0cah, 069h, 0c4h, 089h, 0ffh, 043h, 0c4h, 03dh, 0d4h, 041h, 03dh, 0aeh, 01h, 0f3h, 0e4h, 039h, 0ach, 051h, 064h, 082h, 0beh, 03fh, 010h, 093h

FLAG_OUTPUT2:				; Flag encryption routine, uses mod 256 substraction via undocumented instructions
	MOV A, M
	SHLD HL_STORE
	XCHG
	SHLD DE_STORE
	MOV D, B
	MOV E, C
	MVI B, 80h
	MOV C, D
	MVI H, 0
	MOV L, A
	DSUB B					; "Undocumented instruction"; HL = HL - BC, 16bit subtraction
	MOV A, L
	MOV B, D
	MOV C, E
	LHLD DE_STORE
	XCHG
	LHLD HL_STORE
	;ADD B
	STAX D
	MOV B, A
	INX H
	INX D
	DCR C
	JNZ FLAG_OUTPUT2
	MVI A, 0
	MOV M, A
	; RST 1
	RET

FLAG_OUTPUT1:				; Setup for flag encryption / decryption
	LXI	H, FLAG
	LXI D, DEST
	MVI C, FLAG_END - FLAG
	MVI B, 42h
	RET

PRINT_STRING:
		MOV	A,M				; Get byte from message
		INX	H				; Advance to next
		ANA	A				; End of message?
		RZ					; Yes, exit
		CALL UART_OUT		; Output the character
		JMP	PRINT_STRING	; And proceed

; Blocking print character to UART
UART_OUT:
	PUSH	PSW		; Save char
OUT1:
	IN	9			; Get 8251 status
	RRC				; Test TX bit
	JNC	OUT1		; Not ready
	POP	PSW			; Restore char
	OUT	8			; Write 8251 data
	RET

UART_INIT:
		XRA	A			; Insure not setup mode
		OUT	9			; Write once
		OUT	9			; Write again (now in operate mode)
		OUT	9			; Write again (now in operate mode)
		MVI	A,01000000b	; Reset
		OUT	9			; write it
		MVI	A,01001110b	; 8 data, 1 stop, x16
		OUT	9			; Write it
		MVI	A,00110111b	; RTS,DTR,Enable RX,TX
		OUT	9			; Write it
		RET

