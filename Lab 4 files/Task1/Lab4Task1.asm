;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-03
; Author:
; Matus Maruna
; John Charo
;
; Lab number: 4
; Title: How to use timers
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Turning on an LED for 0.5 seconds every 0.5 seconds using a timer 
;
; Input ports: None.
;
; Output ports: PortB outputs to the LEDs
;
; Subroutines: "loop" is a subroutine that will loop around doing nothing while the timer is counting. 
;              "timer0_int" is a subroutine that will check wether the right amount of time has passed with a counter and then output
;               to LEDs. 
;              "restart" will reset and return to loop starting the cycle again. 
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<< <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"
.ORG 0x0000
rjmp start

.ORG OVF0addr
rjmp timer0_int

.ORG 0x72
start: 
ldi r17, 0
ldi r18, 0 
.DEF temp = r21

ldi r20, HIGH(RAMEND)
out SPH, r20
ldi r20, low(RAMEND)
out SPL, r20

ldi r16, 0x01
out DDRB,r16
ldi r17, 0x00
out portB, r17
; setting up prescaler as seen in lecture slides 
ldi temp, 0b101
out TCCR0B, temp
ldi temp,(1<<TOIE0)
sts TIMSK0, temp 
ldi temp,206
out TCNT0,temp
sei 
; waiting loop
loop: 
nop 
rjmp loop

timer0_int:
push temp 
in temp,SREG
push temp
ldi temp, 206
out TCNT0,temp
inc r22
cpi r22, 15
brne restart
ldi r22, 0
com r16
out portB, r16
rjmp restart

restart: 
pop temp
out SREG, temp 
pop temp 
reti
