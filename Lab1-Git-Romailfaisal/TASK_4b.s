.text
.globl main
main:
    li x20, 0x100    # x20 = a
    li x21, 0x200    # x21 = b
    li x22, 0x300    # x22 = c

    # when i == 0
    lb x17, 0(x20)
    lh x18, 0(x21)
    add x19, x17, x18
    sw x19, 0(x22)

    # when i == 1
    lb x17, 1(x20)
    lh x18, 2(x21)
    add x19, x17, x18
    sw x19, 4(x22)

    # when i == 2
    lb x17, 2(x20)
    lh x18, 4(x21)
    add x19, x17, x18
    sw x19, 8(x22)

    # i == 3
    lb x17, 3(x20)
    lh x18, 6(x21)
    add x19, x17, x18
    sw x19, 12(x22)

end:
    j end