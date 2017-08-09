;*******************************************************************************
;                                                                              *
;    Filename:Delay Routine                                                    
;    Author: Aaron Walker                                                      
;    Description: Building initial delay routines                                                    
;                                                                              
;*******************************************************************************

#include "p16f18346.inc"
    errorlevel	-302		;no warnings about registers not in bank 0
    errorlevel	-303		; no warnings about prgram word to large
    errorlevel	-312		; no "page or bank selection not needed" messages

    EXTERN  delay10
    EXTERN  delay01
    EXTERN  lcd_init
    EXTERN  lcd_reset
    EXTERN  send_data
    EXTERN  send_ins
;;*******  Configuration    
    
; CONFIG1
; __config 0xF78C
 __CONFIG _CONFIG1, _FEXTOSC_OFF & _RSTOSC_HFINT32 & _CLKOUTEN_OFF & _CSWEN_OFF & _FCMEN_OFF
; CONFIG2
; __config 0xFFF3
 __CONFIG _CONFIG2, _MCLRE_ON & _PWRTE_OFF & _WDTE_OFF & _LPBOREN_OFF & _BOREN_ON & _BORV_LOW & _PPS1WAY_ON & _STVREN_ON & _DEBUG_OFF
; CONFIG3
; __config 0x3
 __CONFIG _CONFIG3, _WRT_OFF & _LVP_OFF
; CONFIG4
; __config 0x3
 __CONFIG _CONFIG4, _CP_OFF & _CPD_OFF

;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************
;*******Initialisation
start
	;configure port
	movlw	b'00000000'		;configure PORTB as an OUTPUT
	banksel	TRISB
	movwf	TRISB
	
	; configure oscillator
	movlw	b'00000100'	; select 8MHz manual page 93
	banksel	OSCFRQ
	movwf	OSCFRQ

	
;***** Main Loop
main_loop
	; turn on LED
	banksel LATA
	bcf	LATA,1		; RA1 -> low
	
	movlw	.4
	pagesel	delay01
	call	delay01
	
	
	pagesel	main_loop
	goto	main_loop
	
	call	delay01
	goto	main_loop
	
	
	
    END