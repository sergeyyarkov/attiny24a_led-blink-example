; Project name: led-blink-example
; Description: Blink an led every one second
; Source code: https://github.com/sergeyyarkov/attiny24a_led-blink-example
; Device: ATtiny24A
; Package: 14-pin-PDIP/SOIC
; Assembler: gavrasm v5.0
;
; Written by Sergey Yarkov 23.09.2021

.device ATtiny24A
.list                       ; Enable listing

.macro init_stack_p         ; Setup stack pointer
  ldi @0, low(@1),
  out SPL, @0
.endm

.equ LED_DIR = DDRA         ; LED Direction
.equ LED_PORT = PORTA       ; LED Port
.equ LED_PIN = PINA0        ; LED Pin

.equ delay_cycles = 250 

.org 0x00                   ; Start program at 0x00
.cseg                       ; Code segment

ldi r17, delay_cycles
ldi r18, delay_cycles
ldi r19, delay_cycles

main:                       ; Start up program
  init_stack_p r16, RAMEND
  rcall init_ports          ; Initialize MCU ports

loop:                       ; Program loop
  rjmp loop

init_ports:                 ; Init MCU ports
  ldi r16, (1<<LED_PIN)
  ldi r17, (0<<LED_PIN)
  nop
  out LED_DIR, r16
  out LED_PORT, r17
ret
