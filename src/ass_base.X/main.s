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
    BSF STATUS,6 ;BK1
    BSF STATUS,5

    BSF TRISC, 1        ;PORT (C0) S1 ENTRADA
    BSF TRISC, 2 ;PORT (C1) S2 ENTRADA
    BSF TRISC, 3 ;PORT (C2) S3 ENTRADA
    BSF TRISC, 4 ;PORT (C3) S4 ENTRADA
    BSF TRISC, 5 ;PORT (C4) S5 ENTRADA

    BCF TRISD, 1 ;PORT (D0) MA1 SALIDA
    BCF TRISD, 2 ;PORT (D1) MA2 SALIDA
    BCF TRISD, 3 ;PORT (D2) MB1 SALIDA
    BCF TRISD, 4 ;PORT (D3) MB2 SALIDA
    BCF TRISD, 5 ;PORT (D4) LAI SALIDA
    BCF TRISD, 6 ;PORT (D5) LAD SALIDA
    BCF TRISD, 7 ;PORT (D6) LRSTP SALIDA

    ;*************************
    BCF STATUS, 5 ; BK0

   MAIN:
    MOVF PORTC,1
    MOVWF 0x25

   ;R21 = S2
    MOVWF 0x25
    ANDLW 0b00000010
    MOVWF 0x26
    RRF 0x26,1
    MOVF  0x26,0
    ANDLW 0b00000001
    MOVWF 0x26

    ;R22 = !S2
    MOVWF 0x25
    ANDLW 0b00000010
    MOVWF 0x27
    RRF 0x27,1
    COMF  0x27,0
    MOVF  0x27,0
    ANDLW 0b00000001
    MOVWF 0x27

    ;R23 = S3
    MOVWF 0x25
    ANDLW 0b00000100
    MOVWF 0x28
    RRF 0x28,1
    RRF 0x28,1
    MOVF  0x28,0
    ANDLW 0b00000001
    MOVWF 0x28

    ;R24 = !S3
    MOVWF 0x25
    ANDLW 0b00000100
    MOVWF 0x29
    RRF 0x29,1
    RRF 0x29,1
    COMF  0x29,0
    MOVF  0x29,0
    ANDLW 0b00000001
    MOVWF 0x29

    ;R25 = S1
    MOVWF 0x25
    ANDLW 0b00001000
    MOVWF 0x30
    RRF 0x30,1
    RRF 0x30,1
    RRF 0x30,1
    MOVF  0x30,0
    ANDLW 0b00000001
    MOVWF 0x30

    ;R26 = !S1
    MOVWF 0x25
    ANDLW 0b00001000
    MOVWF 0x31
    RRF 0x31,1
    RRF 0x31,1
    RRF 0x31,1
    COMF  0x31,0
    MOVF  0x31,0
    ANDLW 0b00000001
    MOVWF 0x31

    ;R27 = S4
    MOVWF 0x25
    ANDLW 0b00010000
    MOVWF 0x32
    RRF 0x32,1
    RRF 0x32,1
    RRF 0x32,1
    RRF 0x32,1
    MOVF  0x32,0
    ANDLW 0b00000001
    MOVWF 0x32

    ;R28 = !S4
    MOVWF 0x25
    ANDLW 0b00010000
    MOVWF 0x33
    RRF 0x33,1
    RRF 0x33,1
    RRF 0x33,1
    RRF 0x33,1
    COMF  0x33,0
    MOVF  0x33,0
    ANDLW 0b00000001
    MOVWF 0x33

    ;R29 = S0
    MOVWF 0x25
    ANDLW 0b00100000
    MOVWF 0x34
    RRF 0x34,1
    RRF 0x34,1
    RRF 0x34,1
    RRF 0x34,1
    RRF 0x34,1
    MOVF  0x34,0
    ANDLW 0b00000001
    MOVWF 0x34

    ;R30 = !S0
    MOVWF 0x25
    ANDLW 0b00100000
    MOVWF 0x35
    RRF 0x35,1
    RRF 0x35,1
    RRF 0x35,1
    RRF 0x35,1
    RRF 0x35,1
    COMF  0x35,0
    MOVF  0x35,0
    ANDLW 0b00000001
    MOVWF 0x35

    ; OPERACIONES AND PARA MI
    ; OPERATION R36 = !S1 * S2
MOVF 0x31,0
ANDWF 0x26,0
MOVWF 0x36

; OPERATION R37 = !S1 * S3
MOVF 0x31,0
ANDWF 0x28,0
MOVWF 0x37

