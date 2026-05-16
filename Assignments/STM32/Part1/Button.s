@ ============================================
@ Title:   STM32 On-Board Button Usage
@ Author:  Christy Sahayaraj
@ Date:    05/16/2026
@ Version: 1
@ Purpose: STM32 NUCLEO-L476RG Module On-Board Button Usage
@ Outcome: Using the on-board button to make the LED ON & OFF

@ ============================================

.syntax unified
.thumb
.cpu cortex-m4

@ =================================================
@ RCC Registers
@ =================================================
.equ RCC_BASE,        0x40021000
.equ RCC_AHB2ENR,     0x4C

@ =================================================
@ GPIOA (LED)
@ =================================================
.equ GPIOA_BASE,      0x48000000
.equ GPIOA_MODER,     0x00
.equ GPIOA_ODR,       0x14

@ =================================================
@ GPIOC (BUTTON)
@ =================================================
.equ GPIOC_BASE,      0x48000800
.equ GPIOC_MODER,     0x00
.equ GPIOC_IDR,       0x10

@ =================================================
@ Bit Definitions
@ =================================================
.equ GPIOAEN,         (1 << 0)
.equ GPIOCEN,         (1 << 2)

.equ PA5_MASK,        (3 << 10)
.equ PA5_OUTPUT,      (1 << 10)

.equ PC13_MASK,       (3 << 26)

.equ LED_PIN,         (1 << 5)
.equ BUTTON_PIN,      (1 << 13)

@ =================================================
@ Delay Values
@ =================================================
.equ FAST_DELAY,      0x30000
.equ SLOW_DELAY,      0x180000

.global main
.type main, %function

main:

@ =================================================
@ Enable GPIOA and GPIOC clocks
@ =================================================
LDR r0, =RCC_BASE
LDR r1, [r0, #RCC_AHB2ENR]

ORR r1, r1, #GPIOAEN
ORR r1, r1, #GPIOCEN

STR r1, [r0, #RCC_AHB2ENR]

@ =================================================
@ Configure PA5 as OUTPUT
@ =================================================
LDR r0, =GPIOA_BASE

LDR r1, [r0, #GPIOA_MODER]

BIC r1, r1, #PA5_MASK
ORR r1, r1, #PA5_OUTPUT

STR r1, [r0, #GPIOA_MODER]

@ =================================================
@ Configure PC13 as INPUT
@ =================================================
LDR r0, =GPIOC_BASE

LDR r1, [r0, #GPIOC_MODER]

BIC r1, r1, #PC13_MASK

STR r1, [r0, #GPIOC_MODER]

@ =================================================
@ Main Loop
@ =================================================
loop:

@ Read button state
LDR r0, =GPIOC_BASE
LDR r1, [r0, #GPIOC_IDR]

TST r1, #BUTTON_PIN

BEQ fast_blink

@ =================================================
@ Slow Blink
@ =================================================
LDR r4, =SLOW_DELAY
B blink

fast_blink:

@ =================================================
@ Fast Blink
@ =================================================
LDR r4, =FAST_DELAY

blink:

@ =================================================
@ Toggle LED
@ =================================================
LDR r0, =GPIOA_BASE

LDR r1, [r0, #GPIOA_ODR]

EOR r1, r1, #LED_PIN

STR r1, [r0, #GPIOA_ODR]

@ =================================================
@ Delay
@ =================================================
MOV r2, r4

delay_loop:
SUBS r2, r2, #1
BNE delay_loop

B loop

.size main, .-main
