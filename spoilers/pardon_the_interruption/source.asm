		CPU 8085
BASE EQU 0000h
STACK EQU 0c000h
DATA_IN EQU 0f000h
COUNTER EQU 0f001h
BUFFER_H EQU 0f1h

		ORG BASE

		DI					; execution starts here on power on
		JMP MAIN

		ORG BASE + 34h
RST65:						; Interrupt vector for 8251A RxREADY signal
		JMP UART_RX

		ORG BASE + 40h
MAIN:
	LXI SP, STACK			; Initialize stack
	CALL UART_INIT			; Initialize 8251A UART
	MVI A, 00011101b		; Unmask interrupt 6.5, keep others masked
	SIM						; Set interrupt mask
	XRA A					; Clear A
	STA DATA_IN				; Clear uart character input location
	STA COUNTER				; Clear uart character count location
	; MVI A, "K"
	; CALL UART_OUT
	LXI H, COUNTER			; Point HL to character counter
loop:
	EI						; Enable interrupts after processing loop..
	LDA DATA_IN				; Load the last read character
	ANA A					; check for non-zero
	JZ loop					; if character was a null continue the loop
	; CALL UART_OUT
	CALL CHECK				; Check the incoming character for the flag
	XRA A					; Clear A
	STA DATA_IN				; Clear last read character

	JMP loop

UART_RX:					; 8251A UART receive interrupt service routine
	PUSH PSW				; Store A and PSW
	PUSH H					; Store HL
	RIM						; Dummy read interrupt mask instruction
	IN 9					; Dummy read 8251A status register instruction
	IN 8					; Read the received character
	STA DATA_IN				; Store the character
	LXI H, COUNTER			; Set HL to point to the counter
	INR M					; increment the counter
	POP H					; restore HL
	POP PSW					; restore A and PSW
	RET						; return from interupt

correct: DB "\nCORRECT\n", 0
incorrect: DB "\nERROR \n",0

ALL_OK:						; All characters OK
		LXI H, correct
		CALL PRINT_STRING
		JMP OUT2

ERROR:						; Error, wrong character
		LXI H, incorrect
		CALL PRINT_STRING
OUT2:						; Wait for all characters to be transmitted before reseting
		IN	9				; Get 8251 status
		RRC					; Test TX bit
		JNC	OUT2			; Not ready
		JMP MAIN


PRINT_STRING:				; Print a null terminated string
		MOV	A,M				; Get byte from message
		INX	H				; Advance to next
		ANA	A				; End of message?
		RZ					; Yes, exit
		CALL UART_OUT		; Output the character
		JMP	PRINT_STRING	; And proceed

; Blocking print character to UART
UART_OUT:
		PUSH	PSW			; Save char
OUT1:
		IN	9				; Get 8251 status
		RRC					; Test TX bit
		JNC	OUT1			; Not ready
		POP	PSW				; Restore char
		OUT	8				; Write 8251 data
		RET

UART_INIT:
		XRA	A				; Insure not setup mode
		OUT	9				; Write once
		OUT	9				; Write again (now in operate mode)
		OUT	9				; Write again (now in operate mode)
		MVI	A,01000000b		; Reset
		OUT	9				; write it
		MVI	A,01001110b		; 8 data, 1 stop, x16
		OUT	9				; Write it
		MVI	A,00110111b		; RTS,DTR,Enable RX,TX
		OUT	9				; Write it
		RET

IN:
		IN	9				; Get 8251 status
		ANI	00000010b		; Test for ready
		RZ					; No char
		IN	8				; Get 8251 data
		RET

CHECK:						; Check the flag input
		PUSH PSW			; save A + PSW
		PUSH H				; save HL
		PUSH D				; save DE
		LXI H, CHECK_END
		PUSH H				; Push the CHECK_END pointer to stack for eventual return
		; MVI A, "-"
		; CALL UART_OUT
		LDA DATA_IN			; Load the input character
		ANI 7Fh				; Clear high bit
		RLC					; Rotate left, multiply by 2
		LXI H, TABLE		; load table high address
		MOV L, A			; set the low address
		MOV E, M			; Load the jump address from the table, low byte
		INR L
		MOV D, M			; High byte
		XCHG				; Swap DE and HL
		PCHL				; Jump to HL