; OPERATION R38 = !S0 * S4
MOVF 0x35,0
ANDWF 0x32,0
MOVF 0x38

    ; OPERACIONES AND PARA MD

; OPERATION R39 = S0 * !S4
MOVF 0x34,0
ANDWF 0x33,0
MOVWF 0x39

; OPERATION R340 = S1 * !S3
MOVF 0x30,0
ANDWF 0x29,0
MOVWF 0x40

; OPERATION R41 = !S1 * !S3
MOVF 0x31,0
ANDWF 0x29,0
MOVWF 0x41

; OPERATION R42 = (!S1 * !S3) * S2
MOVF 0x41,0
ANDWF 0x26,0
MOVWF 0x42

    ; OPERACIONES AND PARA RI

; OPERATION R43 = !S4 * !S2
MOVF 0x33,0
ANDWF 0x27,0
MOVWF 0x43

    ; OPERACIONES AND PARA RD

    ; OPERATION R44 = !S0 * !S2
MOVF 0x35,0
ANDWF 0x27,0
MOVWF 0x44

    ;OPERACIONES AND PARA LEFT

;OPERATION R45 = !S4 * S1
MOVF 0x33,0
ANDWF 0x30,0
MOVWF 0x45

;OPERATION R46 = (!S4 * S1) * !S3
MOVF 0x45,0
ANDWF 0x29,0
MOVWF 0x46

;OPERATION R47 = !S0 * !S4
MOVF 0x35,0
ANDWF 0x33,0
MOVWF 0x47

;OPERATION R48 = (!S0 * !S4) * !S1
MOVF 0x47,0
ANDWF 0x31,0
MOVWF 0x48

;OPERATION R49 = ((!S0 * !S4) * !S1) * !S3
MOVF 0x43,0
ANDWF 0x29,0
MOVWF 0x49

;OPERATION R50 = (((!S0 * !S4) * !S1) * !S3) * S2
MOVF 0x49,0
ANDWF 0x26,0
MOVWF 0x50

;OPERATION R51 = S0 * !S4
MOVF 0x34,0
ANDWF 0x33,0
MOVWF 0x51

;OPERATION R52 = (S0 * !S4) * !S1
MOVF 0x51,0
ANDWF 0x26,0
MOVWF 0x52

;OPERATION R53 = ((S0 * !S4)!S1)!S3
MOVF 0x52,0
ANDWF 0x29,0
MOVWF 0x53

;OPERATION R54 = (((S0 * !S4)!S1)!S3)*!S2
MOVF 0x53,0
ANDWF 0x27,0
MOVWF 0x54

    ;OPERACIONES AND PARA STOP

;OPERATION R55 = !SO * !S4
MOVF 0x35,0
ANDWF 0x33,0
MOVWF 0x55

;OPERATION R56 = (!SO * !S4) * !S1
MOVF 0x55,0
ANDWF 0x31,0
MOVWF 0x56

;OPERATION R57 = ((!SO * !S4) * !S1) * !S3
MOVF 0x56,0
ANDWF 0x29,0
MOVWF 0x57

;OPERATION R58 = (((!SO * !S4) * !S1) * !S3) * !S2
MOVF 0x57,0
ANDWF 0x27,0
MOVWF 0x58

;OPERATION R59 = S0 * S4
MOVF 0x34,0
ANDWF 0x32,0
MOVWF 0x59

;OPERATION R60 = (S0 * S4) * S1
MOVF 0x59,0
ANDWF 0x30,0
MOVWF 0x60

;OPERATION R61 = ((S0 * S4) * S1) * S3
MOVF 0x60,0
ANDWF 0x28,0
MOVWF 0x61

;OPERATION R62 = (((S0 * S4) * S1) * S3) * S2
MOVF 0x61,0
ANDWF 0x26,0
MOVWF 0x62


    ;OPERACIONES AND PARA RIGHT

;OPERATION R63 = !S0 * !S1
MOVF 0x35,0
ANDWF 0x31,0
MOVWF 0x63

;OPERATION R64 = (!S0 * !S1) * S3
MOVF 0x63,0
ANDWF 0x28,0
MOVWF 0x64

;OPERATION R65 = !S0 * S4
MOVF 0x35,0
ANDWF 0x32,0
MOVWF 0x65

;OPERATION R66 = (!S0 * S4) * !S1
MOVF 0x65,0
ANDWF 0x31,0
MOVWF 0x66

;OPERATION R67 = ((!S0 * S4) * !S1) * !S3
MOVF 0x66,0
ANDWF 0x29,0
MOVWF 0x67

