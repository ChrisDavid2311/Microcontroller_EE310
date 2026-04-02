;---------------------------------------------------------------
; Title: Keypad-Controlled 7-Segment Incremenr_Decrement Counting Operation
;---------------------------------------------------------------
; Program Details:
; The purpose of this program is to implement a system
; that responds to the following keypad inputs:
;   - Key '1': Increment the Value_Counter
;   - Key '2': Decrement the Value_Counter
;   - Key '3': Reset the Value_Counter to 0
;
; Inputs: Keypad (Connected To PORTB)
; Outputs: 7-Segment Display (All Connected To PORTD)
; Setup:PIC18F47K42 Nano Curiosity Board (Battery Powered)
;
; Date: Mar 27, 2026
; File Dependencies / Libraries:
;   - AssemblyConfig.inc in Header Folder
;
; Compiler: pic-as V 3.10
; Author: Christy Sahayaraj
; Versions:
;   - v1.0: Logic Setup/Check
;   - v2.0: Current
;---------------------------------------------------------------
    
;---------------------
; Initialization
;---------------------
#include "AssemblyConfig.inc"
#include <xc.inc>

;---------------------
; Program Variables
;---------------------
Value_Counter     equ 0x20		; 0->0xF value
Keypad_Press	  equ 0x21		; 1=Increment, 2=Decrement, 3=Reset
Outer_Delay       equ 0x22		;Outer Delay
Inner_Delay       equ 0x23		;Inner Delay

;---------------------
; Start Program
;---------------------
    PSECT absdata,abs,ovrld

    ORG     0x00
    GOTO    _Start

    ORG     0x20

_Start:
    CLRF    Value_Counter
    CLRF    Keypad_Press
    RCALL   _Ports_Define
    GOTO    _Main

_Ports_Define:
    BANKSEL PORTB			;Port B are configured for Keypad
    CLRF PORTB
    BANKSEL LATB
    CLRF LATB
    BANKSEL ANSELB
    CLRF ANSELB
    BANKSEL TRISB
    MOVLW 0b11111000			; Set RB0-RB2 (Column) As Output Ports & RB3-RB7 (Row) As Input Ports
    MOVWF TRISB

    BANKSEL PORTD			;Port D are configured for 7_Segment
    CLRF PORTD
    BANKSEL LATD
    CLRF LATD
    BANKSEL ANSELD
    CLRF ANSELD
    BANKSEL TRISD
    MOVLW 0x00				; Set RD0-RD7 As Output Ports (7_Seg)
    MOVWF TRISD

;---------------------
; Main Loop
;---------------------
_Main:
    CALL _Display_Digit			; Display "0" at the start

_Loop_Function:
    CALL _Display_Digit
    RCALL _Keypad_Scan

    MOVF Keypad_Press, W
    XORLW 0x01				; Is key #1 Pressed?
    BTFSC STATUS, 2
    GOTO _Increment_Loop

    MOVF Keypad_Press, W
    XORLW 0x02				; Is key #2 Pressed?
    BTFSC STATUS, 2
    GOTO _Decrement_Loop

    MOVF Keypad_Press, W
    XORLW 0x03				; Is key #3 Pressed?
    BTFSC STATUS, 2
    GOTO _Reset

    GOTO _Loop_Function			; Any Other Key_Loop

_Increment_Loop:
    CALL _Display_Digit
    CALL _Delay

    INCF Value_Counter, F
    MOVF Value_Counter, W
    XORLW 0x10				; If Value_Counter > 0x0F, Make It to "0" (Wrap Around Check For Increment Function)
    BTFSS STATUS, 2
    GOTO _Increment_Hold_Check
    CLRF Value_Counter

_Increment_Hold_Check:
    RCALL _Keypad_Scan
    MOVF Keypad_Press, W
    XORLW 0x01
    BTFSC STATUS, 2
    GOTO _Increment_Loop		; Continue If Still Holding #1
    GOTO _Loop_Function

