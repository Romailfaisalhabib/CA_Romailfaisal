# ==========================================
# INITIALIZATION
# ==========================================
# PC = 0
addi x14, x0, 512      # x14 = Base address for LEDs (0x200)
# PC = 4
addi x13, x0, 768      # x13 = Base address for Switches (0x300)

# ==========================================
# STATE 1: INPUT WAITING (IDLE)
# ==========================================
# PC = 8 (wait)
lw   x5, 0(x13)        # Read current switch values into x5
# PC = 12
beq  x5, x0, -4        # If switches == 0, jump back to PC 8 (12 - 4 = 8)

# ==========================================
# STATE 2: COUNTDOWN
# ==========================================
# PC = 16 (loop)
sw   x5, 0(x14)        # Write current counter value to LEDs
# PC = 20
beq  x5, x0, -12       # If counter == 0, jump back to wait state at PC 8 (20 - 12 = 8)
# PC = 24
addi x5, x5, -1        # Decrement counter by 1
# PC = 28
beq  x0, x0, -12       # Always taken: jump back to loop at PC 16 (28 - 12 = 16)