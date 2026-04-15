//-----------------------------
// Title: Touchless Box Open Using Photo Resistors (Touchless Switches)
//Purpose: Use secret code (password hard coded) as input through 2 photo resistors.
// If password matches, through relay setup a motor will be switched ON
// If password match failes, a buzzer will sound
// Dependencies:
// config.h Main configuration file for PIC18F47K42
// xc.h XC8 compiler standard library
// functions.h All program functions at one place
// initializations.h All initializations at one place
// Compiler XC8 (v3.10)
// Date: 04/14/2026
// Author: Christy Sahayaraj
// Versions: V1.0 (Initial)

// Variable Declaration
int password;
int count;
int secretcode=23;

//Function Declaration
