`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 10:13:11 PM
// Design Name: 
// Module Name: MainControl
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

module MainControl(
    input  [6:0] opcode,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg Branch
);

always @(*) begin
    // Safe default values
    RegWrite = 1'b0;
    ALUOp    = 2'b00;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    ALUSrc   = 1'b0;
    MemtoReg = 1'b0;
    Branch   = 1'b0;

    case (opcode)

        // R-type: ADD, SUB, SLL, SRL, AND, OR, XOR
        7'b0110011: begin
            RegWrite = 1'b1;
            ALUOp    = 2'b10;
        end

        // I-type arithmetic: ADDI
        7'b0010011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ALUOp    = 2'b11;
        end

        // Loads: LW, LH, LB
        7'b0000011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            MemRead  = 1'b1;
            MemtoReg = 1'b1;
            ALUOp    = 2'b00;
        end

        // Stores: SW, SH, SB
        7'b0100011: begin
            ALUSrc   = 1'b1;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
        end

        // Branch: BEQ
        7'b1100011: begin
            Branch = 1'b1;
            ALUOp  = 2'b01;
        end

        // Unsupported opcode: keep safe defaults
        default: begin
        end

    endcase
end

endmodule

