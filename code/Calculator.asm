;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio

; Name: Sean Gavan
; Section: T5A
; Project: Lab 1 for ECE 382 - an assembly calculator
; Date started: 9 Sept. 14
; Date last changed: 9 Sept. 14
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
                .text
myProgram:      .byte      0x13,0x22,0x14,0x11,0x37

                .data
myResults:      .space      20

ADD_OP:		.equ	0x11

SUB_OP:		.equ	0x22

MUL_OP:		.equ	0x33

CLR_OP:		.equ	0x44

END_OP:		.equ	0x55

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
readers:
			mov.w	#store, r10
			mov.w	#myProgram, r5
			mov.b	@r5+, r6
			mov.b	@r5+, r7
			mov.b	@r5+, r8

checkADD:	cmp.b	#0x11, r7

checkSUB:	cmp.b	#0x22, r7

checkMUL:	cmp.b	#0x33, r7

checkCLR:	cmp.b	#0x44, r7

checkEND:	cmp.b	#0x55, r7


;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
