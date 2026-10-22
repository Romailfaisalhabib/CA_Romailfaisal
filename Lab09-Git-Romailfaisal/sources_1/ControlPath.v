`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 10:18:06 PM
// Design Name: 
// Module Name: ControlPath
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

module ControlPath(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output RegWrite,
    output [1:0] ALUOp,
    output MemRead,
    output MemWrite,
    output ALUSrc,
    output MemtoReg,
    output Branch,
    output [3:0] ALUControl
);

MainControl main_control (
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch)
);

ALUControl alu_control (
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .ALUControl(ALUControl)
);

endmodule

