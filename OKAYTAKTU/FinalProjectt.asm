#include<p18F4550.inc>

increment	set	0x00
loop_cnt1	set	0x01
loop_cnt2	set	0x02

		org 0x00
 		goto start
 		org 0x08
 		retfie
 		org 0x18
 		retfie

;***************************************
;Subroutine for SOUND
;***************************************

buzzer		BSF	PORTC, 2, A
			CALL	DELAY
			BCF	PORTC, 2, A
			CALL	DELAY
			RETURN

;***************************************
;reset the values
;**************************************

MakeItZero	SETF	PORTD, A
			CALL	buzzer
			CLRF	PORTD, A
			CLRF	increment, A
			RETURN

;***************************************
;Subroutine for 1sec delay
;***************************************

dup_nop			macro num
			variable i
i = 0
			while i < num
			nop
i += 1
			endw
			endm

DELAY		MOVLW	D'40'			;0.5sec delay subroutine for
			MOVWF	loop_cnt1, A	;20MHz crystal frequency
AGAIN1		MOVLW	D'250'
			MOVWF	loop_cnt2, A
AGAIN2		dup_nop	D'247'
			DECFSZ	loop_cnt2, F, A
			BRA		AGAIN2
			DECFSZ	loop_cnt1, F, A
			BRA		AGAIN1
			NOP
			RETURN

;***************************************
;My Main Program
;***************************************

start		SETF	TRISB, A		;button
			CLRF	TRISE, A		;7-seg
			CLRF	TRISD, A		;LED
			BCF		TRISC, 2, A		;buzzer
			BCF		PORTC, 2, A		;off the buzzer
			CLRF	PORTD, A		;clear output at LED
			BSF		PORTE, 0, A		;choose 1 7-seg
			CLRF	increment, A

button1		BTFSC	PORTB, 0, A
			BRA	button2
			CALL	COUNT1
button2		BTFSC	PORTB, 1,A
			BRA	button3
			CALL MakeItZero
button3		BTFSS PORTB,2,A
			CALL COUNT2
			BRA button1

COUNT2		DECF	increment, F, A
			MOVFF	increment, PORTD
			CALL	buzzer
			RETURN


COUNT1		INCF	increment, F, A
			MOVFF	increment, PORTD
			CALL	buzzer
			RETURN
			END

