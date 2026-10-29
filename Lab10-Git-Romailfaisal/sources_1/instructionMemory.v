`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 08:45:39 AM
// Design Name: 
// Module Name: instructionMemory
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

module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input  [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);
    reg [7:0] memory [0:255];      // 256 bytes = 64 instructions
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 8'h00;
        $readmemh("fsm_program.mem", memory);
    end

    wire [7:0] a = {instAddress[7:2], 2'b00};   // word-aligned byte address

    always @(*)                    // little-endian fetch
        instruction = {memory[a+3], memory[a+2], memory[a+1], memory[a]};
endmodule
