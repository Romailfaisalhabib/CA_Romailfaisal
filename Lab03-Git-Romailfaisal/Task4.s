main:
    li x11, 0x200         # x11 = base address of source string y (0x200)
    li x10, 0x210         # x10 = base address of destination string x (0x210)

    # Values: [R, I, S, C, V]
    li x5, 82
    sw x5, 0(x11)         # y[0] = R  (at 0x200)
    li x5, 73
    sw x5, 1(x11)         # y[1] = I (at 0x204)
    li x5, 83
    sw x5, 2(x11)         # y[2] = S (at 0x208)
    li x5, 67
    sw x5, 3(x11)        # y[3] = C  (at 0x20C - termination element)
    sw x0, 5(x11)        # null byte termination (at 0x20C - termination element)
    # Call strcpy function
    jal x1, strcpy
    j end

strcpy:
    li x5, 0              # x5 = offset index i (0, 1, 2, ...)

loop:
    add x6, x11, x5       # x6 = address of y[i] (0x200 + offset)
    lw x7, 0(x6)          # x7 = load word from y[i]

    add x28, x10, x5      # x28 = address of x[i] (0x210 + offset)
    sw x7, 0(x28)         # store word into x[i]

    beq x7, x0, return       # If copied number is 0, exit loop
    return:
        jalr x0, 0(x1)        # Return to main function
    addi x5, x5, 4        # Move offset to next word element (i += 4)
    j loop                # Repeat loop

end:
    j end