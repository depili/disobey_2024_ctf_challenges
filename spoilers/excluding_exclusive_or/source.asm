				CPU 8085
				ORG 8000h

; USART registers
USART_DATA     EQU     08h
USART_CMD      EQU     09h

START:	LXI H,0C000h		; Initial stack address
		SPHL				; Load it into stack pointer
        CALL USART_INIT		; Initialize the 8251A UART
		CALL PRINT_ENC		; Print the first block, a Kouvosto Telecom banner
		DB 004h, 01ch, 066h, 0f9h, 0bdh, 063h, 04bh, 0d5h, 0b5h, 0aah, 0c5h, 09ah, 06ah, 0b6h, 069h, 0b7h
		DB 0b3h, 06dh, 0d4h, 04ch, 010h, 010h, 0b7h, 069h, 0eah, 036h, 070h, 0b0h, 0fah, 026h, 079h, 0a7h
		DB 055h, 0cbh, 0c1h, 05fh, 0b2h, 06eh, 0f4h, 02ch, 038h, 0e8h, 039h, 0e7h, 096h, 08ah, 097h, 089h
		DB 01dh, 003h, 063h, 0bdh, 083h, 09dh, 087h, 099h, 0d9h, 047h, 057h, 0c9h, 03ch, 0e4h, 0efh, 031h
		DB 099h, 0c6h, 05bh, 0c5h, 022h, 0feh, 018h, 008h, 0d9h, 047h, 090h, 090h, 089h, 097h, 0ach, 074h
		DB 041h, 0dfh, 0cfh, 051h, 094h, 08ch, 0d4h, 08bh, 0bah, 0a5h, 0e9h, 076h, 0f7h, 068h, 092h, 0cdh
		DB 0ebh, 035h, 089h, 097h, 0d9h, 047h, 06ch, 0b4h, 09ah, 0c5h, 0c2h, 048h, 040h, 03ch, 088h, 098h
		DB 0fch, 080h, 0eah, 045h, 06ah, 0b6h, 092h, 09dh, 0b4h, 0abh, 04fh, 010h, 03fh, 020h, 00eh, 012h
		DB 0e0h, 040h, 0a4h, 0bbh, 0a1h, 07fh, 090h, 090h, 0d8h, 048h, 06dh, 0f2h, 013h, 04ch, 01ah, 045h
		DB 007h, 019h, 085h, 09bh, 07ah, 0a6h, 029h, 036h, 052h, 00dh, 082h, 0ddh, 057h, 008h, 01dh, 042h
		DB 0abh, 075h, 0ach, 074h, 0edh, 072h, 05eh, 001h, 02ch, 033h, 00dh, 06fh, 0c5h, 05bh, 063h, 019h
		DB 074h, 0ebh, 0ceh, 052h, 0e0h, 07fh, 042h, 01dh, 087h, 0d8h, 032h, 0eeh, 0e7h, 039h, 0fdh, 023h
		DB 02fh, 04dh, 09bh, 0c4h, 0beh, 062h, 004h, 01ch, 0e2h, 03eh, 045h, 01ah, 035h, 047h, 08eh, 0d1h
		DB 094h, 0cbh, 0adh, 0cfh, 077h, 0a9h, 052h, 02ah, 081h, 09fh, 02ch, 033h, 0b4h, 0abh, 0cch, 093h
		DB 07ch, 0a4h, 097h, 089h, 00ah, 055h, 093h, 0cch, 0e5h, 07ah, 086h, 09ah, 0f7h, 068h, 038h, 027h
		DB 0c5h, 09ah, 008h, 018h, 01fh, 001h, 0dch, 083h, 082h, 09eh, 0afh, 0b0h, 0a1h, 0beh, 080h, 0a0h
		DB 099h, 0c6h, 0a6h, 0b9h, 0f8h, 067h, 035h, 0d5h, 0bdh, 0bfh, 079h, 0a7h, 007h, 020h, 0cdh, 053h
		DB 03fh, 0f0h, 092h, 09dh, 063h, 0bdh, 052h, 00dh, 04ch, 0d4h, 045h, 017h, 0fdh, 07fh, 09ah, 086h
		DB 042h, 03ah, 0ddh, 043h, 006h, 076h, 0beh, 062h, 03fh, 01dh, 0fch, 024h, 029h, 033h, 0cah, 056h
		DB 097h, 098h, 07bh, 0a5h, 02fh, 000h, 04eh, 0d2h, 0e8h, 077h, 0d8h, 048h, 004h, 058h, 018h, 017h
		DB 0cbh, 055h, 079h, 0e6h, 004h, 05bh, 0e9h, 093h, 054h, 0cch, 0b5h, 0aah, 0d0h, 08fh, 0b6h, 079h
		DB 058h, 0c8h, 009h, 056h, 0f9h, 027h, 0e5h, 077h, 081h, 09fh, 02eh, 0f2h, 0a6h, 07ah, 08bh, 095h
		DB 0fbh, 081h, 0cch, 054h, 039h, 043h, 088h, 0a7h, 0bah, 066h, 03dh, 022h, 020h, 000h, 00bh, 051h
		DB 04fh, 0d1h, 051h, 02bh, 090h, 09fh, 0ffh, 021h, 0ebh, 074h, 0f6h, 02ah, 039h, 023h, 0e0h, 04fh
		DB 0a6h, 07ah, 013h, 04ch, 0fch, 063h, 016h, 019h, 081h, 09fh, 089h, 0d6h, 03dh, 0e3h, 032h, 02ah
		DB 0c9h, 0b3h, 05ah, 0c6h, 033h, 0f4h, 0a9h, 0b6h, 083h, 09dh, 0c6h, 09ah, 014h, 00ch, 067h, 0f8h
		DB 0cch, 054h, 01bh, 041h, 013h, 0f7h, 0b3h, 0c9h, 068h, 0b8h, 080h, 0aeh, 0bah, 066h, 0e5h, 077h
		DB 0bbh, 065h, 00ch, 01ch, 0d1h, 08eh, 0d4h, 055h, 0a1h, 07fh, 0f3h, 089h, 052h, 0ceh, 0e8h, 094h
		DB 00fh, 050h, 02ch, 050h, 05dh, 0c3h, 0a5h, 0d7h, 0c3h, 099h, 088h, 098h, 034h, 022h, 07dh, 0a3h
		DB 0f2h, 03dh, 096h, 08ah, 06dh, 0bbh, 05eh, 001h, 090h, 099h, 01ch, 004h, 079h, 0e3h, 0b8h, 0a7h
		DB 034h, 02bh, 0aah, 076h, 0bah, 0a2h, 087h, 099h, 0b4h, 0c8h, 0a9h, 0d3h, 077h, 0a9h, 055h, 0d3h
		DB 0cbh, 094h, 0cbh, 05eh, 0f3h, 02dh, 067h, 015h, 06ah, 0b6h, 0a7h, 079h, 0e9h, 037h, 0cah, 0b2h
		DB 0e5h, 03bh, 000h, 07ch, 02dh, 0f3h, 0ffh, 021h, 049h, 016h, 0bdh, 0a2h, 01bh, 014h, 04fh, 0d1h
		DB 0f4h, 088h, 0e5h, 03bh, 049h, 0d7h, 085h, 0dah, 01dh, 042h, 0f6h, 039h, 00fh, 011h, 02eh, 0fah
		DB 0c4h, 09bh, 08ch, 0f0h, 005h, 01bh, 020h, 008h, 0cfh, 090h, 049h, 0e0h, 068h, 0b8h, 0e9h, 093h
		DB 075h, 0abh, 0e7h, 095h, 095h, 08bh, 00eh, 06eh, 081h, 09fh, 0c6h, 0b6h, 0aeh, 072h, 04fh, 02dh
		DB 0f8h, 028h, 08ah, 0f2h, 085h, 085h, 091h, 0ebh, 07bh, 0e4h, 070h, 00ch, 03dh, 01fh, 074h, 0ebh
		DB 0bdh, 09fh, 017h, 048h, 02ch, 033h, 0d0h, 08fh, 00bh, 024h, 0e2h, 03eh, 052h, 00ah, 08eh, 0d1h
		DB 01ch, 043h, 0cah, 062h, 023h, 03ch, 0f4h, 088h, 09fh, 081h, 062h, 0fah, 0fbh, 064h, 078h, 0b7h
		DB 054h, 0cch, 007h, 055h, 014h, 04bh, 06bh, 0f4h, 0edh, 072h, 0a1h, 08eh, 004h, 078h, 0a7h, 0b8h
		DB 0a5h, 0bah, 0efh, 070h, 079h, 0b6h, 081h, 0dbh, 0e5h, 07ah, 05dh, 002h, 007h, 055h, 081h, 0deh
		DB 021h, 03eh, 0bfh, 0a0h, 08dh, 0a2h, 0feh, 022h, 0f5h, 02bh, 0e2h, 03eh, 0a7h, 079h, 015h, 067h
		DB 0f0h, 06fh, 0dah, 0a2h, 047h, 015h, 072h, 0edh, 0e0h, 07fh, 0c7h, 098h, 0eah, 092h, 0cdh, 092h
		DB 095h, 0e7h, 0d2h, 08ah, 04fh, 010h, 008h, 057h, 0e9h, 076h, 098h, 0e4h, 0edh, 06fh, 05bh, 004h
		DB 03bh, 024h, 0f8h, 067h, 086h, 0d6h, 0d2h, 08dh, 06eh, 0f1h, 041h, 01eh, 027h, 008h, 09ah, 0e2h
		DB 088h, 0d7h, 0e3h, 099h, 0e2h, 03eh, 046h, 036h, 030h, 02fh, 074h, 008h, 059h, 0c7h, 094h, 0e8h
		DB 0f5h, 06ah, 0d9h, 0a3h, 0afh, 05bh, 03dh, 0cdh
		DB 42			; End of data marker
		JMP FLAG		; Jump to the flag printing code

