# LISITING 3.1
main:
    li x10, 5             # n = 5
    li x2, 0x200          # stack address
    jal x1, fact          # Call factorial
    addi x11, x10, 0      # Put answer in x11
    li x10, 1             # print integer
    ecall
    j end

fact:
    addi sp, sp, -8     # create stack for 2 integers
    sw x10 , 0(sp)      # save argument n

    sw x1 , 4(sp)       # save return address
    addi x5 , x10 , -1  # x5 = n - 1 
    bge x5 , x0 , L1    # check if x5 >= 0 then move to L1

    addi x10 , x0 , 1   # return 1
    addi sp , sp , 8    # pop stack
    jalr x0 , 0(x1)     # return answer back to main

L1:
    addi x10 , x10 , -1 # decrement n by 1
    jal x1 , fact       # recursive call

    addi x6 , x10 , 0   # save fact( n - 1 )
    lw x10 , 0(sp)      # restore original val of x10
    lw x1 , 4(sp)       # restore return address
    addi sp , sp , 8    # pop stack

    mul x10 , x10 , x6  # n * fact ( n - 1 )
    jalr x0 , 0(x1)     # return 
end:
    j end

# # --> part (b)
# main:
#     li x10, 5             # n = 5
#     jal x1, fact_iter     # Call factorial
#     addi x11, x10, 0      # Move result to x11
#     li x10, 1             # Print integer
#     ecall
#     j end

# fact_iter:
#     li x5, 1              # acc = 1
# loop:
#     bge x0, x10, done     # if n <= 0, finish
#     mul x5, x5, x10       # acc = acc * n
#     addi x10, x10, -1     # n = n - 1
#     jal x0, loop          # Repeat

# done:
#     addi x10, x5, 0       # Return acc
#     jalr x0, 0(x1)        # Return

# end:
#     j end