.global _start
_start:
    la s2, LIST            
    addi s10, zero, 0      

MAIN_LOOP:
    lw a0, 0(s2)         
    li t1, -1 
    beq a0, t1, END      
    jal ra, ONES         
    blt s10, a0, UPDATE   
    j NEXT               

UPDATE:
    add s10, zero, a0      

NEXT:
    addi s2, s2, 4         
    j MAIN_LOOP

END: j END

ONES:
    addi sp, sp, -4     
    sw s0, 0(sp)        
    addi s0, zero, 0   

LOOP_ONES:
    beqz a0, END_ONES   
    srli t0, a0, 1      
    and a0, a0, t0      
    addi s0, s0, 1      
    j LOOP_ONES         

END_ONES:
    mv a0, s0           
    lw s0, 0(sp)        
    addi sp, sp, 4      
    ret                 

.global LIST
.data
LIST:
    .word 0x1fffffff, 0x12345678, -1, 0x7fffffff