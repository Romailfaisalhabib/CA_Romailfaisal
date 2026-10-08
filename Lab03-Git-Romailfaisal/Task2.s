main:
    li x10, 1   # g
    li x11, 2   # h
    li x12, 3   # i
    li x13, 4   # j

    li x18, 0   # temp1
    li x19, 0   # temp2
    
    li x20, 0  # f
    
    li x2, 0x200    # stack base address
    addi sp, sp, -12    # making space for three registers
    jal x1, leaf_example    # call leaf_example function
    lw x11, 8(sp)       # loading x20 into x11 from stack
                        # value f in x11
    li x10, 1
    ecall
    j end

leaf_example:
    add x18, x10, x11 # g + h
    add x19, x12, x13 # i + j
    sub x20, x18, x19 # f = (g+h) - (i-j)
    sw x18, 0(sp)       # storing x18 value into stack
    sw x19, 4(sp)       # storing x19 value into stack
    sw x20, 8(sp)       # storing x20 value into stack
    jalr x0, 0(x1)
end:
    j end