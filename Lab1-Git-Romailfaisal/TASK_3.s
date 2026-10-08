# --- Task 1 --- converting below code into RISC-V

#   int a = 5;
#   int b = 0 + 0;
#   a = b + 32;
#   int d = (a + b) - 5;
#   int e = (((a - d) + (b - a)) + d);
#   e = a + b + d + e;

.text
.globl main
main:
    li x19, 5           # x19 = a = 5
    addi x20, x0, 0     # x20 = x0 + 0 -> b = 0 + 0
    addi x19, x20, 32   # a = b + 32
    add x21, x19, x20   # x21 = x19 + x20 -> c = a + b
    addi x22, x21, -5   # d = x21 - 5 -> d = (a + b) - 5
    sub x16, x19, x22   # x16 = a - d
    sub x17, x20, x19   # x17 = b - a
    add x18, x16, x17   # x18 = x16 + x17 -> x18 = (a - d) + (b - a)
    add x19, x18, x22   # x19 = x18 + x22 -> e = (((a - d) + (b - a)) + d)
    add x15, x21, x22   # x15 = a + b + d
    add x19, x15, x19   # e = a + b + d + e
end:
    j end
