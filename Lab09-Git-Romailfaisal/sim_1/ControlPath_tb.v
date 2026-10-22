`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 10:37:10 PM
// Design Name: 
// Module Name: ControlPath_tb
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

module ControlPath_tb;

    // INPUTS
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    // OUTPUTS
    wire RegWrite;
    wire [1:0] ALUOp;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;
    wire [3:0] ALUControl;

    // INSTANTIATION
    ControlPath uut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    initial begin
        // INITIALIZE INPUTS
        opcode = 7'b0000000;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        
        #40; // WAIT FOR INITIALIZATION

        $display("TESTING R-TYPE INSTRUCTIONS");

        // TEST 1: ADD
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 1 && ALUSrc === 0 && MemWrite === 0 && Branch === 0 && ALUOp === 2'b10)
            $display("ADD  PASS");
        else
            $display("ADD  FAIL");

        // TEST 2: SUB
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0100000; #20;
        if (ALUControl === 4'b0001 && RegWrite === 1 && ALUSrc === 0 && MemWrite === 0 && ALUOp === 2'b10)
            $display("SUB  PASS");
        else
            $display("SUB  FAIL");

        // TEST 3: SLL
        opcode = 7'b0110011; funct3 = 3'b001; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0101 && RegWrite === 1 && ALUSrc === 0 && MemWrite === 0)
            $display("SLL  PASS");
        else
            $display("SLL  FAIL");

        // TEST 4: SRL
        opcode = 7'b0110011; funct3 = 3'b101; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0110 && RegWrite === 1 && ALUSrc === 0 && MemWrite === 0)
            $display("SRL  PASS");
        else
            $display("SRL  FAIL");

        // TEST 5: AND
        opcode = 7'b0110011; funct3 = 3'b111; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0010 && RegWrite === 1 && ALUSrc === 0 && MemWrite === 0)
            $display("AND  PASS");
        else
            $display("AND  FAIL");

        // TEST 6: OR
        opcode = 7'b0110011; funct3 = 3'b110; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0011 && RegWrite === 1 && ALUSrc === 0 && MemWrite === 0)
            $display("OR   PASS");
        else
            $display("OR   FAIL");

        // TEST 7: XOR
        opcode = 7'b0110011; funct3 = 3'b100; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0100 && RegWrite === 1 && ALUSrc === 0 && MemWrite === 0)
            $display("XOR  PASS");
        else
            $display("XOR  FAIL");

        $display("TESTING I-TYPE INSTRUCTIONS");

        // TEST 8: ADDI 
        // Using funct7 = 0100000 to prove ALUOp=2'b11 correctly prevents SUB decoding
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0100000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 1 && ALUSrc === 1 && MemWrite === 0 && Branch === 0 && ALUOp === 2'b11)
            $display("ADDI PASS");
        else
            $display("ADDI FAIL: ALUControl=%b, ALUOp=%b", ALUControl, ALUOp);

        $display("TESTING LOAD INSTRUCTIONS");

        // TEST 9: LW
        opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 1 && ALUSrc === 1 && MemRead === 1 && MemtoReg === 1 && ALUOp === 2'b00)
            $display("LW   PASS");
        else
            $display("LW   FAIL");

        // TEST 10: LH
        opcode = 7'b0000011; funct3 = 3'b001; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 1 && ALUSrc === 1 && MemRead === 1 && MemtoReg === 1)
            $display("LH   PASS");
        else
            $display("LH   FAIL");

        // TEST 11: LB
        opcode = 7'b0000011; funct3 = 3'b000; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 1 && ALUSrc === 1 && MemRead === 1 && MemtoReg === 1)
            $display("LB   PASS");
        else
            $display("LB   FAIL");

        $display("TESTING STORE INSTRUCTIONS");

        // TEST 12: SW
        opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 0 && ALUSrc === 1 && MemWrite === 1 && ALUOp === 2'b00)
            $display("SW   PASS");
        else
            $display("SW   FAIL");

        // TEST 13: SH
        opcode = 7'b0100011; funct3 = 3'b001; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 0 && ALUSrc === 1 && MemWrite === 1)
            $display("SH   PASS");
        else
            $display("SH   FAIL");

        // TEST 14: SB
        opcode = 7'b0100011; funct3 = 3'b000; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0000 && RegWrite === 0 && ALUSrc === 1 && MemWrite === 1)
            $display("SB   PASS");
        else
            $display("SB   FAIL");

        $display("TESTING BRANCH INSTRUCTIONS");

        // TEST 15: BEQ
        opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000; #20;
        if (ALUControl === 4'b0111 && RegWrite === 0 && ALUSrc === 0 && Branch === 1 && ALUOp === 2'b01)
            $display("BEQ  PASS");
        else
            $display("BEQ  FAIL");

        // END SIMULATION
        #40 
        $display("SIMULATION COMPLETE");
        $finish;
    end

endmodule