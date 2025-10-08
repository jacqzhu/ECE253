.global _start
.text

_start:
    la s0, LIST       # Load address of LIST
    lw s1, 0(s0)      # Load the first number (number of items)
    addi s3, zero, 0     # Flag for checking swaps (swapped = 0)

outer_loop:
    li s3, 0          # Reset swap flag
    addi s4, s1, -1   # t4 = n - 1 (number of comparisons in this pass)
    addi s2, s0, 4
    addi s1, s1, -1

inner_loop:
    beq s4, zero, check_swapped # If no comparisons left, check if swapped
    add t0, zero, s2       # Pass the address of the current element to SWAP
    jal SWAP          # Call SWAP subroutine
    addi s4, s4, -1   # Decrement counter
    addi s2, s2, 4    # Move to the next element
    j inner_loop

check_swapped:
    bnez s3, outer_loop # If swapped == 1, repeat outer loop
    j END              # Exit program

END: j END

# swap subroutine
SWAP:
    lw t1, 0(t0)      # Load the current element
    lw t2, 4(t0)      # Load the next element
    ble t1, t2, no_swap # If current <= next, no swap needed

# Perform swap
    sw t2, 0(t0)       # Store the new t0 at address s0 + 0
    sw t1, 4(t0) 
    li s3, 1          # Set return value to 1
    jr ra             # Return to caller

no_swap:
    li s3, 0     # Set return value to 0
    jr ra             # Return to caller

.global LIST
.data
LIST: 
    .word 5, 4, 3, 5, 2, 1