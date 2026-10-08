`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 08:55:53 AM
// Design Name: 
// Module Name: ALU_1bit_sim
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

module ALU_1bit_sim;
    // Inputs
    reg A;
    reg B;
    reg Cin;
    reg [2:0] Operation; // Now 3 bits!
    // Outputs
    wire Result;
    wire Cout;
    // Combine Cout and Result into a 2-bit number for easy reading in the simulator
    wire [1:0] MathOutput;
    assign MathOutput = {Cout, Result};
    // Instantiate the 1-bit ALU
    ALU_1bit uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Operation(Operation), 
        .Result(Result), 
        .Cout(Cout)
    );
    initial begin
        // Test 1: AND (Op = 3'b000) -> 1 & 0 = 0
        A = 1'b1; B = 1'b0; Cin = 1'b0; Operation = 3'b000;
        #10;
        // Test 2: OR (Op = 3'b001) -> 1 | 0 = 1
        A = 1'b1; B = 1'b0; Cin = 1'b0; Operation = 3'b001;
        #10;
        // Test 3: ADD (Op = 3'b010) -> 1 + 1 + 0 = 2 (Result 0, Cout 1)
        A = 1'b1; B = 1'b1; Cin = 1'b0; Operation = 3'b010;
        #10;
        // Test 4: SUB (Op = 3'b110) -> 1 - 1 = 0
        // Operation[2] is 1, so B gets inverted to 0 internally. 
        // 1 + ~1(which is 0) + Cin(1) = 2 (Result 0, Cout 1)
        A = 1'b1; B = 1'b1; Cin = 1'b1; Operation = 3'b110;
        #10;
        // Test 5: XOR (Op = 3'b011) -> 1 ^ 0 = 1
        A = 1'b1; B = 1'b0; Cin = 1'b0; Operation = 3'b011;
        #10;
        $finish;
    end
endmodule