`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 08:34:43 AM
// Design Name: 
// Module Name: ALU_1bit
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
module ALU_1bit(
    input A,
    input B,
    input Cin,
    input [2:0] Operation, // Increased to 3 bits. Operation[2] handles B inversion.

    output Result,
    output Cout
);

    wire B_used;
    wire AddResult;
    
    // Invert B if Operation[2] is 1 (Used for SUB/BEQ)
    assign B_used = B ^ Operation[2];

    // Full adder
    assign AddResult = A ^ B_used ^ Cin;

    assign Cout = (A & B_used) | (A & Cin) | (B_used & Cin);

    // Select operation using the lower 2 bits of Operation
    assign Result = (Operation[1:0] == 2'b00) ? (A & B_used) :
                    (Operation[1:0] == 2'b01) ? (A | B_used) :
                    (Operation[1:0] == 2'b10) ? AddResult :
                    (A ^ B_used); // 2'b11 is XOR

endmodule