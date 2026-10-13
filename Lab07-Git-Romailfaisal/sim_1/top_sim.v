`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: top_sim
// Target Devices: Basys 3
// Description:
// Register File + ALU + FSM integration testbench.
//////////////////////////////////////////////////////////////////////////////////
module top_sim;

    reg clk;
    reg pbin;

    // 16-BIT PHYSICAL SWITCHES
    reg [15:0] physical_sw;

    // 16-BIT PHYSICAL LEDS
    wire [15:0] physical_leds;

    // INSTANTIATION
    top_rf_alu uut (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(physical_leds)
    );

    // 10 NS PERIOD CLOCK -> 100 MHZ
    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        pbin = 1'b0;

        // ALL SWITCHES OFF
        physical_sw = 16'b0000000000000000;

        // WAIT FOR FSM TO INITIALIZE x1, x2 AND x3 (Takes 3 clock cycles)
        #40;

        // ==========================================
        // AUTO MODE TESTS (CHOICE = 0)
        // rs1 is fixed to x1 (0x10101010)
        // rs2 is fixed to x2 (0x01010101)
        // ==========================================

        // TEST 1: CHOICE = 0 - ADD
        // SWITCH[15] = 0, SWITCH[3:0] = 0000
        // x4 = x1 + x2 = 0x10101010 + 0x01010101
        // EXPECTED: x4 = 0x11111111, LED = 16'h1111
        physical_sw = 16'b0000000000000000;
        #20;

        // TEST 2: CHOICE = 0 - SUB
        // SWITCH[15] = 0, SWITCH[3:0] = 0001
        // x5 = x1 - x2 = 0x10101010 - 0x01010101
        // EXPECTED: x5 = 0x0F0F0F0F, LED = 16'h0F0F
        physical_sw = 16'b0000000000000001;
        #20;

        // TEST 3: CHOICE = 0 - AND
        // SWITCH[15] = 0, SWITCH[3:0] = 0010
        // x6 = x1 & x2
        // EXPECTED: x6 = 0x00000000, LED = 16'h8000
        physical_sw = 16'b0000000000000010;
        #20;

        // TEST 4: CHOICE = 0 - OR
        // SWITCH[15] = 0, SWITCH[3:0] = 0011
        // x7 = x1 | x2
        // EXPECTED: x7 = 0x11111111, LED = 16'h1111
        physical_sw = 16'b0000000000000011;
        #20;

        // TEST 5: CHOICE = 0 - XOR
        // SWITCH[15] = 0, SWITCH[3:0] = 0100
        // x8 = x1 ^ x2
        // EXPECTED: x8 = 0x11111111, LED = 16'h1111
        physical_sw = 16'b0000000000000100;
        #20;

        // TEST 6: CHOICE = 0 - SLL
        // SWITCH[15] = 0, SWITCH[3:0] = 0101
        // rs2 overrides to x3 (5) for choice 0 shifts
        // x9 = x1 << 5
       // EXPECTED: x9 = 0x02020200, LED = 16'h0200
        physical_sw = 16'b0000000000000101;
        #20;

        // TEST 7: CHOICE = 0 - SRL
        // SWITCH[15] = 0, SWITCH[3:0] = 0110
        // rs2 overrides to x3 (5) for choice 0 shifts
        // x10 = x1 >> 5
        // EXPECTED: x10 = 0x00808080, LED = 16'h0080
        physical_sw = 16'b0000000000000110;
        #20;

        // TEST 8: CHOICE = 0 - BEQ
        // SWITCH[15] = 0, SWITCH[3:0] = 0111
        // x1 != x2
        // EXPECTED: Zero = 0, rd = 0, NO WRITE, LED = 16'h0F0F
        physical_sw = 16'b0000000000000111;
        #20;

        // TEST 9: CHOICE = 0 - INVALID ALU CONTROL
        // SWITCH[15] = 0, SWITCH[3:0] = 1000
        // EXPECTED: Defaults to ADD (0000), rd = 0, NO WRITE, LED = 16'h1111
        physical_sw = 16'b0000000000001000;
        #20;


        // ==========================================
        // MANUAL MODE TESTS (CHOICE = 1)
        // rs2 is ALWAYS fixed to x2 (0x01010101)
        // ==========================================

        // TEST 10: CHOICE = 1 - MANUAL ADD 
        // SWITCH[15:14] = 11
        // SWITCH[13:9] = 00100 (rs1 = x4 = 0x11111111)
        // SWITCH[8:4]  = 01011 (rd = x11)
        // SWITCH[3:0]  = 0000 (ADD)
        // EXPECTED: x11 = x4 + x2 = 0x12121212, LED = 16'h1212
        physical_sw = 16'b1100100010110000;
        #20;

        // TEST 11: CHOICE = 1 - MANUAL SUB 
        // SWITCH[13:9] = 00110 (rs1 = x6 = 0x00000000)
        // SWITCH[8:4]  = 01100 (rd = x12)
        // SWITCH[3:0]  = 0001 (SUB)
        // EXPECTED: x12 = x6 - x2 = 0xFEFEFEFF, LED = 16'h7EFF
        physical_sw = 16'b1100110011000001;
        #20;

        // TEST 12: CHOICE = 1 - MANUAL AND 
        // SWITCH[13:9] = 00111 (rs1 = x7 = 0x11111111)
        // SWITCH[8:4]  = 01101 (rd = x13)
        // SWITCH[3:0]  = 0010 (AND)
        // EXPECTED: x13 = x7 & x2 = 0x01010101, LED = 16'h0101
        physical_sw = 16'b1100111011010010;
        #20;

        // TEST 13: CHOICE = 1 - MANUAL OR 
        // SWITCH[13:9] = 00100 (rs1 = x4 = 0x11111111)
        // SWITCH[8:4]  = 01110 (rd = x14)
        // SWITCH[3:0]  = 0011 (OR)
        // EXPECTED: x14 = x4 | x2 = 0x11111111, LED = 16'h1111
        physical_sw = 16'b1100100011100011;
        #20;

        // TEST 14: CHOICE = 1 - MANUAL XOR 
        // SWITCH[13:9] = 00101 (rs1 = x5 = 0x0F0F0F0F)
        // SWITCH[8:4]  = 01111 (rd = x15)
        // SWITCH[3:0]  = 0100 (XOR)
        // EXPECTED: x15 = x5 ^ x2 = 0x0E0E0E0E, LED = 16'h0E0E
        physical_sw = 16'b1100101011110100;
        #20;

        // TEST 15: CHOICE = 1 - MANUAL SLL 
        // SWITCH[13:9] = 00011 (rs1 = x3 = 5)
        // SWITCH[8:4]  = 10000 (rd = x16)
        // SWITCH[3:0]  = 0101 (SLL)
        // NOTE: In manual mode, rs2 is fixed to x2. 
        // Shift amount = x2[4:0] = 0x01010101[4:0] = 1.
        // EXPECTED: x16 = 5 << 1 = 0x0000000A, LED = 16'h000A
        physical_sw = 16'b1100011100000101;
        #20;

        // TEST 16: CHOICE = 1 - MANUAL SRL 
        // SWITCH[13:9] = 00111 (rs1 = x7 = 0x11111111)
        // SWITCH[8:4]  = 10001 (rd = x17)
        // SWITCH[3:0]  = 0110 (SRL)
        // NOTE: Shift amount = x2[4:0] = 1.
        // EXPECTED: x17 = 0x11111111 >> 1 = 0x08888888, LED = 16'h0888
        physical_sw = 16'b1100111100010110;
        #20;

        // TEST 17: CHOICE = 1 - MANUAL BEQ (NOT EQUAL)
        // SWITCH[13:9] = 00100 (rs1 = x4 = 0x11111111)
        // SWITCH[8:4]  = 10010 (rd = x18)
        // SWITCH[3:0]  = 0111 (BEQ)
        // EXPECTED: x4 != x2 -> Zero = 0, rd = 0, NO WRITE, LED = 16'h1010
        physical_sw = 16'b1100100100100111;
        #20;
        
        // TEST 18: CHOICE = 1 - MANUAL BEQ (EQUAL)
        // SWITCH[13:9] = 00010 (rs1 = x2 = 0x01010101)
        // EXPECTED: x2 == x2 -> Zero = 1, rd = 0, NO WRITE, LED = 16'h8000
        physical_sw = 16'b1100010100100111;
        #20;

        // TEST 19: CHOICE = 1, MANUAL_WRITE = 0 
        // SWITCH[15:14] = 10
        // EXPECTED: Falls to Auto ADD. FSM condition `(choice == 1 && manual_write == 1)` fails.
        // FSM remains trapped in IDLE. NO REGISTER WRITE occurs. LED = 16'h1111
        physical_sw = 16'b1000000000000000;
        #40;


        // ==========================================
        // RESET AND RECOVERY
        // ==========================================

        // TEST 20: RESET
        // EXPECTED: FSM goes to INIT_X1, register file is reset. LED = 16'h8000
        pbin = 1'b1;
        #40;
        pbin = 1'b0;
        
        // WAIT FOR FSM TO RE-INITIALIZE x1, x2, x3
        #40;

        // TEST 21: POST-RESET RECOVERY 
        // EXPECTED: Choice 0 ADD resumes -> x4 = 0x11111111, LED = 16'h1111
        physical_sw = 16'b0000000000000000;
        #40;

        // END SIMULATION
        $finish;
    end

endmodule