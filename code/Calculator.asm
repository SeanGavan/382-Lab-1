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
myProgram:      .byte      0x22, 0x11, 0x22, 0x22, 0x33, 0x33, 0x08, 0x44, 0x08, 0x22, 0x09, 0x44, 0xff, 0x11, 0xff, 0x44, 0xcc, 0x33, 0x02, 0x33, 0x00, 0x44, 0x33, 0x33, 0x08, 0x55

                .data
myResults:      .space      20

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
readers:									; reads in the calculator inputs, init the RAM space,
			mov.w	#myResults, r10			; sets registers for first operand, operation, and second operand
			mov.w	#myProgram, r5
			mov.b	@r5+, r6
			mov.b	@r5+, r7
			mov.b	@r5+, r8

checks:										; finds the next operation and next second operand,
			mov.b	@r5+, r12				; checks to find what operation to perform
			mov.b	@r5+, r13
			cmp.b	#0x11, r7
			jeq		checkADD
			cmp.b	#0x22, r7
			jeq		checkSUB
			cmp.b	#0x33, r7
			jeq		checkMUL
			jmp		NOOP

checkADD:									; adds w/ a check to make sure that the value does
			mov.b	r6, r9					; not exceed the max (255)
			add.w	r8, r9					; r9 will be used throughout in order to store the result
			cmp.w	#0x00FF, r9				; and reuse the result as the first operand
			jge		overMax
			jmp		storeAnswer
overMax:
			mov.b	#0xFF, r9
			jmp		storeAnswer

checkSUB:									; subs w/ a check to make sure that the value does
			mov.b	r6, r9					; not go below the minimum (0)
			sub.w	r8, r9
			cmp.w	#0x0000, r9
			jl		underMin
			jmp		storeAnswer
underMin:
			mov.b	#0x00, r9
			jmp		storeAnswer

checkMUL:									; adds the first operand to the result x times, where
			clr.b	r9						; x = r8; decrements 8 in order to determine # of times
multiply:									; stays within max value (255) and checks for *0 case
			add.w	r6, r9					; Uses O(n)
			cmp.b	#0x00, r8
			jeq		zeroCase
			cmp.w	#0x00FF, r9
			jge		overMax
			dec.b	r8
			cmp.b	#0x00, r8
			jeq		storeAnswer
			jge		multiply
zeroCase:
			clr.b	r9
			jmp		storeAnswer

checkCLR:									; uses extra registers in conjunction with the next
			mov.b	@r5+, r14				; second operand to use a fresh first operand and operation
			mov.b	@r5+, r15
			mov.b	r13, r6
			mov.b	r14, r7
			mov.b	r15, r8
			mov.b	#0x00, 0(r10)
			inc.w	r10
			jmp		checks


storeAnswer:								; stores the results from operations
			mov.b	r9, 0(r10)
			inc.w	r10
			jmp		next

next:										; checks if the next operation is a clear or
			cmp.b	#0x44, r12				; end op, and jumps as needed; also sets the new
			jeq		checkCLR				; operands and operation
			cmp.b	#0x55, r12
			jeq		checkEND
			mov.b	r9, r6
			mov.b	r12, r7
			mov.b	r13, r8
			jmp		checks

checkEND:									; loops to terminate the program or in case of
			jmp		checkEND				; invalid input for an operation

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
