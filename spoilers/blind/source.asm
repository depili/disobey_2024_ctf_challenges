	CPU 8085
	ORG 0000h


C_c	EQU	8
C_u	EQU	9
C_s	EQU	10
C_t	EQU	11
C_o	EQU	12
C_m	EQU	13
C_h	EQU	14
C_a	EQU	15

; USART registers
USART_DATA	EQU	08h
USART_CMD	EQU	09h

START:	LXI	SP, 0C000h		; Initial stack address
	CALL	USART_INIT		; Initialize the 8251A UART
	CALL	LCD_INIT
	CALL	INIT_CGRAM
	CALL	LCD_OUT
	RST	1


LCD_INIT:
	MVI	A, 38h
	OUT	20h
	CALL	DELAY
	MVI	A, 00001100b
	OUT	20h
	CALL	DELAY
	MVI	A, 1
	OUT	20h
	CALL	DELAY
	RET

INIT_CGRAM:
	MVI	A, 40h		; Set cgram address 0
	OUT	20h
	CALL	DELAY
	MVI	B, 8*8		; Size of cgram data
	LXI	H, cgram
.loop:
	MOV	A, M
	OUT	21h
	CALL	DELAY
	INX	H
	DCR	B
	JNZ	.loop
	RET

LCD_OUT:
	MVI	A, 80h
	OUT	20h
	CALL	DELAY
	LXI	H, flag
.loop1:
	MOV	A, M
	ANA	A
	JZ	.row2
	INX	H
	OUT	21h
	CALL	DELAY
	JMP	.loop1
.row2:
	MVI	A, 80h + 40h	; Goto second row
	OUT	20h
	CALL	DELAY
	INX	H
.loop2:
	MOV	A, M
	ANA	A
	JZ	.return
	OUT	21h
	INX	H
	CALL	DELAY
	JMP	.loop2
.return:
	RET


USART_INIT:
	XRA	A		; Insure not setup mode
	OUT	9		; Write once
	OUT	9		; Write again (now in operate mode)
	OUT	9		; Write again (now in operate mode)
	MVI	A,01000000b	; Reset
	OUT	9		; write it
	MVI	A,01001110b	; 8 data, 1 stop, x16
	OUT	9		; Write it
	MVI	A,00110111b	; RTS,DTR,Enable RX,TX
	OUT	9		; Write it
	RET

; Read character from USART
USART_IN:
	IN USART_CMD		; Read USART status
	ANI 2			; Test RxRdy bit
	JZ USART_IN		; Wait for the data
	IN USART_DATA		; Read character
	RET

; Write character to USART
USART_OUT:
		PUSH	PSW 	; Save char
OUT1:
	IN	9		; Get 8251 status
	RRC			; Test TX bit
	JNC	OUT1		; Not ready
	POP	PSW		; Restore char
	OUT	8		; Write 8251 data
	RET
; Display message [HL]
;
PRTSTR:
	MOV	A,M		; Get byte from message
	INX	H		; Advance to next
	ANA	A		; End of message?
	RZ			; Yes, exit
	CALL	USART_OUT	; Output the character
	JMP	PRTSTR		; And proceed

PRINT_MSG:
	POP	H
	CALL	PRTSTR
	PCHL

DELAY:
	PUSH	B		; save BC
	PUSH	PSW
	LXI	B, 1000h	; clear BC
.loop:				; delay loop
	DCX	B		; decrement BC
	MOV	A, B
	ORA	C
	JNZ	.loop		; if not zero loop again
	POP	PSW
	POP	B		; restore BC
	RET			; return



cgram:
.c:
	DB 	00000b
	DB	00000b
	DB	01110b
	DB	10000b
	DB	10000b
	DB	10001b
	DB	01110b
	DB	00000b
.u:
	DB	00000b
	DB	00000b
	DB	10001b
	DB	10001b
	DB	10001b
	DB	10011b
	DB	01101b
	DB	00000b
.s:
	DB	00000b
	DB	00000b
	DB	01110b
	DB	10000b
	DB	01110b
	DB	00001b
	DB	11110b
	DB	00000b
.t:
	DB	01000b
	DB	01000b
	DB	11100b
	DB	01000b
	DB	01000b
	DB	01001b
	DB	00110b
	DB	00000b
.o:
	DB	00000b
	DB	00000b
	DB	01110b
	DB	10001b
	DB	10001b
	DB	10001b
	DB	01110b
	DB	00000b
.m:
	DB	00000b
	DB	00000b
	DB	11010b
	DB	10101b
	DB	10101b
	DB	10001b
	DB	10001b
	DB	00000b
.h:
	DB	10000b
	DB	10000b
	DB	10110b
	DB	11001b
	DB	10001b
	DB	10001b
	DB	10001b
	DB	00000b
.a:
	DB	00000b
	DB	00000b
	DB	01110b
	DB	00001b
	DB	01111b
	DB	10001b
	DB	01111b
	DB	00000b

flag:
;		            c    u    s    t    o    m
	DB	"DISOBEY(", C_c, C_u, C_s, C_t, C_o, C_m, 0
;		c    h    a    r    a    c   t     er    s      r   u   le
	DB	C_c, C_h, C_a, "r", C_a, C_c, C_t, "er", C_s, " r", C_u, "le)",0
