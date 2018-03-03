;*******************************************************************************
;                                                                              *
;    Filename:LED Routines for 16F family running at 8MHz                                                    
;    Author: Aaron Walker                                                      
;    Description: Building initial routines                                                    
;                                                                              
;*******************************************************************************

#include "p16f18346.inc"
    errorlevel	-302		;no warnings about registers not in bank 0
    errorlevel	-312		; no "page or bank selection not needed" messages
    
    GLOBAL  lcd_init
    GLOBAL  lcd_reset
    GLOBAL  send_data
    GLOBAL  send_ins		; send instruction
    
    EXTERN  delay10
    EXTERN  delay01	    
;********** VARIABLE DEFINITIONS
	    UDATA
tmp_data    res	1	    
    
;Pin Assignments
;********** VARIABLE DEFINITIONS
#define    LCD_DATA	LATB
#define    LCD_EN	LATC, 0
#define    LCD_RS	LATC, 1 

; Constants this is going to be where the commands for the LCD are listed
    constant	func_set_4b =	b'00100000'	;set commsfor 2 line 4 bit mode
    constant    clr_dspl = 	b'00000001'	; clear display    
    constant    rtn_home = 	b'00000010'	; move cursor to home
    constant    line_1 = 	b'10000000'	;select line 1
    constant    line_2 = 	b'11000000'	;select line 2
;***** SUBROUTINES ****************************************************** 
    CODE
;************
;   lcd_init initialises the LCD by waiting for 20ms then calls lcd_reset
;    which sets up the lcd to be used in 4 bit mode
;    
lcd_init
	    movlw	.2		    ;need to wait 20ms so that lcd power
	    pagesel	delay10		    ; can stabilise
	    call	delay10
	    goto	lcd_reset
	    
	    return
lcd_reset   
	    movlw	0x30		    ; initial init value
	    pagesel	send_ins
	    call	send_ins
	    movlw	.1		    ; delay for 10ms
	    pagesel	delay10	    
	    call	delay10
	    movlw	0x30		    ; send init value
	    pagesel	send_ins
	    call	send_ins
	    movlw	.1
	    pagesel	delay01
	    call	delay01
	    movlw	0x30
	    pagesel	send_ins
	    call	send_ins
	    movlw	.1
	    pagesel	delay01
	    call	delay01
	    movlw	0x28		; select bus width of 4 bits
	    pagesel	send_ins
	    call	send_ins	; send instruction
	    movlw	.1
	    pagesel	delay01	    
	    call	delay01		; delay 1 ms
	    
	    return
;********************************************************************
; send_data takes the data from tmp_data and sends it to the LCD	    
send_data   movwf	tmp_data
	    andlw	0xF0		; clear the Least Sig 4 bits 0
	    movwf	LCD_DATA	; place MSB of data onto data bus
	    bsf		LCD_RS	; set RS to 1 to indicate data trans
	    bsf		LCD_EN	; pulse the LCD_EN pin on
	    bcf		LCD_EN	; and off
	    swapf	tmp_data,w	; swap the LSB to MSB
	    andlw	0xF0		 ; clear the 4 LS bits
	    movwf   	LCD_DATA	; place the data onto the bus
	    bsf		LCD_RS
	    bsf		LCD_EN
	    bcf		LCD_EN
 		
	    return
;******************************************************************************
; send instruction; collects the instruction from tmp_data then sends
send_ins    movwf	tmp_data    
	    andlw	0xF0		;clear the least sig 4 bits
	    movwf	LCD_DATA	; place MSB of data on to data bus
	    bcf		LCD_RS	; set RS to 0 set for instruction
	    bsf		LCD_EN	; start pulse of LCD_EN pin
	    bcf		LCD_EN	; finish pulse of LCD_EN pin
	    swapf	tmp_data,w	; swap the 4 LSB to the 4 MSB
	    andlw	0xF0		; '11110000' clear the 4 LSB
	    movwf	LCD_DATA	; place command onto data bus
	    bcf		LCD_RS ; set RS to 0 to indicate command
	    bsf		LCD_EN	; start LCD_EN pulse
	    bcf		LCD_EN	; end LCD_EN pulse
	    	
	    return
;******************************************************************************	    
	    
	
    END   
