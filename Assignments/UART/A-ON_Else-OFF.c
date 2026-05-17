// ============================================
// Title:   UART Function
// Author:  Christy Sahayaraj
// Date:    05/16/2026
// Version: 1
// Purpose: Using UART To Do Alphabet Press Check
// Outcome: Press "A" LED ON; Remaining LED "OFF"
//============================================

#include "mcc_generated_files/system/system.h"
#include <stdio.h>



int main(void)
{
    SYSTEM_Initialize();

    UART2_Initialize();
    //__delay_ms(10000);

    
//    TRISBbits.TRISB1 = 0;
//    ANSELBbits.ANSELB1 = 0;
//    LATBbits.LATB1 = 0;
    
    printf("UART2 Ready...\r\n");
    printf("Press A LED ON.\r\n");
    printf("Anything Other Than A LED OFF.\r\n");

    while(1)
    {
        // Check if UART received data
        if(UART2_IsRxReady())
        {
            char receivedData = UART2_Read();

            if(receivedData == 'A')
            {
                LATBbits.LATB1 = 1;
                printf("Received A -> LED ON\r\n");
            }
            else
            {
                LATBbits.LATB1 = 0;
                printf("Received %c -> LED OFF\r\n", receivedData);
            }
        }
    }
}