;OPERATION R68 = (((!S0 * S4) * !S1) * !S3) * !S2
MOVF 0x67,0
ANDWF 0x27,0
MOVWF 0x68


    ;OPERACIONES OR PARA MI

;OPERATION R69 = !S1 *S2 + !S1 * S3
MOVF 0x36,0
IORWF 0x37,0
MOVWF 0x69

;OPERATION R70 = (!S1 *S2 + !S1 * S3) + !S0 * S4
MOVF 0x69,0
IORWF 0x38,0
MOVWF 0x70

    ;OPERACIONES OR PARA MD

;OPERATION R71 = S0 * !S4 + S1 * !S3
MOVF 0x39,0
IORWF 0x40,0
MOVWF 0x71

;OPERATION R72 = (S0 * !S4 + S1 * !S3) + !S1 * !S3 * S2
MOVF 0x71,0
IORWF 0x42,0
MOVWF 0x72

    ;OPERACIONES OR PARA RI

;OPERATION R73 = S0 * !S4 + !S4 * !S2
MOVF 0x39,0
IORWF 0x43,0
MOVWF 0x73

    ;OPERACIONES OR PARA RD

;OPERATION R74 = !S0 * !S2 + !S0 * S4
MOVF 0x44,0
IORWF 0x38,0
MOVWF 0x74

    ;OPERACIONES OR PARA LEFT

        ;OPERATION R75 =  ((!S4 * S1) * !S3) + ((((!S0 * !S4) * !S1) * !S3) * S2)
MOVF 0x46,0
IORWF 0x50,0
MOVWF 0x75

        ;OPERATION R76 = ((!S4 * S1) * !S3) + ((((!S0 * !S4) * !S1) * !S3) * S2) + ((((S0 * !S4)!S1)!S3)*!S2)
MOVF 0x75,0
IORWF 0x54,0
MOVWF 0x76

    ;OPERACIONES OR PARA STOP

        ;OPERATION R77 = ((((!SO * !S4) * !S1) * !S3) * !S2) + (((S0 * S4) * S1) * S3) * S2)
MOVF 0x58,0
IORWF 0x62,0
MOVWF 0x77

;OPERACIONES OR PARA RIGHT

;OPERATION R78 = ((!S0 * !S1) * S3) +  ((((!S0 * !S4) * !S1) * !S3) * S2)
MOVF 0x64,0
IORWF 0x50,0
MOVWF 0x78

;OPERATION R79 = (((!S0 * !S1) * S3) +  (((!S0 * !S4) * !S1) * !S3)*S2) + ((((!S0 * S4) * !S1) * !S3) * !S2)
MOVF 0x78,0
IORWF 0x68,0
MOVWF 0x79

;ASIGNACION DE SALIDAS

CLRF PORTD


;MI:
BTFSC 0x70,0
GOTO ONMI
GOTO OFFMI

ONMI:
BSF PORTD,1
GOTO MD

OFFMI:
BSF PORTD,1
GOTO MD

;MD:
MD:
BTFSC 0x72,0
GOTO ONMD
GOTO OFFMD

ONMD:
BSF PORTD,2
GOTO RI

OFFMD:
BSF PORTD,2
GOTO RI

;RI:
RI:
BTFSC 0x73,0
GOTO ONRI
GOTO OFFRI

ONRI:
BSF PORTD,3
GOTO BKR

OFFRI:
BSF PORTD,3
GOTO BKR


;RD
BKR:
BTFSC 0x74,0
GOTO ONRD
GOTO OFFRD

ONRD:
BSF PORTD,4
GOTO RIGHT

OFFRD:
BSF PORTD,4
GOTO RIGHT


;RIGHT
RIGHT:
BTFSC 0x79,0
GOTO ONRIGHT
GOTO OFFRIGHT

ONRIGHT:
BSF PORTD,5
GOTO STOP

OFFRIGHT:
BSF PORTD,5
GOTO STOP

;STOP:
STOP:
BTFSC 0x77,0
GOTO ONSTOP
GOTO OFFSTOP

ONSTOP:
BSF PORTD,6
GOTO LEFT

OFFSTOP:
BSF PORTD,6
GOTO LEFT

;LEFT
LEFT:
BTFSC 0x76,0
GOTO ONLEFT
GOTO OFFLEFT

ONLEFT:
BSF PORTD,7
GOTO MAIN

OFFLEFT:
BSF PORTD,7
GOTO MAIN

END resetVec