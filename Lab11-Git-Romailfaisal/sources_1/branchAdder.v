`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 09:01:04 AM
// Design Name: 
// Module Name: branchAdder
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

module branchAdder(
    input wire [31:0] PC,
    input wire [31:0] imm,
    output wire [31:0] branchTarget
);
 
    assign branchTarget = PC + (imm << 1);
 
endmodule


