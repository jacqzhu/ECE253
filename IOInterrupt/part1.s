.global _start
_start:

	.equ LEDs,  	  0xFF200000
	.equ TIMER, 	  0xFF202000
	.equ PUSH_BUTTON, 0xFF200050
	.equ TOP_COUNT, 25000000

	#Set up the stack pointer
	
	li sp, 0x20000
	la s2, TIMER	#s2 = address of TIMER
	la s3, PUSH_BUTTON	#s3 = address of KEYs
	
	jal CONFIG_TIMER        # configure the Timer
    jal CONFIG_KEYS         # configure the KEYs port
	
	/*Enable Interrupts in the NIOS V processor, and set up the address handling
	location to be the interrupt_handler subroutine*/
	
	# setting up the interrupt for timer and keys
	csrw mstatus, zero	#disable interrupts
	li t0, 0x50000	#IRQ 16 (TIMER) & 18 (KEYs)
	csrw mie, t0	#set IRQ16&18
	la t0, interrupt_handler	#t0 = address of interrupt_handler
	csrw mtvec, t0	#set address of interrupt_handler
	li t0, 8	#t0 = 0b1000
	csrw mstatus, t0	#enable interrupts
	
	la s0, LEDs	#s0 = address of LEDs
	la s1, COUNT	#s1 = address of COUNT
	
LOOP:
	lw s2, 0(s1)	# Get current count
	sw s2, 0(s0)	# Store count in LEDs
	j LOOP
	
interrupt_handler:
	addi sp, sp, -16	#add 4 bytes to stack
	sw s0, 12(sp)	#write address of LEDs
	sw s1, 8(sp)	#write address of COUNT
	sw s2, 4(sp)	#write COUNT
	sw s3, 0(sp)	#write address of KEYs
	csrr s0, mcause	#cause of interrupt into s0
	li s1, 0x80000010	#value for timer
	beq s0, s1, Timer_ISR	#branch if cause is timer
	li s1, 0x80000012	#value for keys
	beq s0, s1, KEYs_ISR	#branch if cause is key
	j RETURN

RETURN:
	lw s0, 12(sp)	#s0 = address of LEDs
	lw s1, 8(sp)	#s1 = address of COUNT
	lw s2, 4(sp)	#s2 = count
	lw s3, 0(sp)	#s3 = address of KEYs
	addi sp, sp, 16	#pop from stack
	mret

Timer_ISR:
	la s1, COUNT	#s1 = address of COUNT
	la s2, RUN	#s2 = address of RUN
	lw s0, 0(s1)	#s0 = COUNT
	lw s3, 0(s2)	#s3 = RUN
	add s0, s0, s3	#increment COUNT by RUN
	and s0, s0, 0x0FF	#mask/clean first 8 bits
	la s2, TIMER	#s2 = address of TIMER
	sw s0, 0(s1)	#save new COUNT value
	sw zero, 0(s2)	#save new RUN; RUN = 0
	j RETURN
	
KEYs_ISR:
	la s1, PUSH_BUTTON	#s1 = address of KEYs
	la s2, RUN	#s2 = address of RUN
	lw s3, 0(s2)	#s3 = RUN
	xori s3, s3, 1	#toggle RUN
	andi s3, s3, 1	#and with 1
	sw s3, 0(s2)	#save new RUN
	li s0, 0b1111	#s0 = 1111
	sw s0, 12(s1)	#clear edgecapture of KEYs
	j RETURN

CONFIG_TIMER:
	li t1, TOP_COUNT	#t1 = TOP_COUNT
	srli t2, t1, 16 #shift TOP_COUNT right (higher 16 bits)
	sw t2, 12(s2)	#write higher 16 bits to TIMER
	sw t1, 8(s2)	#write lower 16 bits to TIMER
	li t3, 0b0111	#t3 = 0b0111 (timer settings)
	sw t3, 4(s2)	#set timer settings: start, continue, enable interrupts from timer
ret

CONFIG_KEYS: 
	li t0, 0xF	#t0 = 0b1111
	sw t0, 8(s3)	#allow interrupts from all keys
	sw t0, 12(s3)	#clear edgecapture
ret

.data
/* Global variables */
.global  COUNT
COUNT:  .word    0x0            # used by timer
.global  RUN                    # used by pushbutton KEYs
RUN:    .word    0x1            # initial value to increment COUNT
.end
