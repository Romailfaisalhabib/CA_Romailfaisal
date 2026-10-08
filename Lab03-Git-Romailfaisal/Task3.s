.text
.globl main
main:
    li x22, 0 #--> i = Value to increment in both loops
    li x23, 0 #--> sum
    li x19, 3 #--> final limit for i < 10
    li x18, 0 # --> temp variable
    for_loop1:
        li x6, 0x200 #--> loading address in register
        slli x7, x22, 2 #--> a[i] = incrementing index to store correct index value into memory
        add x7, x6, x7
        sw x22, 0(x7) # --> storing value into memory
        addi x22, x22, 1 #--> incrementing i = i + 1
        beq x22, x19, exit_for_loop1 # end condition 
        bne x22, x19, for_loop1 # repeating loop condition
    exit_for_loop1:
    li x10, 0x200 # v[]
    li x11, 1 # k
    li x12, 1 # Temp1
    li x13, 2 # Temp2
    li x14, 0
    jal x1, swap
    lw x11, 4(x10)
    li x10, 1
    ecall
    j exit
    swap:
        slli x11, x12, 2 # k *4
        add x13, x11, x10 # address = 0x200 + (4k)
        lw x12, 0(x13)      # 
        lw x14, 4(x13)
        sw x14, 0(x13)
        sw x12, 4(x13)
        jalr x0, 0(x1)
    exit:
end:
    j end