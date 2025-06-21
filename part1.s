.global _start
.text

_start:
    la t0, 0xFF200000          # Load base address of LEDs
    la t1, 0xFF200050          # Load base address of Keys
    li t2, 1                 # Initialize number to 1
    li t3, 15                # Maximum value (15 in base 10)
    li t4, 1                 # Minimum value (1 in base 10)

main_loop:
    lw t5, 0(t1)             # Read Data register of Keys
    beqz t5, main_loop       # If no key pressed, continue polling

    li t6, 1
    and t6, t5, t6           # Check if KEY0 is pressed
    bnez t6, key0_pressed

    li t6, 2
    and t6, t5, t6           # Check if KEY1 is pressed
    bnez t6, key1_pressed

    li t6, 4
    and t6, t5, t6           # Check if KEY2 is pressed
    bnez t6, key2_pressed

    li t6, 8
    and t6, t5, t6           # Check if KEY3 is pressed
    bnez t6, key3_pressed

    j main_loop              # Return to main loop if no recognized key

key0_pressed:
    li t2, 1                 # Set value to 1
    j update_leds

key1_pressed:
    blt t2, t3, increment    # Only increment if less than max value
    j main_loop              # Skip LED update if out of bounds
increment:
    addi t2, t2, 1
    j update_leds

key2_pressed:
    bgt t2, t4, decrement    # Only decrement if greater than min value
    j main_loop              # Skip LED update if out of bounds
decrement:
    addi t2, t2, -1
    j update_leds

key3_pressed:
    li t2, 0                 # Blank display
    j update_leds

update_leds:
    sw t2, 0(t0)             # Update LED Data register

wait_release:
    lw t5, 0(t1)             # Wait for key release
    bnez t5, wait_release
    j main_loop