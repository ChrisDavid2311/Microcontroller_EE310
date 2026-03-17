//-----------------------------
// Title: Temparature Based Heating And Cooling Switching System
//-----------------------------
// Purpose: This program compares a measured temperature with a reference 
// temperature and turns on heating, cooling, or nothing based on the result.
//
// Dependencies: myConfigFile.inc and xc.inc
//
// Compiler: pic-as (V 3.10)
//
// Author: Christy Sahayaraj
//
// OUTPUTS: 
// PORTD.2 controls the cooling system LED.
// PORTD.1 controls the heating system LED.
// contREG (0x22) stores the control value for the system.
// Registers 0x60-0x62 store the decimal digits of the reference temperature.
// Registers 0x70-0x72 store the decimal digits of the measured temperature.
//
// INPUTS: 
// measuredTempInput is the measured temperature value from the sensor.
// refTempInput is the reference temperature value entered by the user.
//
// Versions:
// V1.0: March 05, 2026 - Initial version of the program
// V1.1: March 12, 2026 - Updated comparison logic and decimal conversion
// V1.2: March 17, 2026 - Logic Checks & Comments 
//-----------------------------

;----------------------------------
; Setup files
;----------------------------------
#include "C:\Users\chris\MPLABXProjects\AssemblyConfig.inc"
#include <xc.inc>

;----------------
; PROGRAM INPUTS
;----------------
#define measuredTempInput  -10
#define refTempInput       50

;---------------------
; Definitions
;---------------------
#define SWITCH   LATD,2
#define LED0     PORTD,1
#define LED1     PORTD,2

;---------------------
; Program Constants
;---------------------
REG10   EQU 10h
REG11   EQU 11h
REG01   EQU 1h

;----------------------------------
; Main Registers
;----------------------------------
refTempREG               EQU 0x20
measuredTempREG          EQU 0x21
contREG                  EQU 0x22

;----------------------------------
; Work Registers (Hex-Dec Conversion Specific)
;----------------------------------
Numerator_1              EQU 0x30
Numerator_2              EQU 0x31
Quotient_1               EQU 0x40
Quotient_2               EQU 0x41
Subtractor_Ten           EQU 10

;----------------------------------
; Decimal Digit Registers (Hex-Dec Conversion Specific)
;----------------------------------
refTemp_Decimal_Low        EQU 0x60   ; One's Place
refTemp_Decimal_High       EQU 0x61   ; Ten's Place
refTemp_Decimal_Upper      EQU 0x62   ; Hundred's Place

measuredTemp_Decimal_Low   EQU 0x70   ; One's Place
measuredTemp_Decimal_High  EQU 0x71   ; Ten's Place
measuredTemp_Decimal_Upper EQU 0x72   ; Hundred's Place

;----------------------------------
; MAIN PROGRAM
;----------------------------------
PSECT absdata,abs,ovrld

    ORG 0x20

;----------------------------------
; Clear PORTD & Enable It's Ports As Output
;----------------------------------
    CLRF    PORTD
    MOVLW   0x00
    MOVWF   TRISD, A

;----------------------------------
; Placing Input Values In Registers
;----------------------------------
    MOVLW   measuredTempInput
    MOVWF   measuredTempREG

    MOVLW   refTempInput
    MOVWF   refTempREG

    CLRF    contREG

;----------------------------------
; Range Check ref temp Is From 10>= to <=50
;----------------------------------
_refcheck:
    MOVLW   0x0A
    CPFSEQ  refTempREG
    GOTO    _check_Ref_Low
    GOTO    _check_Ref_High

_check_Ref_Low:
    MOVLW   0x0A
    CPFSGT  refTempREG
    SLEEP

_check_Ref_High:
    MOVLW   0x32
    CPFSEQ  refTempREG
    GOTO    _check_Ref_Top
    GOTO    _sign_check

_check_Ref_Top:
    MOVLW   0x32
    CPFSLT  refTempREG
    SLEEP

    GOTO    _sign_check

;----------------------------------
; If measured temp is -ve,
; go to heat straightaway
;----------------------------------
_sign_check:
    BTFSC   measuredTempREG, 7
    GOTO    _Heat
    GOTO    _Equal

;----------------------------------
; Check if temps are equal
;----------------------------------
_Equal:
    MOVF    refTempREG, 0
    CPFSEQ  measuredTempREG
    GOTO    _Comparison
    GOTO    _Do_Nothing

;----------------------------------
; If not equal, choose heat or cool
;----------------------------------
_Comparison:
    MOVF    refTempREG, 0
    CPFSGT  measuredTempREG
    GOTO    _Heat
    GOTO    _Cool

;----------------------------------
; Too hot
; contREG = 2
; turn on PORTD.2
;----------------------------------
_Cool:
    MOVLW   0x02
    MOVWF   contREG

    MOVLW   0b00000100
    MOVWF   PORTD, A

    GOTO    _measured_Decimal

;----------------------------------
; Too cold
; contREG = 1
; turn on PORTD.1
;----------------------------------
_Heat:
    MOVLW   0x01
    MOVWF   contREG

    MOVLW   0b00000010
    MOVWF   PORTD, A

    GOTO    _measured_Decimal

;----------------------------------
; Temps are same
; contREG = 0
; turn off output
;----------------------------------
_Do_Nothing:
    MOVLW   0x00
    MOVWF   contREG

    MOVLW   0b00000000
    MOVWF   PORTD, A

    GOTO    _measured_Decimal

;----------------------------------
; Split measured temp into digits
;----------------------------------
_measured_Decimal:
    MOVF    measuredTempREG, 0
    MOVWF   Numerator_1

    MOVLW   Subtractor_Ten
    CLRF    Quotient_1

_D1:
    INCF    Quotient_1
    SUBWF   Numerator_1
    BC      _D1

    ADDWF   Numerator_1
    DECF    Quotient_1

    MOVFF   Numerator_1, measuredTemp_Decimal_Low
    MOVFF   Quotient_1, Numerator_1
    CLRF    Quotient_1

_D2:
    INCF    Quotient_1
    SUBWF   Numerator_1
    BC      _D2

    ADDWF   Numerator_1
    DECF    Quotient_1

    MOVFF   Numerator_1, measuredTemp_Decimal_High
    MOVFF   Quotient_1, measuredTemp_Decimal_Upper

    GOTO    _ref_Decimal

;----------------------------------
; Split ref temp into digits
;----------------------------------
_ref_Decimal:
    MOVF    refTempREG, 0
    MOVWF   Numerator_2

    MOVLW   Subtractor_Ten
    CLRF    Quotient_2

_D11:
    INCF    Quotient_2
    SUBWF   Numerator_2
    BC      _D11

    ADDWF   Numerator_2
    DECF    Quotient_2

    MOVFF   Numerator_2, refTemp_Decimal_Low
    MOVFF   Quotient_2, Numerator_2
    CLRF    Quotient_2

_D22:
    INCF    Quotient_2
    SUBWF   Numerator_2
    BC      _D22

    ADDWF   Numerator_2
    DECF    Quotient_2

    MOVFF   Numerator_2, refTemp_Decimal_High
    MOVFF   Quotient_2, refTemp_Decimal_Upper

;----------------------------------
; Program End
;----------------------------------
_END:
    GOTO    _END     // Break_Point

    END
