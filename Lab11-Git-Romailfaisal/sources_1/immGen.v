`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 09:02:37 AM
// Design Name: 
// Module Name: immGen
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

module immGen(
    input wire [31:0] instruction,
    output reg [31:0] immediate
);
 
    always @(*) begin
        case (instruction[6:0])
 
            // I-type: addi, lw, jalr
            7'b0010011, 7'b0000011, 7'b1100111:
                immediate = {{20{instruction[31]}}, instruction[31:20]};
 
            // S-type: sw
            7'b0100011:
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
 
            // B-type: beq
            7'b1100011:
                immediate = {{20{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
 
            // J-type: jal
            7'b1101111:
                immediate = {{12{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
 
            // U-type: lui, auipc
            7'b0110111, 7'b0010111:
                immediate = {instruction[31:12], 12'b0};
 
            default:
                immediate = 32'b0;
 
        endcase
    end
 
endmodule

