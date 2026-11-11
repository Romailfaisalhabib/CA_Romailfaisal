`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 08:41:44 AM
// Design Name: 
// Module Name: PC_Datapath
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

module PC_Datapath(
    input wire clk,
    input wire rst,
    input wire PCSrc,
    input wire [31:0] instruction,
    output wire [31:0] PC,
    output wire [31:0] immediate 
);

    wire [31:0] nextPC;
    wire [31:0] PCPlus4;
    wire [31:0] branchTarget;

    // Stores and updates the PC value
    ProgramCounter pc_inst (
        .clk(clk),
        .rst(rst),
        .nextPC(nextPC),
        .PC(PC)
    );

    // Computes PC + 4
    pcAdder pc_add_inst (
        .PC(PC),
        .PCPlus4(PCPlus4)
    );

    // Generates I, S, and B type immediates
    immGen imm_gen_inst (
        .instruction(instruction),
        .immediate(immediate)
    );

    // Computes PC + (imm << 1)
    branchAdder branch_add_inst (
        .PC(PC),
        .imm(immediate),
        .branchTarget(branchTarget)
    );

    // Selects between sequential and branch target addresses using PCSrc
    mux2 pc_mux (
        .in0(PCPlus4),
        .in1(branchTarget),
        .select(PCSrc),
        .out(nextPC)
    );

endmodule