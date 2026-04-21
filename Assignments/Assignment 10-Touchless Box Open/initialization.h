int numTable[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
int passCode1=2;
int passCode2=3;

void init(void){
        // Set RA0 as INPUT
    TRISAbits.TRISA0 = 1;
    TRISAbits.TRISA1 = 1;

    // Set RA3 as OUTPUT
    TRISAbits.TRISA3 = 0;
    TRISAbits.TRISA5 = 0;
    TRISBbits.TRISB2 = 0;

    // Make pins digital
    ANSELAbits.ANSELA0 = 0;
    ANSELAbits.ANSELA1 = 0;
    ANSELAbits.ANSELA3 = 0;
    ANSELAbits.ANSELA5 = 0;

    // Turn LED OFF initially
    LATAbits.LATA3 = 0;
    LATAbits.LATA5 = 0;
    LATBbits.LATB2 = 0;
    
    // 7seg pin init
    TRISDbits.TRISD0 = 0;
    TRISDbits.TRISD1 = 0;
    TRISDbits.TRISD2 = 0;
    TRISDbits.TRISD3 = 0;
    TRISDbits.TRISD4 = 0;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;
    
    ANSELDbits.ANSELD0 = 0;
    ANSELDbits.ANSELD1 = 0;
    ANSELDbits.ANSELD2 = 0;
    ANSELDbits.ANSELD3 = 0;
    ANSELDbits.ANSELD4 = 0;
    ANSELDbits.ANSELD5 = 0;
    ANSELDbits.ANSELD6 = 0;
    
    LATDbits.LATD0 = 0;
    LATDbits.LATD1 = 0;
    LATDbits.LATD2 = 0;
    LATDbits.LATD3 = 0;
    LATDbits.LATD4 = 0;
    LATDbits.LATD5 = 0;
    LATDbits.LATD6 = 0;   
}