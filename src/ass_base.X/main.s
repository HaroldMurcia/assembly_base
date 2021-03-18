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
    BSF TRISC, 1    ; S2  IN
    BSF TRISC, 2    ; S3  IN
    BSF TRISC, 3    ; S1  IN  
    BSF TRISC, 4    ; S4  IN  
    BSF TRISC, 5    ; S0  IN  
    BCF TRISD, 1    ; MI  OUT
    BCF TRISD, 2    ; MD  OUT
    BCF TRISD, 3    ; RI  OUT
    BCF TRISD, 4    ; RD  OUT  
    BCF TRISD, 5    ; RIGHT  OUT
    BCF TRISD, 6    ; STOP  OUT
    BCF TRISD, 7    ; LEFT  OUT
    ; Regresar a banco 0
    BCF STATUS, 5 ; Bank0
    ; Salidas por defecto en cero
    BCF PORTD, 1    ; MI  OUT
    BCF PORTD, 2    ; MD  OUT
    BCF PORTD, 3    ; RI  OUT
    BCF PORTD, 4    ; RD  OUT  
    BCF PORTD, 5    ; RIGHT  OUT
    BCF PORTD, 6    ; STOP  OUT
    BCF PORTD, 7    ; LEFT  OUT
    
main:
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
   
    CLRF PORTD
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

    BCF PORTD,1
    BTFSC 0x70,0 ;MI x
    goto MI_on
ask_MI:    
    BTFSC 0x72,0 ;MD x
    BSF PORTD,2

    BTFSC 0x73,0 ;RI x
    BSF PORTD,3

    BTFSC 0x74,0 ;RD x
    BSF PORTD,4

    BTFSC 0x79,0 ;RIGHT
    BSF PORTD,5

    BTFSC 0x77,0 ;STOP
    BSF PORTD,6

    BTFSC 0x76,0 ;LEFT
    BSF PORTD,7

MI_on:    
    BSF PORTD,1
    goto ask_MI
MI_off:    
    BCF PORTD,1    
MD_on:    
    BSF PORTD,1
RI_on:    
    BSF PORTD,1
RD_on:    
    BSF PORTD,1
    
    GOTO main

    END resetVec