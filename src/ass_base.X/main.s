PROCESSOR 16F877A

#include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0

max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS

PSECT code

INISYS:
    bcf		STATUS,6	;BK1
    bsf		STATUS,5
    
    bsf		TRISC, 0	        ;PORT (C0) S1 ENTRADA
    bsf		TRISC, 1		;PORT (C1) S2 ENTRADA
    bsf		TRISC, 2		;PORT (C2) S3 ENTRADA
    bsf		TRISC, 3		;PORT (C3) S4 ENTRADA
    bsf		TRISC, 4		;PORT (C4) S5 ENTRADA
    
    bcf		TRISD, 0	        ;PORT (D0) MA1 SALIDA
    bcf		TRISD, 1		;PORT (D1) MA2 SALIDA
    bcf		TRISD, 2		;PORT (D2) MB1 SALIDA
    bcf		TRISD, 3		;PORT (D3) MB2 SALIDA
    bcf		TRISD, 4		;PORT (D4) LAI SALIDA
    bcf		TRISD, 5		;PORT (D5) LAD SALIDA
    bcf		TRISD, 6		;PORT (D6) LRSTP SALIDA	
   
    ;*************************     
    BCF STATUS, 5 ; BK0 
    
   MAIN:
    BCF PORTD,1
    BCF PORTD,2
    BCF PORTD,3
    BCF PORTD,4
    BSF PORTD,5
    BSF PORTD,6
    BSF PORTD,7
    
    GOTO MAIN

    END resetVec