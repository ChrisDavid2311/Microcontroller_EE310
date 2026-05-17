// ============================================
// Title:   UART Function
// Author:  Christy Sahayaraj
// Date:    05/16/2026
// Version: 1
// Purpose: Using UART To Print Hello Onto Tera Term
// Outcome: How to use UART
//============================================

#include "mcc_generated_files/system/system.h"

/*
    Main application
*/

int main(void)
{
    SYSTEM_Initialize();
    UART2_Initialize();
     //If using interrupts in PIC18 High/Low Priority Mode you need to enable the Global High and Low Interrupts 
     //If using interrupts in PIC Mid-Range Compatibility Mode you need to enable the Global Interrupts 
     //Use the following macros to: 

     //Enable the Global Interrupts 
    INTERRUPT_GlobalInterruptEnable(); 

     //Disable the Global Interrupts 
    INTERRUPT_GlobalInterruptDisable(); 


    while(1)
    {
        printf("hello...\r\n");
    }    
}