_Decrement_Loop:
    CALL _Display_Digit
    CALL _Delay

    DECF Value_Counter, F		; Decrease Value_Counter
    MOVF Value_Counter, W
    XORLW 0xFF				; If Value_Counter Goes Below "0" (0XFF), (Wrap Around Check For Decrement Function)
    BTFSC STATUS, 2
    MOVLW 0x0F				; If yes, Make It to 0x0F (Wrap Around Value Back To 0X0F)
    BTFSC STATUS, 2
    MOVWF Value_Counter

_Decrement_Hold_Check:
    RCALL _Keypad_Scan
    MOVF Keypad_Press, W
    XORLW 0x02
    BTFSC STATUS, 2
    GOTO _Decrement_Loop		; Continue If Still Holding #2
    GOTO _Loop_Function

_Reset:
    CLRF Value_Counter
    CALL _Display_Digit
    GOTO _Loop_Function

_Display_Digit:
    LFSR 0, _Number_Table		; Load address of 7-Segment Table into FSR0
    MOVF FSR0H, W			; Copy FSR0 into TBLPTR
    MOVWF TBLPTRH
    MOVF FSR0L, W
    MOVWF TBLPTRL

    BANKSEL Value_Counter		; Load digit index from Value_Counter and offset TBLPTRL
    MOVF Value_Counter, W
    ADDWF TBLPTRL, F
    TBLRD*				; Table read: load byte at TBLPTR into TABLAT
    MOVF TABLAT, W
    MOVWF LATD				; Output to 7-segment
    RETURN

;---------------------
; 7-Segment Table
;---------------------
    ORG	  0x200
_Number_Table:
    DB  0x3F  ; 0
    DB  0x06  ; 1
    DB  0x5B  ; 2
    DB  0x4F  ; 3
    DB  0x66  ; 4
    DB  0x6D  ; 5
    DB  0x7D  ; 6
    DB  0x07  ; 7
    DB  0x7F  ; 8
    DB  0x6F  ; 9
    DB  0x77  ; A
    DB  0x7C  ; B
    DB  0x39  ; C
    DB  0x5E  ; D
    DB  0x79  ; E
    DB  0x71  ; F
    
;---------------------
; Delay
;---------------------
_Delay:
    MOVLW 0XFF
    MOVWF Outer_Delay
_Outer_Loop:
    MOVLW 0XFF
    MOVWF Inner_Delay
_Inner_Loop:
    NOP
    NOP
    DECFSZ Inner_Delay, F
    GOTO _Inner_Loop
    DECFSZ Outer_Delay, F
    GOTO _Outer_Loop
    RETURN
    
;---------------------
; Keypad Scanner
;---------------------
_Keypad_Scan:
    CLRF Keypad_Press

    BCF LATB, 0				; Set Column 1 LOW
    BCF LATB, 1				; Set Column 2 LOW
    BCF LATB, 2				; Set Column 3 LOW
    NOP

    BSF LATB, 0				; Set Column 1 HIGH
    BTFSC PORTB, 3			; Check If Row 1 Is HIGH
    MOVLW 0x01				; If So, Load "1" Into WREG
    BCF LATB, 0				; Set Column 1 LOW

    BSF LATB, 1				; Set Column 2 HIGH
    BTFSC PORTB, 3			; Check If Row 1 Is HIGH
    MOVLW 0x02				; If So, Load "2" Into WREG
    BCF LATB, 1				; Set Column 2 LOW

    BSF LATB, 2				; Set Column 3 HIGH
    BTFSC PORTB, 3			; Check If Row 1 Is HIGH
    MOVLW 0x03				; If So, Load "3" Into WREG
    BCF LATB, 2				; Set Column 3 LOW

    MOVWF Keypad_Press			; Store Result In Keypad_Press Register
    
    RETURN    

    END
