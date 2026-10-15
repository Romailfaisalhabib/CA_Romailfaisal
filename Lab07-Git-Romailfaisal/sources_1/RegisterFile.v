`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2026 03:05:36 PM
// Design Name: 
// Module Name: RegisterFile
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

module RegisterFile(
    input wire clk,
    input wire rst,
    input wire WriteEnable,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] WriteData,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);
    // 32 registers, each 32 bits wide
    reg [31:0] regs [31:0];
    integer i;
   // Asynchronous reset and synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (WriteEnable && (rd != 5'd0)) begin
            regs[rd] <= WriteData;
        end
    end

    // Asynchronous read ports
    // Register x0 is always zero
    assign ReadData1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1];

    assign ReadData2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];

endmodule
