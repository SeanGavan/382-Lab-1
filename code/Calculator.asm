;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio

; Name: Sean Gavan
; Section: T5A
; Project: Lab 1 for ECE 382 - an assembly calculator
; Date started: 9 Sept. 14
; Date last changed: 10 Sept. 14
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
myProgram:      .byte      0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0xDD, 0x44, 0x08, 0x22, 0x09, 0x44, 0xFF, 0x22, 0xFD, 0x55

                .data
myResults:      .space      20

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
readers:
			mov.w	#myResults, r10
			mov.w	#myProgram, r5
			mov.b	@r5+, r6
			mov.b	@r5+, r7
			mov.b	@r5+, r8

checks:
			mov.b	@r5+, r12
			mov.b	@r5+, r13
			cmp.b	#0x11, r7
			jeq		checkADD
			cmp.b	#0x22, r7
			jeq		checkSUB
			;cmp.b	#0x33, r7
			;jeq		checkMUL
			cmp.b	#0x55, r7
			jeq		checkEND
			jmp		NOOP

checkADD:
			mov.b	r6, r9
			add.w	r8, r9
			cmp.w	#0x00FF, r9
			jge		overMax
			jmp		storeAnswer

overMax:
			mov.b	#0xFF, r9
			jmp		storeAnswer

checkSUB:
			mov.b	r6, r9
			sub.w	r8, r9
			cmp.w	#0x0000, r9
			jl		underMin
			jmp		storeAnswer

underMin:
			mov.b	#0x00, r9
			jmp		storeAnswer

;checkMUL:

			;jmp		storeAnswer

checkCLR:
			mov.b	@r5+, r14
			mov.b	@r5+, r15
			mov.b	r13, r6
			mov.b	r14, r7
			mov.b	r15, r8
			mov.b	#0x00, 0(r10)
			inc.w	r10
			jmp		checks


storeAnswer:
			mov.b	r9, 0(r10)
			inc.w	r10
			jmp		next

next:
			cmp.b	#0x44, r12
			jeq		checkCLR
			cmp.b	#0x55, r12
			jeq		checkEND
			mov.b	r9, r6
			mov.b	r12, r7
			mov.b	r13, r8
			jmp		checks

checkEND:
			jmp		checkEND

NOOP:
			jmp		NOOP

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
