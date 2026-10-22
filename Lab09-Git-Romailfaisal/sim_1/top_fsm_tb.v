`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 11:10:13 PM
// Design Name: 
// Module Name: top_fsm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_fsm_tb;

    reg clk;
    reg pbin;

    // 16-BIT PHYSICAL SWITCHES
    reg [15:0] physical_sw;

    // 16-BIT PHYSICAL LEDS
    wire [15:0] physical_leds;

    // INSTANTIATION
    top_fsm_system uut (
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

        // RESET THE SYSTEM
        pbin = 1'b1;
        #40;
        pbin = 1'b0;
        
        // WAIT FOR FSM TO INITIALIZE
        #100;
        // Mapping: {19'b0, ALUControl[3:0], Branch, MemtoReg, MemWrite, MemRead, ALUSrc, ALUOp[1:0], RegWrite}

        // R-TYPE INSTRUCTIONS 
        // TEST 1: ADD
        // sw[6:0] = 0110011, sw[9:7] = 000, sw[10] = 0 -> physical_sw = 16'h0033
        // EXPECTED: ALUControl=0000, RegWrite=1, ALUOp=10, others=0
        // leds[11:0] = 0000_0_0_0_0_0_10_1 -> physical_leds = 16'h0005
        physical_sw = 16'b00000_0_000_0110011;
        #200;
        // TEST 2: SUB
        // sw[6:0] = 0110011, sw[9:7] = 000, sw[10] = 1 -> physical_sw = 16'h0433
        // EXPECTED: ALUControl=0001, RegWrite=1, ALUOp=10, others=0
        // leds[11:0] = 0001_0_0_0_0_0_10_1 -> physical_leds = 16'h0105
        physical_sw = 16'b00000_1_000_0110011;
        #200;
        // TEST 3: SLL
        // sw[6:0] = 0110011, sw[9:7] = 001, sw[10] = 0 -> physical_sw = 16'h00B3
        // EXPECTED: ALUControl=0101, RegWrite=1, ALUOp=10, others=0
        // leds[11:0] = 0101_0_0_0_0_0_10_1 -> physical_leds = 16'h0505
        physical_sw = 16'b00000_0_001_0110011;
        #200;
        // TEST 4: SRL
        // sw[6:0] = 0110011, sw[9:7] = 101, sw[10] = 0 -> physical_sw = 16'h02B3
        // EXPECTED: ALUControl=0110, RegWrite=1, ALUOp=10, others=0
        // leds[11:0] = 0110_0_0_0_0_0_10_1 -> physical_leds = 16'h0605
        physical_sw = 16'b00000_0_101_0110011;
        #200;
        // TEST 5: AND
        // sw[6:0] = 0110011, sw[9:7] = 111, sw[10] = 0 -> physical_sw = 16'h03B3
        // EXPECTED: ALUControl=0010, RegWrite=1, ALUOp=10, others=0
        // leds[11:0] = 0010_0_0_0_0_0_10_1 -> physical_leds = 16'h0205
        physical_sw = 16'b00000_0_111_0110011;
        #200;
        // TEST 6: OR
        // sw[6:0] = 0110011, sw[9:7] = 110, sw[10] = 0 -> physical_sw = 16'h0333
        // EXPECTED: ALUControl=0011, RegWrite=1, ALUOp=10, others=0
        // leds[11:0] = 0011_0_0_0_0_0_10_1 -> physical_leds = 16'h0305
        physical_sw = 16'b00000_0_110_0110011;
        #200;
        // TEST 7: XOR
        // sw[6:0] = 0110011, sw[9:7] = 100, sw[10] = 0 -> physical_sw = 16'h0233
        // EXPECTED: ALUControl=0100, RegWrite=1, ALUOp=10, others=0
        // leds[11:0] = 0100_0_0_0_0_0_10_1 -> physical_leds = 16'h0405
        physical_sw = 16'b00000_0_100_0110011;
        #200;

        // I-TYPE INSTRUCTIONS 
        // TEST 8: ADDI
        // sw[6:0] = 0010011, sw[9:7] = 000, sw[10] = 0 -> physical_sw = 16'h0013
        // EXPECTED: ALUControl=0000, RegWrite=1, ALUSrc=1, ALUOp=11, others=0
        // leds[11:0] = 0000_0_0_0_0_1_11_1 -> physical_leds = 16'h000F
        physical_sw = 16'b00000_0_000_0010011;
        #200;

        // LOAD INSTRUCTIONS 
        // TEST 9: LW
        // sw[6:0] = 0000011, sw[9:7] = 010, sw[10] = 0 -> physical_sw = 16'h0103
        // EXPECTED: ALUControl=0000, RegWrite=1, MemtoReg=1, MemRead=1, ALUSrc=1, ALUOp=00
        // leds[11:0] = 0000_0_1_0_1_1_00_1 -> physical_leds = 16'h0059
        physical_sw = 16'b00000_0_010_0000011;
        #200;
        // TEST 10: LH
        // sw[6:0] = 0000011, sw[9:7] = 001, sw[10] = 0 -> physical_sw = 16'h0083
        // EXPECTED: Same control signals as LW
        // leds[11:0] = 0000_0_1_0_1_1_00_1 -> physical_leds = 16'h0059
        physical_sw = 16'b00000_0_001_0000011;
        #200;
        // TEST 11: LB
        // sw[6:0] = 0000011, sw[9:7] = 000, sw[10] = 0 -> physical_sw = 16'h0003
        // EXPECTED: Same control signals as LW
        // leds[11:0] = 0000_0_1_0_1_1_00_1 -> physical_leds = 16'h0059
        physical_sw = 16'b00000_0_000_0000011;
        #200;

        // STORE INSTRUCTIONS 
        // TEST 12: SW
        // sw[6:0] = 0100011, sw[9:7] = 010, sw[10] = 0 -> physical_sw = 16'h0123
        // EXPECTED: ALUControl=0000, MemWrite=1, ALUSrc=1, ALUOp=00, others=0
        // leds[11:0] = 0000_0_0_1_0_1_00_0 -> physical_leds = 16'h0028
        physical_sw = 16'b00000_0_010_0100011;
        #200;
        // TEST 13: SH
        // sw[6:0] = 0100011, sw[9:7] = 001, sw[10] = 0 -> physical_sw = 16'h00A3
        // EXPECTED: Same control signals as SW
        // leds[11:0] = 0000_0_0_1_0_1_00_0 -> physical_leds = 16'h0028
        physical_sw = 16'b00000_0_001_0100011;
        #200;
        // TEST 14: SB
        // sw[6:0] = 0100011, sw[9:7] = 000, sw[10] = 0 -> physical_sw = 16'h0023
        // EXPECTED: Same control signals as SW
        // leds[11:0] = 0000_0_0_1_0_1_00_0 -> physical_leds = 16'h0028
        physical_sw = 16'b00000_0_000_0100011;
        #200;

        // BRANCH INSTRUCTIONS
        // TEST 15: BEQ
        // sw[6:0] = 1100011, sw[9:7] = 000, sw[10] = 0 -> physical_sw = 16'h0063
        // EXPECTED: ALUControl=0111, Branch=1, ALUOp=01, others=0
        // leds[11:0] = 0111_1_0_0_0_0_01_0 -> physical_leds = 16'h0782
        physical_sw = 16'b00000_0_000_1100011;
        #200;

        // END SIMULATION
        $finish;
    end

endmodule