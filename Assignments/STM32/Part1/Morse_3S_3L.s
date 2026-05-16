@ ============================================
@ Title:   Morse Code 3 Short 3 Long Blinks
@ Author:  Christy Sahayaraj
@ Date:    05/16/2026
@ Version: 1
@ Purpose: STM32 NUCLEO-L476RG Module used for Morse Code 3 Short 3 Long Blinks 
@ Outcome: 3 Short 3 Long LED Blinks 

@ ============================================

.syntax unified
.thumb
.cpu cortex-m4

.equ RCC_BASE,      0x40021000
.equ RCC_AHB2ENR,   0x4C

.equ GPIOA_BASE,    0x48000000
.equ GPIOA_MODER,   0x00
.equ GPIOA_ODR,     0x14

.equ RCC_AHB2ENR_GPIOAEN, (1 << 0)
.equ GPIO_MODER5_MASK,    (3 << 10)
.equ GPIO_MODER5_OUT,     (1 << 10)
.equ GPIO_ODR5,           (1 << 5)

.equ SHORT_DELAY, 0x80000
.equ LONG_DELAY,  0x180000
.equ WORD_DELAY,  0x300000

.global main
.type main, %function

main:
    LDR r0, =RCC_BASE
    LDR r1, [r0, #RCC_AHB2ENR]
    ORR r1, r1, #RCC_AHB2ENR_GPIOAEN
    STR r1, [r0, #RCC_AHB2ENR]

    LDR r0, =GPIOA_BASE
    LDR r1, [r0, #GPIOA_MODER]
    BIC r1, r1, #GPIO_MODER5_MASK
    ORR r1, r1, #GPIO_MODER5_OUT
    STR r1, [r0, #GPIOA_MODER]

loop:
    BL short_blink
    BL short_blink
    BL short_blink

    BL long_blink
    BL long_blink
    BL long_blink

    BL short_blink
    BL short_blink
    BL short_blink

    BL word_pause

    B loop

short_blink:
    PUSH {lr}

    LDR r1, [r0, #GPIOA_ODR]
    ORR r1, r1, #GPIO_ODR5
    STR r1, [r0, #GPIOA_ODR]

    LDR r2, =SHORT_DELAY
    BL delay

    LDR r1, [r0, #GPIOA_ODR]
    BIC r1, r1, #GPIO_ODR5
    STR r1, [r0, #GPIOA_ODR]

    LDR r2, =SHORT_DELAY
    BL delay

    POP {pc}

long_blink:
    PUSH {lr}

    LDR r1, [r0, #GPIOA_ODR]
    ORR r1, r1, #GPIO_ODR5
    STR r1, [r0, #GPIOA_ODR]

    LDR r2, =LONG_DELAY
    BL delay

    LDR r1, [r0, #GPIOA_ODR]
    BIC r1, r1, #GPIO_ODR5
    STR r1, [r0, #GPIOA_ODR]

    LDR r2, =SHORT_DELAY
    BL delay

    POP {pc}

word_pause:
    PUSH {lr}

    LDR r2, =WORD_DELAY
    BL delay

    POP {pc}

delay:
delay_loop:
    SUBS r2, r2, #1
    BNE delay_loop
    BX lr

.size main, .-main
