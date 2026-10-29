# Lab 10: FSM (switches -> countdown) in RISC-V
# LEDs       = 0x200 (W)
# Switches   = 0x300 (R)
# Reset      = 0x304 (R)
#
# x18 = LED address
# x19 = switch address
# x20 = reset button address
# x8  = countdown counter
# x10 = argument / return value
# x5, x6, x7 = temporary registers
 
main:
    addi sp,  x0, 0x1F0       # Initialize stack pointer
    addi x18, x0, 0x200       # LED register address
    addi x19, x0, 0x300       # Switch register address
    addi x20, x0, 0x304       # Reset button address
 
    sw   x0, 0(x18)           # Clear LEDs
 
# STATE 1: WAIT FOR INPUT
wait_state:
    lw   x7, 0(x20)           # Read reset button
    beq  x7, x0, read_sw      # If reset not pressed, read switches
 
    sw   x0, 0(x18)           # Reset pressed: clear LEDs
    beq  x0, x0, wait_state   # Stay in waiting state
 
read_sw:
    lw   x10, 0(x19)          # Read switch value
    beq  x10, x0, wait_state  # If zero, keep waiting
 
    sw   x10, 0(x18)          # Display starting value
    jal  x1, countdown        # Call countdown subroutine
    beq  x0, x0, wait_state   # Return to waiting state
 
 
# SUBROUTINE: countdown
# Argument: x10 = initial count
countdown:
    addi sp, sp, -8           # Make space on stack
    sw   x1, 4(sp)            # Save return address
    sw   x8, 0(sp)            # Save counter register
 
    addi x8, x10, 0           # Copy initial value to counter
 
count_loop:
    sw   x8, 0(x18)           # Display current counter
    beq  x8, x0, count_done   # If zero, finish countdown
 
    jal  x1, delay            # Call delay subroutine
    beq  x10, x0, count_next  # If no reset, continue countdown
 
    # Reset was pressed
    sw   x0, 0(x18)           # Clear LEDs
    beq  x0, x0, count_done   # Finish countdown
 
count_next:
    addi x8, x8, -1           # Decrement counter
    beq  x0, x0, count_loop   # Repeat countdown
 
count_done:
    lw   x8, 0(sp)            # Restore counter register
    lw   x1, 4(sp)            # Restore return address
    addi sp, sp, 8            # Restore stack pointer
 
    jalr x0, 0(x1)            # Return to main
 
 
# SUBROUTINE: delay
# Returns x10 = 1 if reset pressed, 0 otherwise
delay:
    addi x5, x0, 977           # Initial delay count
    addi x6, x0, 10            # Shift amount
    sll  x5, x5, x6            # x5 = 977 << 10
 
delay_loop:
    lw   x7, 0(x20)            # Read reset button
    beq  x7, x0, delay_cont     # If not pressed, continue delay
 
    addi x10, x0, 1             # Reset detected
    jalr x0, 0(x1)              # Return to countdown
 
delay_cont:
    addi x5, x5, -1             # Decrease delay counter
    beq  x5, x0, delay_end      # If zero, delay is complete
    beq  x0, x0, delay_loop     # Repeat delay
 
delay_end:
    addi x10, x0, 0             # No reset detected
    jalr x0, 0(x1)              # Return to countdown
