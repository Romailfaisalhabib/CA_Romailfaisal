`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 09:10:36 AM
// Design Name: 
// Module Name: ALU_32bit_sim
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

module ALU_32bit_sim;
    reg [31:0] A;
    reg [31:0] B;
    reg [4:0] ShiftAmount;
    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;
    // Instantiate 32-bit ALU
    ALU_32bit uut(A,B,ShiftAmount,ALUControl,ALUResult,Zero);
    initial begin
        A = 32'b00000000000000000000000000000111;
        B = 32'b00000000000000000000000000000011;
        ShiftAmount = 5'b00100;
        // ADD
        ALUControl = 4'b0000;
        #10;
        // Expected:
        // 7+3=10 
        // Zero = 0
        // SUB
        ALUControl = 4'b0001;
        #10;
        // Expected:
        // 7-3=4
        // Zero = 0
        // AND
        ALUControl = 4'b0010;
        #10;
        // Expected:
        // 00000000000000000000000000000011=3
        // Zero = 0
        // OR
        ALUControl = 4'b0011;
        #10;
        // Expected:
        // 00000000000000000000000000000111=7
        // Zero = 0
        // XOR
        ALUControl = 4'b0100;
        #10;
        // Expected:
        // 00000000000000000000000000000100=4
        // Zero = 0
        
        // SLL
        ALUControl = 4'b0101;
        #10;
        //
        // Expected:
        // 00000000000000000000000001110000=112=7*16
        // Zero = 0
        // SRL
        ALUControl = 4'b0110;
        #10;
        // 
        // Expected:
        // 00000000000000000000000000000000=0=7/16
        // Zero = 1
        // BEQ diff values
        ALUControl = 4'b0111;
        #10;
        // Expected:
         // 7-3=4
        // Zero = 0
        // BEQ same values
        A = 32'b00000000000000000000000000000100;
        B = 32'b00000000000000000000000000000100;
        ALUControl = 4'b0111;
        #10;
        // Expected:
        // 4-4=0
        // Zero = 1
        $finish;
    end
endmodule