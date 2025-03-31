		.thumb
		.global main
aSystemControlBase: .field 0x400FE000,32 ; Base address for the System Control registers (which includes RCGCGPIO)
bit5: .equ 0x20 ; bit 5 enables GPIO port F
oRCGCGPIO: .equ 0x608 ; offset for RCGCGPIO from base SystemControl registers address
aGPIOFBase: .field 0x40025000,32 ; Base address for GPIOPort F registers (APB)
;pin1: .equ 0x02 ; bit 2 high only, for setting pin2direction, etc.
pin4: .equ 0x10 ; bit 4 high only, or 0001.0000
pins2and3: .equ 0x0E
pins2and3and4: .equ 0x1E
oGPIODIR: .equ 0x400 ; offset for GPIODIR (pin direction)from any GPIO port base address
oGPIODEN: .equ 0x51C ; offset for GPIODEN (digital I/O) fromany GPIO port base address
oGPIOPUR: .equ 0x510 ; offset for GPIOPUR (pull-up resistor)from any GPIO port base address
swread: .equ 0x040 ; offset for GPIODATA from any GPIOport base address, further offset to mask pin 4 to allow read
oWrite: .equ 0x30 ; offset for GPIODATA from any GPIOport base address, further offset to mask pin 2 to allow write
; 32 16 8 4 2 1
;    256    16
main:	.asmfunc
; Your code goes here


							; config is setting pins to work how we want

				; this section deals with turning the system clock on
config:	    LDR R0, aSystemControlBase
			MOV R1, #bit5
			STR R1, [R0, #oRCGCGPIO] ; very common, load, move, store

		   ; this section deals with setting up lights

			;GPIODIR: direction
			LDR R0, aGPIOFBase  ; only care about output pins, need 1s
			MOV R1, #pins2and3		; enables port f pins 2 and 3
			STR R1, [R0, #oGPIODIR]

			;GPIODEN: digital enable
			LDR R0, aGPIOFBase
			MOV R1, #pins2and3and4
			STR R1, [R0, #oGPIODEN]

			;GPIOPUR: pull up resister for button
			LDR R0, aGPIOFBase
			MOV R1, #pin4
			STR R1, [R0, #oGPIOPUR]

			;for reading from the switch
impl:  		LDR R3, [R0, #swread]
			CMP R3, #pin4 	; pin4 is 0x10
			BEQ off

on:			MOV R4, #pins2and3 	; 0xFF will work, anything that sets the bit (not 0x01)
			STR R4, [R0, #oWrite]
			B 	impl

off:		MOV R4, #0 ; writing to an LED
			STR R4, [R0, #oWrite]
			B 	impl




loop:		MOV R0, R0
			B loop
			.endasmfunc
			.end

