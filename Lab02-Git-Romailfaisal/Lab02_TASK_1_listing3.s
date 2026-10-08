.text
.globl main
main:
    # --- Task 1 --- > Listing 3
        bne x22, x23, If # -> Executes when both register not equal
        beq x0, x0, Else # -> Executes when both register equal
    If:
        sub x19, x20, x21
    Else:
        add x19, x1, x21
        # code executed
    

    
end:
    j end