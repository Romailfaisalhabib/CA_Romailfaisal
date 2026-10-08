.text
.globl main
main:
    addi x10, x0, 12    # a  
    addi x11, x0, 12    # b
    jal x1, sum         # calls the function named sum
    addi x11, x10, 0    # value of x11 to be printed by ecall
    li x10, 1           # x10 = 1 to print x11
    ecall
    j exit
    sum:
        add x10, x11, x10
        jalr x0, 0(x1) # return back 
    exit:
end:
    j end