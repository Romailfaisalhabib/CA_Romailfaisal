`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 08:59:08 AM
// Design Name: 
// Module Name: ProgramCounter
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

module ProgramCounter(
    input wire clk,
    input wire rst,
    input wire [31:0] nextPC,
    output reg [31:0] PC
);

always @(posedge clk or posedge rst) begin
    if (rst)
        PC <= 32'd0;
    else
        PC <= nextPC;
end

endmodule