`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 08:51:03 AM
// Design Name: 
// Module Name: DataMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DataMemory (
    input wire clk,
    input wire MemWrite,
    input wire [8:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] memory [0:511];

    assign read_data = memory[address];

    always @(posedge clk) begin
        if (MemWrite)
            memory[address] <= write_data;
    end

endmodule
