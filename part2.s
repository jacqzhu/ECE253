.global _start
_start:

	.equ LEDs,  	  0xFF200000
	.equ TIMER, 	  0xFF202000
	.equ PUSH_BUTTON, 0xFF200050

	#Set up the stack pointer
	
	li sp, 0x20000	#sp is stack pointer
	la s2, TIMER	#s2 = address of TIMER
	la s3, PUSH_BUTTON	#s3 - address of KEYs
	
	jal CONFIG_TIMER        # configure the Timer
    jal CONFIG_KEYS         # configure the KEYs port
	
	/*Enable Interrupts in the NIOS V processor, and set up the address handling
	location to be the interrupt_handler subroutine*/
	
	# setting up the interrupt for timer and keys
	csrw mstatus, zero	#disable interrupts
	li t0, 0x50000	#IRQ16 (TIMER) & IRQ18 (KEYs)
	csrw mie, t0	#set IRQ16&IRQ18
	la t0, interrupt_handler	#t0 = address of interrupt_handler
	csrw mtvec, t0	#set address of interrupt_handler
	li t0, 8	#t0 = 1000
	csrw mstatus, t0	#turn on interrupts
	
	la s0, LEDs	#s0 = address of LEDs
	la s1, COUNT	#s1 = address of COUNT
	
LOOP:
	lw s2, 0(s1)          # Get current count
	sw s2, 0(s0)          # Store count in LEDs
	j LOOP
	
interrupt_handler:
	addi sp, sp, -16	#add 4 bytes to stack
	sw s0, 12(sp)	#write address of LEDs
	sw s1, 8(sp)	#write address of COUNT
	sw s2, 4(sp)	#write COUNT
	sw s3, 0(sp)	#write address of KEYs
	csrr s0, mcause	#cause of interrupt into s0
	li s1, 0x80000010	#value for timer
	beq s0, s1, Timer_ISR	#branch if interrupt caused by timer
	li s1, 0x80000012	#value for keys
	beq s0, s1, KEYs_ISR	#branch if interrupt caused by key
	j RETURN

RETURN:
	lw s0, 12(sp)	#s0 = address of LEDs
	lw s1, 8(sp)	#s1 = address of COUNT
	lw s2, 4(sp)	#s2 = COUNT
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
	sw s0, 0(s1)	#save new COUNT
	sw zero, 0(s2)	#save new RUN; RUN = 0??
	j RETURN
	
KEYs_ISR:
	la s0, PUSH_BUTTON	#s0 = address of KEYs
	lw s1, 12(s0)	#s1 = edgecapture

CHECK0:
	li s2, 1	#s2 = 1
	and s3, s2, s1	#s3 = status of KEY0
	bne s3, s2, CHECK1	#branch if KEY0 wasn't pressed
	la s2, RUN	#s2 = address of RUN
	lw s3, 0(s2)	#s3 = RUN
	xori s3, s3, 1	#toggle RUN
	andi s3, s3, 1	#
	sw s3, 0(s2)	#save new RUN
	li s2, 0b1111	#for resetting edgecapture
	sw s2, 12(s0)	#reset edgecapture
	j RETURN
	
CHECK1:
	li s2, 2	#s2 = 0b10
	and s3, s2, s1	#s3 = status of KEY1
	bne s3, s2, CHECK2	#branch if KEY1 wasn't pressed
	la s3, TOP_COUNT	#s3 = address of TOP_COUNT
	lw s2, 0(s3)	#s2 = TOP_COUNT
	srli s2, s2, 1	#shift by 1 to the right (logical) (divide by 2 --> lower frequency therefore faster)
	li s1, 780470	#min value
	ble s2, s1, CHANGE	#if TOP_COUNT is less than/equal to min value, branch
	j UPDATE
	

CHECK2:
	li s2, 4	#s2 = 0b100
	and s3, s2, s1	#s3 = status of KEY2
	bne s3, s2, RETURN	#branch if KEY2 wasn't pressed (delulu! :) )
	la s3, TOP_COUNT	#s3 = address of TOP_COUNT
	lw s2, 0(s3)	#s3 = TOP_COUNT
	slli s2, s2, 1	#shift left by 1 (multiply by 2 --> higher frequency therefore slower)
	li s1, 1600000000	#max value
	bgeu s2, s1, CHANGE	#if TOP_COUNT is greater than/equal to max value, branch
	j UPDATE
	
CHANGE:
	mv s2, s1	#s2 = s1 (s1 is min or max value; depends which label we came from)
	j UPDATE

UPDATE:
	sw s2, 0(s3)	#write TOP_COUNT value into TOP_COUNT address
	la s3, TIMER	#s3 = address of TIMER
	srli s1, s2, 16	#shift TOP_COUNT right by 16
	sw s1, 12(s3)	#save higher bits of TOP_COUNT to TIMER
	sw s2, 8(s3)	#save lower bits to TIMER
	li s1, 0b0111	#s1 = 0b0111 (settings for timer)
	sw s1, 4(s3)	#write settings to timer (start, continue, allow interrupts)
	li s2, 0b1111	#s2 = 0b1111 (for reset edgecapture)
	sw s2, 12(s0)	#reset edgecapture
	j RETURN

CONFIG_TIMER:
	la t0, TOP_COUNT	#t0 = address of TOP_COUNT
	lw t1, 0(t0)	#t1 = TOP_COUNT
	srli t2, t1, 16	#shift TOP_COUNT right by 16 (higher bits)
	sw t2, 12(s2)	#save higher bits to TIMER
	sw t1, 8(s2) 	#save lower bits to TIMER
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
.global TOP_COUNT
TOP_COUNT:	.word 	25000000
.end
