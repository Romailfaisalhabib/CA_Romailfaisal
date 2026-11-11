`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 09:00:14 AM
// Design Name: 
// Module Name: pcAdder
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

module pcAdder(
    input wire [31:0] PC,
    output wire [31:0] PCPlus4
);
    assign PCPlus4 = PC + 32'd4;
endmodule