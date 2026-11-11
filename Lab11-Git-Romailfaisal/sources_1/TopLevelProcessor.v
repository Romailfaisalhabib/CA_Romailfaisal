`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 09:52:11 AM
// Design Name: 
// Module Name: TopLevelProcessor
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

//   uses: ProgramCounter, pcAdder, branchAdder, mux2, immGen   (Lab 11)
//           instructionMemory                                    (Lab 10)
//           ControlPath (MainControl + ALUControl)               (Lab 9)
//           RegisterFile, ALU_32bit (+ ALU_1bit)                 (Lab 7)
//           addressDecoderTop (DataMemory + LED + switch IO)     (Lab 8)
//
//   Memory map seen by lw/sw (address[9:8] of the ALU result):
//        0 - 511  : data memory      512 - 767 : LEDs (write)      768 - 1023 : switches (read)


module TopLevelProcessor(
    input  wire        clk,        // processor clock
    input  wire        rst,        // active-high reset
    input  wire [15:0] switches,   // memory-mapped input
    output wire [15:0] leds        // memory-mapped output
);

    // ---------------- Program counter path ----------------
    wire [31:0] PC, nextPC, PCPlus4, branchTarget;
    wire        PCSrc;

    ProgramCounter pc_reg (.clk(clk), .rst(rst), .nextPC(nextPC), .PC(PC));
    pcAdder        pc_add (.PC(PC), .PCPlus4(PCPlus4));

    // ---------------- Instruction fetch ----------------
    wire [31:0] instruction;
    instructionMemory imem (.instAddress(PC), .instruction(instruction));

    // ---------------- Instruction fields ----------------
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd     = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [4:0] rs1    = instruction[19:15];
    wire [4:0] rs2    = instruction[24:20];
    wire [6:0] funct7 = instruction[31:25];

    // ---------------- Control ----------------
    wire       RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    ControlPath ctrl (
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .RegWrite(RegWrite), .ALUOp(ALUOp), .MemRead(MemRead), .MemWrite(MemWrite),
        .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .ALUControl(ALUControl)
    );

    // ---------------- Register file / immediate ----------------
    wire [31:0] ReadData1, ReadData2, immediate, writeBack;

    RegisterFile rf (
        .clk(clk), .rst(rst), .WriteEnable(RegWrite),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(writeBack),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    immGen imm_gen (.instruction(instruction), .immediate(immediate));

    // ---------------- ALU ----------------
    wire [31:0] aluB, ALUResult;
    wire        Zero;

    mux2 alusrc_mux (.in0(ReadData2), .in1(immediate), .select(ALUSrc), .out(aluB));

    ALU_32bit alu (
        .A(ReadData1), .B(aluB), .ALUControl(ALUControl),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    // ---------------- Data memory + memory-mapped IO ----------------
    wire [31:0] memReadData;

    addressDecoderTop mem (
        .clk(clk), .rst(rst),
        .address(ALUResult),
        .readEnable(MemRead), .writeEnable(MemWrite),
        .writeData(ReadData2),
        .switches(switches),
        .readData(memReadData),
        .leds(leds)
    );

    // ---------------- Write back ----------------
    mux2 wb_mux (.in0(ALUResult), .in1(memReadData), .select(MemtoReg), .out(writeBack));

    // ---------------- Next PC ----------------
    branchAdder br_add (.PC(PC), .imm(immediate), .branchTarget(branchTarget));
    assign PCSrc = Branch & Zero;
    mux2 pc_mux (.in0(PCPlus4), .in1(branchTarget), .select(PCSrc), .out(nextPC));

endmodule