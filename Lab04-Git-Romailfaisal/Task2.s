main:
    li x10, 5             # n = 5
    li x2, 0x200          # stack address
    jal x1, fact          # Call factorial
    addi x11, x10, 0      # Put answer in x11
    li x10, 1             # print integer
    ecall
    j end

fact:
    addi sp, sp, -8     # make space in stack for 2 items
    sw x10 , 0(sp)      # store arg n in stack

    sw x1 , 4(sp)       # store return address in stack
    addi x5 , x10 , -1  # x5 = ( n - 1 )
    blt x0 , x5 , L1    # is ( n - 1 ) >= 0 L1

    addi x10 , x0 , 1   # return 1
    addi sp , sp , 8    # pop stack
    jalr x0 , 0(x1)     # return answer back to main

L1:
    addi x10 , x10 , -1 # decrement by 1
    jal x1 , fact       # recursive call

    addi x6 , x10 , 0   # save result of ntri(n - 1)
    lw x10 , 0(sp)      # restore arg n
    lw x1 , 4(sp)       # restore return address
    addi sp , sp , 8    # pop stack

    add x10 , x10 , x6  # n + ntri ( n - 1 )
    jalr x0 , 0(x1)     # return 
end:
    j end