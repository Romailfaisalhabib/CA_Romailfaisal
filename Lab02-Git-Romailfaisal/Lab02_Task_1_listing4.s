.text
.globl main
main:
# --- Task 1 --- > Listing 4
    add x24, x10, x0
    Loop:
        slli x10, x22, 3
        add x10, x10, x25
        lw x9, 0(x10)
        bne x9, x25, EXIT
        addi x22, x22, 1
        beq x0, x0, Loop
    EXIT:
end:
    j end