	CPU 8085

BASE EQU 0h
INPUT EQU 0BF00h
STACK EQU 0C000h

	ORG BASE

	DI
	JMP START

	ORG BASE+100h
START:
    LXI H, INPUT		; clear memory 0xb000 - 0xffff
    MVI A, 0
    MVI B, 0ffh
m_c:
	MOV M, A
	INX H
	DCR B
	CMP B
	JNZ m_c
	LXI H, STACK
    SPHL				; set the stack pointer
    CALL UART_INIT		; init the UART
    LXI H, banner
    CALL PRINT_STRING
    CALL READ_PW		; read the password inpu
    JC ERROR			; if error print error message and restart
    CALL CHECK_PW		; check the password
    JC ERROR			; if error print error message and restart
    CALL PRINT_FLAG1	; print flag1
    JMP START			; restart
error:
	CALL PRINT_ERROR	; print error message
	JMP START			; restart

PRINT_ERROR:
	LXI H, ERROR_MSG
	JMP PRINT_STRING

PRINT_FLAG1:
	LXI H, FLAG1
	JMP PRINT_STRING

PRINT_FLAG2:
	LXI H, FLAG2
	JMP PRINT_STRING

CHECK_PW
	LXI H, PW			; load HL = stored PW
	LXI D, INPUT		; load DE = input buffer
pw_loop:
	MOV A, M			; load A from PW
	XCHG				; Exchange HL and DE
	MOV B, M			; load B from input
	XCHG				; exchange HL and DE
	ANA A				; check A for zero
	JZ RET_OK			; if so, return OK
	CMP B				; compare A and B
	JNZ RET_ERR			; if not zero return error
	INX H				; increment HL
	INX D				; increment DE
	CALL DELAY			; do a delay
	JMP pw_loop			; loop again

DELAY:
	PUSH B		; save BC
	PUSH PSW
	LXI B, 4000h	; clear BC
d_loop:			; delay loop
	DCX B		; decrement BC
	MOV A, B
	ORA C
	JNZ d_loop	; if not zero loop again
	POP PSW
	POP B		; restore BC
	RET			; return

READ_PW:
	LXI H, INPUT	; set HL to input buffer
in_loop:
	CALL UART_IN	; get a character from the UART
	CPI "\r"		; compare the character to \n
	JZ RET_OK		; if so, return ok
	MOV M, A		; store the character
	INX H			; increment HL
	CALL STRLEN		; check the length
	CPI 16			; compare it to 16
	JNC RET_ERR		; if over return error
	JMP in_loop		; continue loop
RET_ERR:
	STC				; set carry flag
	RET				; return
RET_OK:
	STC				; set carry flag
	CMC				; complement carry flag
	RET				; return

STRLEN:
	PUSH H			; save HL
	PUSH B			; save BC
	LXI B, 0		; clear BC
	LXI H, INPUT	; load buffer address
LOOP:
	MOV A, M		; Load A from HL
	ANA A			; check for zero
	JZ RET			; if zero return
	INX H			; increment HL
	INR B			; increment BC
	MOV A, B
	CPI 32			; compare to 32
	JNC RET			; if over return
	JMP LOOP		; loop again
RET:
	MOV A, B		; set return value
	POP B			; restrore BC
	POP H			; restore HL
    RET				; return

; Display message [HL]
;
PRINT_STRING:
		MOV	A,M				; Get byte from message
		INX	H				; Advance to next
		ANA	A				; End of message?
		RZ					; Yes, exit
		CALL UART_OUT		; Output the character
		JMP	PRINT_STRING	; And proceed

; Blocking read character from UART
UART_IN:
	IN	9			; Get 8251 status
	ANI	00000010b	; Test for ready
	JZ UART_IN		; No char
	IN	8			; Get 8251 data
	RET

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


	ORG BASE + 1000h
PW:	DB "teddybear",0

	ORG BASE + 1100h
flag1:	DB "\n\nDISOBEY[Great timing there dude]\n",0

	ORG BASE + 1200h
flag2:	DB "\n\nDISOBEY[Oh, you could jump here?]\n",0

	ORG BASE + 1300h
flag3:	DB "\n\nDISOBEY[RCE is still the king baby!]\n",0

	ORG BASE + 1400h
ERROR_MSG: DB "\nPassword error!\n\n", 0

	ORG BASE + 1500h
banner:
	DB "( ) ) /  \\( )( )( )( )/  \\ / __)(_  _)/  \\   (_  _)(  _)(  )  (  _) / _)/  \\(  \\/  )\n"
 	DB " )  \\( () ))()(  \\\\//( () )\\__ \\  )( ( () )    )(   ) _) )(__  ) _)( (_( () ))    (\n"
	DB "(_)\\_)\\__/ \\__/  (__) \\__/ (___/ (__) \\__/    (__) (___)(____)(___) \\__)\\__/(_/\\/\\_)\n"
	DB "\n"
    DB "                        SECURE UNIQUE CRYPTOGRAPHIC KEY SYSTEM (SUCKS)\n"
    DB "                        WITH MILITARY GRADE ANTI BRUTE FORCE SECURITY\n"
    DB "\n"
    DB "Enter password:\n"
    DB 0

    ORG BASE + 5c3dh
    DB "DISOBEY[look at you hacker. How can you challenge a perfect, immortal machine?]",0
