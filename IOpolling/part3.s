.equ TIMER, 0xFF202000          # Base address of Timer
.equ LEDS, 0xFF200000          # Base address of LEDs
.equ KEYS, 0xFF200050           # Base address of Push Button Keys
.equ DELAY, 25000000          # 0.25-second delay in hardware timer

.global _start
.text

_start:
    li s0, TIMER
	li s1, LEDS
	li s2, KEYS
	li s3, DELAY           
	sw s3, 8(s0)    		
	li s3, 2                  
    sw s3, 4(s0)
    li s3, 0xF   
    sw s3, 12(s2)    
	sw zero, 0(s0)

main_loop:
    lw t0, 0(s2)             # Read keys
    beqz t0, main_loop             

wait_release:
	lw t1, 0(s2)             # Wait for key release
    bnez t1, wait_release
	li t2, 0xF
	li s4, 3
	sw t2, 12(s2)

start_timer:
	li s3, 6
	sw s3, 4(s0)

poll_timer:
    lw t1, 0(s0)         
	lw t2, 12(s2)
	bnez t2, key_pressed
	bne t1, s4, poll_timer
	
timeout:
	li t3, 0
	sw t3, 0(s0)      
	lw t1, 0(s1)
	li t2, 255                     # Maximum counter value
    bge t1, t2, reset_leds         
	addi t1, t1, 1                  # Increment counter
    j update_leds
	
reset_leds:
    li t1, 0                        # Reset counter to 0

update_leds:
    sw t1, 0(s1)                    # Output counter to LEDs
    li t2, 0xF
	sw t2, 12(s2)
	j start_timer

key_pressed:
	li t2, 0xF
	sw t2, 12(s2)
	j main_loop