PRINT_ENC_STR_2:		; Second de-encryption routine, uses different end marker
		POP H			; Take the return address from the stack
LOOP:
		MOV	A,M			; Get byte from message
		INX	H			; Advance to next
		CPI 42h			; Compare to end marker
		JZ END			; Yes, exit
		ADD M			; Add the next byte to the previous
		INX H			; Advance to next
		CALL USART_OUT	; Output the character
		JMP	LOOP		; And proceed
END:	PCHL			; Continue execution from the next byte
FLAG:
		CALL PRINT_ENC_STR_2
		DB 007h, 03dh, 0d7h, 098h, 0ceh, 052h, 014h, 05ah, 07eh, 0f1h, 030h, 044h, 0a6h, 07ah, 07ah, 0f6h
		DB 04fh, 023h, 068h, 007h, 0deh, 098h, 0fbh, 06eh, 054h, 010h, 022h, 043h, 026h, 0fah, 04ch, 028h
		DB 0e3h, 085h, 0c7h, 09eh, 088h, 098h, 088h, 0e8h, 087h, 0dah, 04ah, 029h, 029h, 04ah, 031h, 046h
		DB 017h, 058h, 01eh, 054h, 029h, 03bh, 019h, 007h, 0cah, 0aah, 0e9h, 086h, 04bh, 0d5h, 029h, 018h
		DB 010h, 058h, 010h, 066h, 096h, 0cfh, 0b7h, 0b7h, 081h, 0a0h, 09ah, 070h, 061h, 0e3h, 0fdh, 04ch
		DB 064h, 0efh, 097h, 0b8h, 001h, 041h, 089h, 0bch, 01bh, 03eh, 007h, 054h, 0f1h, 070h, 0e8h, 080h
		DB 051h, 025h, 09bh, 0cah, 01fh, 04fh, 04fh, 0d1h, 05dh, 00ch, 0deh, 095h, 04eh, 0d2h, 05ch, 00ah
		DB 0d1h, 09eh, 0c6h, 0ach, 0dbh, 045h, 0b5h, 0b7h, 08bh, 0d6h, 021h, 04ch, 05ah, 00bh, 0dfh, 041h
		DB 0fbh, 078h, 00bh, 060h, 089h, 0e9h, 0d7h, 092h, 017h, 059h, 059h, 01bh, 033h, 0edh, 014h, 057h
		DB 072h, 0f7h, 08ah, 0dah, 06eh, 0f6h, 056h, 013h, 064h, 001h, 0efh, 084h, 085h, 0d8h, 02eh, 0dch
		DB 42h
       RST 1

