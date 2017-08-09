;*******************************************************************************
;                                                                              *
;    Filename:Delay Routines for 16F family running at 8MHz                                                    
;    Author: Aaron Walker                                                      
;    Description: Building initial delay routines                                                    
;                                                                              
;*******************************************************************************

#include "p16f18346.inc"
	   GLOBAL   delay10
	   GLOBAL   delay01
   
;********** VARIABLE DEFINITIONS
	    UDATA
dc1	    res 1	;inner loop
dc2	    res 1	; outer loop    
dc3	    res	1	;variable to count the repititon on milli seconds

	    
;*******SUBROUTINES**********************************************************
;
;  Description:  Nx10ms delay passing parameter  This dealy can do max
;		 10ms - 2.55s
;		Affects: W, STATUS and BSR	    
;*****************************************************************************
    CODE
	    
delay10
	    banksel	dc1		; need to add comments to the loops to make
	    movwf	dc3		; it easy to see wtf I am doing
delay_1	    movlw	.158
	    movwf	dc1
	    movlw	.16
	    movwf	dc2
delay_0	    decfsz	dc1,f
	    goto	$+2
	    decfsz	dc2,f
	    goto	delay_0
	    nop
	    decfsz	dc3
	    goto	delay_1
	    
	    return
;*******DELAY01**********************************************************
;
;  Description:  about Nx250us delay passing parameter.
;		 Including the call the routine does 2006 instruction cycles
;		 which is 250.75us.  Should be accurate enough.  At 1ms the 
;	         routine does  8009ic's (1.001125 ms)	    
;		Affects: W, STATUS and BSR	    
;******************************	
delay01
	    banksel	dc1
	    movwf	dc3
delay01_0	    
	    movlw	.143
	    movwf	dc1
	    movlw	.2
	    movwf	dc2
delay01_1	
	    decfsz	dc1,f
	    goto	$+2
	    decfsz	dc2,f
	    goto	delay01_1
	 
	    decfsz	dc3
	    goto	delay01_0
	    
	    return
	    
	return
	
	
	
	
    END