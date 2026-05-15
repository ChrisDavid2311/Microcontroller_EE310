/************************************************************
 * Title: PWM Functionality With Servo Motor Function
 *
 * DESCRIPTION:
 * This program controls a servo motor using PWM output, 2 buttons used to rotate left & right
 * VERSION: 1.0
 *
 * AUTHOR: Christy Sahayaraj
 * Date: 05/14/2026
 ************************************************************/

// ==============================
// I/P
// ==============================
// RD0 = LEFT push button 
// RD1 = RIGHT push button
// ==============================
// O/P
// ==============================
// RB3 = PWM output to servo
// ==============================
// PWM DETAILS
// ==============================
// PWM Period: ~20 ms
// Center: ~50
// ==============================
#include <xc.h>
#include <stdint.h>
#include "PWM.h"
#include "PIC18F47K42.h"

#define _XTAL_FREQ 4000000

// ==============================
// BUTTONS (internal pull-ups)
// Active LOW when pressed
// ==============================
#define LEFT_BUTTON   PORTDbits.RD0
#define RIGHT_BUTTON  PORTDbits.RD1

// ==============================
// SERVO RANGE (adjusted values)
// ==============================
#define MIN_ROT      11
#define MAX_ROT      79

uint8_t duty_value = 48;   // center position

// ==============================
// MAIN
// ==============================
void main(void)
{
    // CLOCK
    OSCSTATbits.HFOR = 1;
    OSCFRQ = 0x02;   // 4 MHz

    // DIGITAL SETUP
    ANSELD = 0x00;   // digital pins only

    TRISDbits.TRISD0 = 1; // input
    TRISDbits.TRISD1 = 1; // input

    // ==============================
    // INTERNAL PULL-UPS ENABLE
    // ==============================
    WPUDbits.WPUD0 = 1;
    WPUDbits.WPUD1 = 1;

    // PORT B OUTPUTS (PWM)
    ANSELB = 0x00;
    TRISB = 0x00;

    // ==============================
    // TIMER2 + PWM SETUP
    // ==============================
    TMR2_Initialize();
    TMR2_StartTimer();

    PWM_Output_D8_Enable();
    PWM2_Initialize();

    PWM2_LoadDutyValue(duty_value);

    // small delay
    __delay_ms(300);

    // ==============================
    // MAIN LOOP
    // ==============================
    while(1)
    {
        // If RIGHT button (pressed = 0)
        if(RIGHT_BUTTON == 0)
        {
            if(duty_value < MAX_ROT)
                duty_value++;

            PWM2_LoadDutyValue(duty_value);
            __delay_ms(60);   // Delay
        }

        // If LEFT button (pressed = 0)
        else if(LEFT_BUTTON == 0)
        {
            if(duty_value > MIN_ROT)
                duty_value--;

            PWM2_LoadDutyValue(duty_value);
            __delay_ms(60);   // Delay
        }
    }
}



