	CPU 8085UNDOC

BASE EQU 0000h
STACK EQU 0c000h

LED EQU 0e000h

	ORG BASE

	DI
	JMP START

	ORG BASE+100h
START:
	LXI SP, STACK
	; CALL UART_INIT
	CALL LED_OFF
	CALL DELAY
	CALL DELAY
	CALL DELAY

	LXI H, FLAG
tx_loop:
	MOV A, M
	ANA A
	JZ end
	RLC
	MVI B, 7
tx_inner:
	RLC
	CC LED_TOGGLE
	; CC OUT_1
	; CNC OUT_0
	CALL DELAY
	CALL LED_TOGGLE
	CALL DELAY
	DCR B
	JNZ tx_inner
	; CALL OUT_SPACE
	INX H
	JMP tx_loop

end:
	JMP START


; OUT_1:
; 	PUSH PSW
; 	MVI A, "1"
; 	CALL UART_OUT
; 	POP PSW
; 	RET
;
; OUT_0
; 	PUSH PSW
; 	MVI A, "0"
; 	CALL UART_OUT
; 	POP PSW
; 	RET
;
; OUT_SPACE
; 	PUSH PSW
; 	MVI A, " "
; 	CALL UART_OUT
; 	POP PSW
; 	RET
;
; LED_ON:
; 	PUSH PSW
; 	MVI A, 11000000b
; 	STA LED
; 	SIM
; 	POP PSW
; 	RET
;
LED_OFF:
 	PUSH PSW
 	MVI A, 01000000b
 	STA LED
 	SIM
 	POP PSW
 	RET

LED_TOGGLE:
	PUSH PSW
	PUSH B
	MVI B, 80h
	LDA LED
	XRA B
	STA LED
	SIM
	POP B
	POP PSW
	RET

DELAY:
	PUSH PSW
	PUSH B
	LXI B, 4000h
loop:
	DCX B
	MOV A, B
	ORA C
	JNZ loop
	POP B
	POP PSW
	RET

FLAG:
	DB "SecretData",0


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

