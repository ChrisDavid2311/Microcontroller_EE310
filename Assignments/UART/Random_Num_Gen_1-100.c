// ============================================
// Title:   UART Function RAND
// Author:  Christy Sahayaraj
// Date:    05/16/2026
// Version: 1
// Purpose: Random Number Generation (1-100) Every 1 Second
// Outcome: Generating Random Number B/W 1 to 100 Every 1 Second
//============================================

#include "mcc_generated_files/system/system.h"
#include <stdio.h>
#include <stdlib.h>

int random_number(int min_num, int max_num)
{
    return (rand() % (max_num - min_num + 1)) + min_num;
}

int main(void)
{
    SYSTEM_Initialize();

    UART2_Initialize();

    // Seed random generator
    srand(1234);

    while(1)
    {
        int value = random_number(1, 100);

        // Print only the random value
        printf("%d\r\n", value);

        // Toggle LED on RB1
        PORTBbits.RB1 ^= 1;

        // 1 second delay
        __delay_ms(1000);
    }
}


// ============================================
// Title:   UART Function RAND
// Author:  Christy Sahayaraj
// Date:    05/18/2026
// Version: Final
// Purpose: Random Number Generation (1-100) Every 1 Second
// Outcome: Generating Random Number B/W 1 to 100 Every 1 Second
//============================================


#include "mcc_generated_files/system/system.h"
#include <stdio.h>
#include <stdint.h>

static uint32_t seed = 12345;

uint32_t get_random(void)
{
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    return seed;
}

int random_number(int min_num, int max_num)
{
    return (get_random() % (max_num - min_num + 1)) + min_num;
}

int main(void)
{
    SYSTEM_Initialize();
    UART2_Initialize();
    
    while(1)
    {
        printf("Min : 1 Max : 100 %d\r\n", random_number(1, 100));
        __delay_ms(1000);
        PORTBbits.RB1 ^= 1;
    }
}