USART_INIT:
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

; Read character from USART
USART_IN:
		IN USART_CMD	; Read USART status
        ANI 2			; Test RxRdy bit
   		JZ USART_IN		; Wait for the data
   		IN USART_DATA	; Read character
   		RET

; Write character to USART
USART_OUT:
		PUSH	PSW 	; Save char
OUT1:
		IN	9			; Get 8251 status
		RRC				; Test TX bit
		JNC	OUT1		; Not ready
		POP	PSW			; Restore char
		OUT	8			; Write 8251 data
		RET
; Display message [HL]
;
PRTSTR:
		MOV	A,M			; Get byte from message
		INX	H			; Advance to next
		ANA	A			; End of message?
		RZ				; Yes, exit
		CALL USART_OUT	; Output the character
		JMP	PRTSTR		; And proceed

PRINT_MSG:
		POP H
		CALL PRTSTR
		PCHL

PRINT_ENC_STR:
		MOV	A,M			; Get byte from message
		INX	H			; Advance to next
		CPI 42
		RZ				; Yes, exit
		ADD M
		INX H
		CALL USART_OUT	; Output the character
		JMP	PRINT_ENC_STR	; And proceed


PRINT_ENC:
		POP H
		CALL PRINT_ENC_STR
		PCHL
BANNER:
		DB "Consider trying harder!\n",0