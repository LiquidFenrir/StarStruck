/*
	starstruck - a Free Software reimplementation for the Nintendo/BroadOn IOS.
	threads - manage threads on the starlet

	Copyright (C) 2021	DacoTaco

# This code is licensed to you under the terms of the GNU GPL, version 2;
# see file COPYING or http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
*/

#include <asminc.h>

.arm
.globl SaveUserModeState
.globl RestoreAndReturnToUserMode
.globl YieldCurrentThread
.extern ScheduleYield
.extern QueueNextThread
.extern __irqstack_addr
	
BEGIN_ASM_FUNC ReturnToLr
	bx		lr
END_ASM_FUNC

#RestoreAndReturnToUserMode(registers, swi_stack)
BEGIN_ASM_FUNC RestoreAndReturnToUserMode
#ios loads the threads' state buffer back in to sp, resetting the exception's stack	
	msr 	cpsr_c, #0xd2
	ldr		sp, =__irqstack_addr

	msr 	cpsr_c, #0xd3
	mov		sp, r1
	
	msr 	cpsr_c, #0xdb
	mov		sp, r1

#restore the status register
	ldmia	r0!, {r4}
	msr		spsr_cxsf, r4
#restore the rest of the state
	ldmia	r0!, {r0-r12, sp, lr}^
	ldmia	r0!, {r1}
	
	movs	pc, r1
END_ASM_FUNC

#void YieldCurrentThread(ThreadQueue* queue)
BEGIN_ASM_FUNC YieldCurrentThread
	ldr		r1, =currentThread
	ldr		r1, [r1, #0x00]
	mrs     r2, cpsr
	str		r2, [r1, #0x00]
	stmib	r1, {r0-r12, sp, lr}^
	ldr		lr, =ReturnToLr
#load in the link register, which is at 0x40 of the registers
	str		lr, [r1, #0x40]

	cmp		r0, #0
	bne		yield
	_BL		QueueNextThread
yield:
	ldr		r0, =ScheduleYield
	bx		r0
END_ASM_FUNC
