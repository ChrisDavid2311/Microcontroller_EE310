/*
 * The purpose of this program is demonstrate How ADC Converts The Input Voltage & Display On LCD
 * Connect your input to RA0. 
 * Use a port to represent the input voltage in binary.  
 * Author: Christy Sahayaraj
 * Date: 04/30/2026
 * RD Ports For LCD
 * RA0 is the voltage Tuning
 */


#include <xc.h>
#include "pic18f47k42.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define _XTAL_FREQ 4000000
#define Vref 5

// LCD pins
#define RS LATB0
#define EN LATB1
#define ldata LATD

#define LCD_Port TRISD
#define LCD_Control TRISB

#define LCD_Control_digital ANSELB
#define LCD_data_digital ANSELD

int digital;
float voltage;
char data[16];

// Function prototypes
void LCD_Init(void);
void LCD_Command(char cmd);
void LCD_Char(char dat);
void LCD_String(const char *msg);
void LCD_String_xy(char row, char pos, const char *msg);
void LCD_Clear(void);
void ADC_Init(void);

// ---------------- MAIN ----------------
void main(void)
{
    LCD_Init();
    ADC_Init();

    LCD_String_xy(1, 0, "Input Voltage Is:");

    while(1)
    {
        ADCON0bits.GO = 1;
        while(ADCON0bits.GO);

        digital = ((int)ADRESH << 8) | ADRESL;

        voltage = digital * ((float)Vref / 4095.0);

        sprintf(data, "%.2f V", voltage);

        LCD_String_xy(2, 0, "                ");
        LCD_String_xy(2, 0, data);

        __delay_ms(300);
    }
}

// ---------------- ADC INIT ----------------
void ADC_Init(void)
{
    TRISAbits.TRISA0 = 1;
    ANSELAbits.ANSELA0 = 1;

    ADCON0bits.FM = 1;
    ADCON0bits.CS = 1;

    ADCLK = 0x00;
    ADPCH = 0x00;

    ADCAP = 0x00;
    ADREF = 0x00;

    ADPREL = 0x00;
    ADPREH = 0x00;

    ADACQL = 0x00;
    ADACQH = 0x00;

    ADCON0bits.ON = 1;
}

// ---------------- LCD FUNCTIONS ----------------
void LCD_Init(void)
{
    __delay_ms(15);

    LCD_Port = 0x00;
    LCD_Control = 0x00;

    LCD_data_digital = 0x00;
    LCD_Control_digital = 0x00;

    LCD_Command(0x01);
    LCD_Command(0x38);
    LCD_Command(0x0C);
    LCD_Command(0x06);
}

void LCD_Clear(void)
{
    LCD_Command(0x01);
}

void LCD_Command(char cmd)
{
    ldata = cmd;
    RS = 0;
    EN = 1;
    NOP();
    EN = 0;
    __delay_ms(3);
}

void LCD_Char(char dat)
{
    ldata = dat;
    RS = 1;
    EN = 1;
    NOP();
    EN = 0;
    __delay_ms(1);
}

void LCD_String(const char *msg)
{
    while((*msg) != 0)
    {
        LCD_Char(*msg);
        msg++;
    }
}

void LCD_String_xy(char row, char pos, const char *msg)
{
    char location = 0;

    if(row <= 1)
    {
        location = 0x80 | (pos & 0x0F);
        LCD_Command(location);
    }
    else
    {
        location = 0xC0 | (pos & 0x0F);
        LCD_Command(location);
    }

    LCD_String(msg);
}