CHECK_END:
		POP D
		POP H
		POP PSW
		RET

; DISOBEY[INTERRUPTS AND SWITCH]
; D  I  S  O  B  E  Y  [  I  N  T  E  R  U  P  T  S     A  N  D     S  W  I  T  C  H  ]
; x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x
; 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11 12 13 14 15 16 17 18 19 1A 1B 1c 1d

C_Y:
	LDA COUNTER
	CPI 07h
	JZ OK
	JMP ERROR

C_W:
	LDA COUNTER
	CPI 18h
	JZ OK
	JMP ERROR

C_N:
	LDA COUNTER
	CPI 0Ah
	JZ OK
	CPI 14h
	JZ OK
	JMP ERROR

C_O:
	LDA COUNTER
	CPI 04h
	JZ OK
	JMP ERROR

C_S:
	LDA COUNTER
	CPI 03h
	JZ OK
	CPI 11h
	JZ OK
	CPI 17h
	JZ OK
	JMP ERROR

C_P:
	LDA COUNTER
	CPI 0fh
	JZ OK
	JMP ERROR

C_U:
	LDA COUNTER
	CPI 0eh
	JZ OK
	JMP ERROR

C_Bracket_Open:
	LDA COUNTER
	CPI 08h
	JZ OK
	JMP ERROR

C_R:
	LDA COUNTER
	CPI 0dh
	JZ OK
	JMP ERROR

C_C:
	LDA COUNTER
	CPI 1bh
	JZ OK
	JMP ERROR

SPACE:
	LDA COUNTER
	CPI 12h
	JZ OK
	CPI 16h
	JZ OK
	JMP ERROR

C_T:
	LDA COUNTER
	CPI 0bh
	JZ OK
	CPI 10h
	JZ OK
	CPI 1ah
	JZ OK
	JMP ERROR

C_Bracket_Close:
	LDA COUNTER
	CPI 1dh
	JZ ALL_OK
	JMP ERROR

C_H:
	LDA COUNTER
	CPI 1ch
	JZ OK
	JMP ERROR

C_I:
	LDA COUNTER
	CPI 02h
	JZ OK
	CPI 09h
	JZ OK
	CPI 19h
	JZ OK
	JMP ERROR

C_B:
	LDA COUNTER
	CPI 05h
	JZ OK
	JMP ERROR

C_K:
C_J:
	LDA COUNTER
	CPI 25h
	JZ OK
	CPI 27h
	JZ OK
	JMP ERROR

C_E:
	LDA COUNTER
	CPI 06h
	JZ OK
	CPI 0ch
	JZ OK
	JMP ERROR

C_D:
	LDA COUNTER
	CPI 01h
	JZ OK
	CPI 15h
	JZ OK
	JMP ERROR

C_A:
	LDA COUNTER
	CPI 13h
	JZ OK
	JMP ERROR

C_G:
C_F:
	LDA COUNTER
	CPI 23h
	JZ OK
	JMP ERROR

C_L:
C_M:
C_Q:
C_V:
C_X:
C_Z:
		CALL ERROR

		MVI A, '.'
		CALL UART_OUT
		RET

OK:
		MVI A, '.'
		CALL UART_OUT
		RET


		ORG BASE + 1000h


TABLE:						; Ascii offsets multiplied by two to get a vector address
	DW 32 DUP (ERROR)		; 0x00 - 0x1f
	DW SPACE
	DW 32 DUP (ERROR)		; 0x21 - 0x40
	DW C_A
	DW C_B
	DW C_C
	DW C_D
	DW C_E
	DW C_F
	DW C_G
	DW C_H
	DW C_I
	DW C_J
	DW C_K
	DW C_L
	DW C_M
	DW C_N
	DW C_O
	DW C_P
	DW C_Q
	DW C_R
	DW C_S
	DW C_T
	DW C_U
	DW C_V
	DW C_W
	DW C_X
	DW C_Y
	DW C_Z
	DW C_Bracket_Open
	DW ERROR
	DW C_Bracket_Close
	DW 256 DUP (ERROR)



