.text
.globl main

main:
    # 1. Allocate 16 bytes on the stack for a 7-element byte array
    li x2, 0x200
    addi    sp, sp, -16

    # Creating array elements [2, 5, 7, 9, 10, 4, 4]
    li      x5, 2
    sb      x5, 0(sp)
    li      x5, 5
    sb      x5, 1(sp)
    li      x5, 7
    sb      x5, 2(sp)
    li      x5, 9
    sb      x5, 3(sp)
    li      x5, 10
    sb      x5, 4(sp)
    li      x5, 2
    sb      x5, 5(sp)
    li      x5, 4
    sb      x5, 6(sp)

    # 3. Set arguments and call selection_sort
    mv      x10, sp              # x10 = base address of stack
    li      x11, 7               # x11 = array size
    jal     ra, selection_sort   # calling stack


    addi    sp, sp, 16           # pop stack and exit
    li      x17, 10              # Exit system call (RARS/Venus)
    j end


# Inputs:
#   x10 = base address of byte array
#   x11 = number of elements (N)
selection_sort:
    li      x5, 1 
    ble     x11, x5, sort_done    # If N <= 1, array is already sorted
    addi    x31, x11, -1           # x31 = N - 1 (outer loop limit)
    li      x5, 0                # x5 = outer index i = 0
outer_loop:
    bge     x5, x31, sort_done    # Exit when i >= N - 1

    mv      x6, x5               # x6 = min_index (starts at i)
    add     x7, x10, x5           # x7 = address of array[i]
    lb      x28, 0(x7)            # x28 = min_value = array[i]

    addi    x29, x5, 1            # x29 = inner index j = i + 1

inner_loop:
    bge     x29, x11, do_swap      # Exit inner loop when j >= N
    add     x7, x10, x29           # x7 = address of array[j]
    lb      x7, 0(x7)            # x7 = array[j]
    bge     x7, x28, skip_update  # Skip if array[j] >= min_value
    mv      x6, x29               # min_index = j
    mv      x28, x7               # min_value = array[j]
skip_update:
    addi    x29, x29, 1            # j++ (1-byte stride)
    j       inner_loop
do_swap:
    add     x7, x10, x5           # x7 = address of array[i]
    add     x30, x10, x6           # x30 = address of array[min_index]
    lb      x29, 0(x7)            # x29 = original array[i]
    sb      x28, 0(x7)            # array[i] = min_value (using sb)
    sb      x29, 0(x30)            # array[min_index] = original array[i] (using sb)
    addi    x5, x5, 1            # i++ (1-byte stride)
    j       outer_loop
sort_done:
    ret
end:
    j end