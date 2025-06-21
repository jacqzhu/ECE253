.equ DELAY_VALUE, 10000000          # Adjust for DE1-SoC; use smaller value for CPUlator
.equ KEY_BASE, 0xFF200050           # Base address for pushbuttons
.equ LED_BASE, 0xFF200000           # Base address for LEDs
.equ EDGE_CAPTURE, 0xFF20005C       # Edge Capture register for pushbuttons

.global _start
.text

_start:
    li s0, LED_BASE                 # Load base address of LEDs
    li s1, KEY_BASE                 # Load base address of KEYs
    li s2, EDGE_CAPTURE             # Load base address of Edge Capture
    li s3, 0                        # Initialize counter to 0
    li s4, DELAY_VALUE              # Set delay value for timing
    li t2, 0                        # Pause state (0 = counting, 1 = paused)
    li t3, 0                        # Previous button state (0 = released, 1 = pressed)

MAIN_LOOP:
    sw s3, 0(s0)                    # Display counter value on LEDs

    # Check for button state
    lw t4, 0(s1)                    # Read KEYs (current button state)
    bnez t4, BUTTON_PRESSED         # If button is pressed, handle it
    j BUTTON_RELEASED               # If no button is pressed, check release

BUTTON_PRESSED:
    li t3, 1                        # Update previous state to pressed
    j CHECK_PAUSE                   # Continue to pause check

BUTTON_RELEASED:
    beqz t3, CHECK_PAUSE            # If previous state was released, skip toggle
    li t3, 0                        # Update previous state to released
    xori t2, t2, 1                  # Toggle pause state (0 -> 1 or 1 -> 0)

CHECK_PAUSE:
    beq t2, zero, CONTINUE_COUNTING # If not paused, continue counting
    j MAIN_LOOP                     # If paused, stay in main loop

CONTINUE_COUNTING:
    # Delay loop
    li t0, DELAY_VALUE
DELAY_LOOP:
    addi t0, t0, -1
    bnez t0, DELAY_LOOP

    # Increment Counter
    addi s3, s3, 1                  # Increment counter
    li t1, 255                      # Reset counter if >= 256
    bge s3, t1, RESET_COUNTER
    j MAIN_LOOP                     # Continue loop

RESET_COUNTER:
    li s3, 0                        # Reset counter to 0
    j MAIN_LOOP