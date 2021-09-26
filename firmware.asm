; 
; Project name: led-blink-example
; Description: Blink an led every one second
; Source code: https://github.com/sergeyyarkov/attiny24a_led-blink-example
; Device: ATtiny24A
; Package: 14-pin-PDIP_SOIC
; Assembler: gavrasm v5.0
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

.equ oVal = 20             ; If set to 0, then this value is decremented to 255
.equ iVal = 10000           ; Value of cycles in inner delay loop

.org 0x00                   ; Start program at 0x00
.cseg                       ; Code segment

main:                       ; Start up program
  init_stack_p r16, RAMEND
  rcall init_ports          ; Initialize MCU ports
  rcall _r_inner_delay_loop ; Initialize delay inner loop value
  rcall _r_outer_delay_loop           ; Intialize delay outer loop value

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

delay_1s_outer_l:
  rcall _r_inner_delay_loop

delay_1s:
  sbiw r24, 1               ; Decrement inner loop value
  brne delay_1s             ; Jump to inner loop again

  rcall _r_inner_delay_loop ; Reset inner loop value

  dec r18                   ; Decremnt outer loop value
  brne delay_1s_outer_l     ; Jump to outer loop again
  rcall _r_outer_delay_loop
ret

_r_inner_delay_loop:        ; Reset inner delay loop
  ldi r24, low(iVal)
  ldi r25, high(iVal)
ret

_r_outer_delay_loop:        ; Reset outer delay loop
  ldi r18, oVal
ret