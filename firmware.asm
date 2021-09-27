; 
; Project name: led-blink-example
; Description: Blink an led every one second
; Source code: https://github.com/sergeyyarkov/attiny24a_led-blink-example
; Device: ATtiny24A
; Package: 14-pin-PDIP_SOIC
; Assembler: gavrasm v5.0
; Clock frequency: 8MHz with CKDIV8
; Fuses: lfuse: 0x42, hfuse: 0xDF, efuse: 0xFF, lock:0xFF
;
; Written by Sergey Yarkov 23.09.2021

.device ATtiny24A           ; Setup device name
.list                       ; Enable listing

.macro init_stack_p         ; Setup stack pointer
  ldi @0, low(@1)
  out SPL, @0
.endm

.equ LED_DIR = DDRA         ; LED Direction
.equ LED_PORT = PORTA       ; LED Port
.equ LED_PIN = PINA0        ; LED Pin

.org 0x00                   ; Start program at 0x00
.cseg                       ; Code segment

main:                       ; Start up program
  init_stack_p r16, RAMEND
  rcall init_ports          ; Initialize MCU ports

loop:                       ; Program loop
  rcall toggle_led          ; Toggle an LED
  rcall delay_1s            ; Delay for 1 sec
  rjmp loop                 ; Jump to program loop again

toggle_led:                 ; Toggle an LED
  eor r17, r16              ; Toggle bit
  out LED_PORT, r17         ; Update port of LED
ret

init_ports:                 ; Init MCU ports
  ldi r16, (1<<LED_PIN)     ; Load to r16 high bit
  out LED_DIR, r16          ; Set LED direction to output
ret

delay_1s:                   ; For 1MHz frequency 
;
; Calculate the values of count inner 
; and outer loops to obtain the desired delay.

.equ outer_count = 100
.equ inner_count = 2499

ldi r18, outer_count        ; Load outer loop counter value
  _reset:                   ; Load inner loop counter value
    ldi r24, low(inner_count)
    ldi r25, high(inner_count)
  _loop:                    ; Delay loop ; e.g inner_count*(2+2)-1 = inner loop cycles
    sbiw r24, 1             ; 2 cycles
    brne _loop              ; 2 cycles or 1

    dec r18                 ; 1 cycles
    brne _reset             ; 2 cycles or 1
    ldi r18, outer_count    
ret