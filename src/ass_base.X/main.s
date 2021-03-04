; ******************************************************************************
;           _       _
;     /\   | |     | |
;    /  \  | |_ __ | |__   __ _
;   / /\ \ | | '_ \| '_ \ / _` |
;  / ____ \| | |_) | | | | (_| |
; /_/    \_\_| .__/|_| |_|\__,_|
;            | |
;            |_|
;******************************************************************************
;   Descriptio                                                                *
;                                                                             *
;									      ;
;******************************************************************************
;                                                                             *
;    Filename: Example                                                        *
;    Date:  01.03.21                                                          *
;    File Version: XC, PIC-as 2.31                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;******************************************************************************
;                                                                             *
;    FDEVICE:         P16F877A                                                *
;                                                                             *
;******************************************************************************
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
    PAGESEL main ;jump to the main routine
    goto main

PSECT code

INISYS:
    ;Cambio a Banco N1
    BCF STATUS, 6
    BSF STATUS, 5 ; Bank1
    ; Modificar TRIS
    BSF TRISC, 0    ; PortC0 <- entrada
    BSF TRISC, 1    ; PortC1 <- entrada
    BSF TRISC, 2    ; PortC2 <- entrada
    BSF TRISC, 3    ; PortC3 <- entrada
    BSF TRISC, 4    ; PortC4 <- entrada
    BCF TRISD, 0    ; PortD0 <- salida
    BCF TRISD, 1    ; PortD1 <- salida
    BCF TRISD, 2    ; PortD2 <- salida
    BCF TRISD, 3    ; PortD3 <- salida
    ; Regresar a banco 0

    BCF STATUS, 5 ; Bank0
    MOVLW 0b01010101
    MOVWF 20

main:
    ; !C3 -> 21
    MOVWF 20
    ANDLW 0b00001000
    MOVWF 21
    RRF   21,1
    RRF   21,1
    RRF   21,1
    COMF  21,1
    MOVF  21,0
    ANDLW 0b00000001
    MOVWF 21
    ; C5 -> 22
    MOVWF 20
    ANDLW 0b00100000
    MOVWF 22
    RRF   22,1
    RRF   22,1
    RRF   22,1
    RRF   22,1
    RRF   22,1
    MOVF  22,0
    ANDLW 0b00000001
    MOVWF 22

    ; OPERATION
    MOVF  21,0
    ANDWF 22,0
    MOVWF 23
    BCF  PORTD,0
    BTFSC 23,0
    goto ON
    goto main ;read again

ON:

  BSF  PORTD,0
  goto main

OFF:
  BCF  PORTD,0
  goto main

   END resetVec
