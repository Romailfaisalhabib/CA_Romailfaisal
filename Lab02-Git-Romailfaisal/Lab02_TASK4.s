.text
.globl main
main:
    li x5, 3    # x5 = a = 0
    li x6, 3    # x6 = b = 0
    li x7, 0    # x7 = i =0

    first_loop:
        li x29, 0                   # x29 = j = 0
        li x10, 0                   # --> temp value for address storing
        li x16, 4                   # --> to use for D[4*j]
        second_loop:
            mul x10, x16, x29           #--> 4*j
            add x18, x7, x29            #--> x18 = i + j 
            sw x18, 0(x10)              #--> Storing i + j at D[4*j]
            addi x29, x29, 1            #--> Incrementing j = j + 1
            bne x29, x6, second_loop    #--> Condition to repeat loop
            beq x0, x0, exit2           #--> Condition to end loop
        exit2:
        addi x7, x7, 1              #--> Increment i = i + 1
        bne x7, x5, first_loop      #--> Condition to repeat loop
        beq x0, x0, exit1           #--> Condition to end loop
    exit1:
end:
    j end