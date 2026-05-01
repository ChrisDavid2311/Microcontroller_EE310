/*
 * The purpose of this program is demonstrate How ADC operates. 
 * Conenct your input to RA0. 
 * Complete the code by modifying all the places identified by "DO:"
 * Use a port to represent the input voltage in binary.  
 * Author: Christy Sahayaraj
 * Date: 04/30/2026
 * Version: V2 (Final)
 */

    #include <xc.h> // must have this
    #include "pic18f47k42.h"
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>


    #define _XTAL_FREQ 4000000                 // Fosc  frequency for _delay()  library
    #define FCY    _XTAL_FREQ/4

    #define Vref 3.3 // voltage reference 
    int digital; // holds the digital value 
    float voltage; // hold the analog value (volt))
    char data[12];

    void ADC_Init(void) // DO: Declare void ADC_Init
    {
        TRISD = 0; //RD As Output
        LATD = 0;
        ANSELD = 0x00;

        TRISB = 0; //RC As Output
        LATB = 0;
        ANSELB = 0x00;

        TRISAbits.TRISA0 = 1;  //Set RA0 to input
        ANSELAbits.ANSELA0 =1;  //Set RA0 to analog

        ADCON0bits.FM =1; // set right justify
        ADCON0bits.CS =1; //set ADCRC Clock

        ADCLK = 0x00;  //set ADC CLOCK Selection register to zero
        ADPCH = 0x00; //Set RA0 as Analog channel in ADC ADPCH

        ADCAP = 0x00; //
        ADREF = 0x00;

        ADPREL = 0x00;  //set pre-charge select to 0 in register ADPERL & ADPERH
        ADPREH = 0x00;

        ADACQL = 0x00; //acquisition Charge share time
        ADACQH = 0x00;

        ADPCH = 0x00;
        ADCON0bits.ON = 1; //DO: Turn ADC On on register ADCON0

        //Clear ADCIF; //clear ADC
    }

    /*This code block configures the ADC
    for polling, VDD and VSS references, ADCRC
    oscillator and AN0 input.
    Conversion start & polling for completion
    are included.
     */
    void main() {
        ADC_Init(); //ADC Initialization
        //DO: CALL ADC_Init function defined below;
        while (1) {
            ADCON0bits.GO =1; //DO: Set ADCON0 Go to start conversion
            while (ADCON0bits.GO); //Wait for conversion done

            digital = (ADRESH<<8) | (ADRESL);//Combine 8-bit LSB and 2-bit MSB/
            voltage = digital*((float)Vref/(float)(4096));// DO: define voltage = Vref/4096 (note that voltage is float type


             LATD =(digital>>5 & 0x7F); 
             //LATB =(digital && 0x1F);
             //LATB = (ADRESH & 0x0F);

             // DO: Write a code to translate the values from ADRESH:ADRESL register 
            //         pair to IO Port. In this case we can connect ADRESL to Port D

            //This is used to convert integer value to ASCII string/
            sprintf(data,"%.2f",voltage);
            strcat(data," V");    //Concatenate result and unit to print/
        }
    }
