@ ============================================
@ Title:   STM32 LED Blinking D7 (PA8)
@ Author:  Christy Sahayaraj
@ Date:    05/19/2026
@ Version: 1
@ Purpose: STM32 NUCLEO-L476RG Module D7 (PA8) LED Blinking
@ Outcome: Learning on how 32-Bit MC STM32 Works. It's a low power consumption module "L"
@          Perfect for embedded labs.

@ ============================================

.syntax unified
.thumb
.cpu cortex-m4

@ ============================================
@ STM32 External LED Blinking on D7 (PA8)
@ ============================================

.equ RCC_BASE,      0x40021000
.equ RCC_AHB2ENR,   0x4C

.equ GPIOA_BASE,    0x48000000
.equ GPIOA_MODER,   0x00
.equ GPIOA_ODR,     0x14

@ Enable GPIOA clock
.equ RCC_AHB2ENR_GPIOAEN, (1 << 0)

@ PA8 mode bits = bits 17:16
.equ GPIO_MODER8_MASK,    (3 << 16)
.equ GPIO_MODER8_OUT,     (1 << 16)

@ PA8 output bit
.equ GPIO_ODR8,           (1 << 8)

.equ DELAY_COUNT, 0x40000

.global main
.type main, %function

main:

@ ----------------------------------------
@ Enable GPIOA clock
@ ----------------------------------------
    LDR r0, =RCC_BASE

    LDR r1, [r0, #RCC_AHB2ENR]

    ORR r1, r1, #RCC_AHB2ENR_GPIOAEN

    STR r1, [r0, #RCC_AHB2ENR]

@ ----------------------------------------
@ Configure PA8 as output
@ ----------------------------------------
    LDR r0, =GPIOA_BASE

    LDR r1, [r0, #GPIOA_MODER]

    BIC r1, r1, #GPIO_MODER8_MASK

    ORR r1, r1, #GPIO_MODER8_OUT

    STR r1, [r0, #GPIOA_MODER]

@ ----------------------------------------
@ Blink forever
@ ----------------------------------------
loop:

@ Toggle PA8
    LDR r1, [r0, #GPIOA_ODR]

    EOR r1, r1, #GPIO_ODR8

    STR r1, [r0, #GPIOA_ODR]

@ Delay
    LDR r2, =DELAY_COUNT

delay_loop:
    SUBS r2, r2, #1

    BNE delay_loop

    B loop

.size main, .-main
