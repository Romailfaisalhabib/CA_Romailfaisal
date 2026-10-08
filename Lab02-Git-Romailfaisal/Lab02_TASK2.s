.text
.globl main
main:
    # x21 = a
    li x20, 1                # --> x
    li x22, 2                # --> b
    li x23, 3                # --> c
    li x24, 2                # --> 2 for the divide in 
    
    # --- Diff cases ---

    li x15, 0               # --> case1
    li x16, 1               # --> case2
    li x17, 2               # --> case3
    li x18, 3               # --> case4
    li x19, 4               # --> default
    beq x20, x15, case1
    beq x20, x16, case2
    beq x20, x17, case3
    beq x20, x18, case4
    beq x20, x19, default
    case1:
        add x21, x22, x23   # a = b + c
        beq x0, x0, EXIT
    case2:
        sub x21, x22, x23   # a = b - c
        beq x0, x0, EXIT
    case3:
        mul x21, x22, x24   # a = b * 2
        beq x0, x0, EXIT
    case4:
        divu x21, x22, x24   # a = b / 2
        beq x0, x0, EXIT
    default:
        addi x21, x0, 0      # a = 0 + 0
        beq x0, x0, EXIT
    EXIT:

end:
    j end