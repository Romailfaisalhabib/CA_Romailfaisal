main:
    # Create array: [5, 2, 8, 1, 4]
    li x10, 0x200        # starting address
    li x5, 1
    sb x5, 0(x10)
    li x5, 2
    sb x5, 1(x10)
    li x5, 2
    sb x5, 2(x10)
    li x5, 9
    sb x5, 3(x10)
    li x5, 10
    sb x5, 4(x10)
    
    li x10, 0x200   # x10 = array address
    li x11, 5       # x11 = length
    jal x1, bubble  # Call bubble sort

    j end   # Exit and end procedure

# Bubble Sort to Sort in descending order
bubble:
    li x5, 0             # i = 0
outer_loop:
    bge x5, x11, done    # if i >= len, finish
    addi x6, x5, 0       # j = i
inner_loop:
    bge x6, x11, next_i  # if j >= len
    # Get a[i]
    add x28, x10, x5
    lbu x29, 0(x28)
    # Get a[j]
    add x30, x10, x6
    lbu x31, 0(x30)     
    bge x29, x31, no_swap
    # Swap
    addi x7, x29, 0      # temp = a[i]
    sb x31, 0(x28)       # a[i] = a[j]
    sb x7, 0(x30)        # a[j] = temp
no_swap:
    addi x6, x6, 1       # j++
    jal x0, inner_loop
next_i:
    addi x5, x5, 1       # i++
    jal x0, outer_loop
done:
    jalr x0, 0(x1)
end:
    j end