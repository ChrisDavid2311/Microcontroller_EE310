void Sevenseg_Disp(int number){
    switch (number)
    {
        case 0: LATD = numTable[0]; break;
        case 1: LATD = numTable[1]; break;
        case 2: LATD = numTable[2]; break;
        case 3: LATD = numTable[3]; break;
        case 4: LATD = numTable[4]; break;
        case 5: LATD = numTable[5]; break;
        case 6: LATD = numTable[6]; break;
        case 7: LATD = numTable[7]; break;
        case 8: LATD = numTable[8]; break;
        case 9: LATD = numTable[9]; break;
        default: LATD = numTable[0]; break;
    }
    

}




int isDigit2_pressed(){
    return(PORTAbits.RA0);
}
int isDigit1_pressed(){
    return(PORTAbits.RA1);
}
void Turn_On_Motor(){
    LATAbits.LATA5 = 1;
}
void Turn_Off_Motor(){
    LATAbits.LATA5 = 0;
}
void Turn_On_Buzzer(){
    LATBbits.LATB2 = 1;
}
void Turn_Off_Buzzer(){
    LATBbits.LATB2 = 0;
}
void Turn_On_Led(){
    LATAbits.LATA3 = 1;
}
void Turn_Off_Led(){
    LATAbits.LATA3 = 0;
}
