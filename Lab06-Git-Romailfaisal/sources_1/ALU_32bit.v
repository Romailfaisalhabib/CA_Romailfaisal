`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 08:36:40 AM
// Design Name: 
// Module Name: ALU_32bit
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

module ALU_32bit(
    input [31:0] A,
    input [31:0] B,
    input [4:0] ShiftAmount,
    input [3:0] ALUControl,

    output reg [31:0] ALUResult,
    output Zero
);

    // Carry wires
    wire c1, c2, c3, c4, c5, c6, c7, c8;
    wire c9, c10, c11, c12, c13, c14, c15, c16;
    wire c17, c18, c19, c20, c21, c22, c23, c24;
    wire c25, c26, c27, c28, c29, c30, c31, c32;

    // Results from each 1-bit ALU
    wire r0, r1, r2, r3, r4, r5, r6, r7;
    wire r8, r9, r10, r11, r12, r13, r14, r15;
    wire r16, r17, r18, r19, r20, r21, r22, r23;
    wire r24, r25, r26, r27, r28, r29, r30, r31;

    // Control signal for 1-bit ALUs (Expanded to 3 bits)
    reg [2:0] Operation; 

    // First carry
    wire c0;
    assign c0 = (ALUControl == 4'b0001) || (ALUControl == 4'b0111);

    // 1-bit ALU instantiations
    ALU_1bit alu0(A[0], B[0], c0, Operation, r0, c1);
    ALU_1bit alu1(A[1], B[1], c1, Operation, r1, c2);
    ALU_1bit alu2(A[2], B[2], c2, Operation, r2, c3);
    ALU_1bit alu3(A[3], B[3], c3, Operation, r3, c4 );
    ALU_1bit alu4(A[4], B[4], c4, Operation, r4, c5);
    ALU_1bit alu5(A[5], B[5], c5, Operation, r5, c6);
    ALU_1bit alu6(A[6], B[6], c6, Operation, r6, c7);
    ALU_1bit alu7(A[7], B[7], c7, Operation, r7, c8 );
    ALU_1bit alu8(A[8], B[8], c8, Operation, r8, c9);
    ALU_1bit alu9(A[9], B[9], c9, Operation, r9, c10);
    ALU_1bit alu10(A[10], B[10], c10, Operation, r10, c11);
    ALU_1bit alu11(A[11], B[11], c11, Operation, r11, c12);
    ALU_1bit alu12(A[12], B[12], c12, Operation, r12, c13);
    ALU_1bit alu13(A[13], B[13], c13, Operation, r13, c14);
    ALU_1bit alu14(A[14], B[14], c14, Operation, r14, c15);
    ALU_1bit alu15(A[15], B[15], c15, Operation, r15, c16);
    ALU_1bit alu16(A[16], B[16], c16, Operation, r16, c17);
    ALU_1bit alu17(A[17], B[17], c17, Operation, r17, c18 );
    ALU_1bit alu18(A[18], B[18], c18, Operation, r18, c19 );
    ALU_1bit alu19(A[19], B[19], c19, Operation, r19, c20);
    ALU_1bit alu20(A[20], B[20], c20, Operation, r20, c21);
    ALU_1bit alu21(A[21], B[21], c21, Operation, r21, c22);
    ALU_1bit alu22(A[22], B[22], c22, Operation, r22, c23);
    ALU_1bit alu23(A[23], B[23], c23, Operation, r23, c24 );
    ALU_1bit alu24(A[24], B[24], c24, Operation, r24, c25);
    ALU_1bit alu25(A[25], B[25], c25, Operation, r25, c26);
    ALU_1bit alu26(A[26], B[26], c26, Operation, r26, c27);
    ALU_1bit alu27(A[27], B[27], c27, Operation, r27, c28);
    ALU_1bit alu28(A[28], B[28], c28, Operation, r28, c29);
    ALU_1bit alu29(A[29], B[29], c29, Operation, r29, c30 );
    ALU_1bit alu30(A[30], B[30], c30, Operation, r30, c31);
    ALU_1bit alu31(A[31], B[31], c31, Operation, r31, c32);

    // Map ALUControl to the 3-bit Operation signal
    always @(*) begin
        case(ALUControl)
            4'b0000: Operation = 3'b010; // ADD (No inversion, Op 2'b10)
            4'b0001: Operation = 3'b110; // SUB (Invert B, Op 2'b10)
            4'b0010: Operation = 3'b000; // AND (No inversion, Op 2'b00)
            4'b0011: Operation = 3'b001; // OR  (No inversion, Op 2'b01)
            4'b0100: Operation = 3'b011; // XOR (No inversion, Op 2'b11)
            4'b0101: Operation = 3'b010; // SLL 
            4'b0110: Operation = 3'b010; // SRL 
            4'b0111: Operation = 3'b110; // BEQ (Needs subtraction)
            default: Operation = 3'b010; // Default ADD
        endcase
    end

    // Put the 32 one-bit results together
    wire [31:0] ArithmeticResult;

    assign ArithmeticResult = {r31, r30, r29, r28, r27, r26, r25, r24, r23, r22, r21, r20, r19, r18, r17, r16, r15, r14, r13, r12,
        r11, r10, r9, r8, r7, r6, r5, r4, r3, r2, r1, r0};

    // Final ALU result
    always @(*) begin
        case(ALUControl)
            4'b0000: ALUResult = ArithmeticResult; // ADD
            4'b0001: ALUResult = ArithmeticResult; // SUB
            4'b0010: ALUResult = ArithmeticResult; // AND
            4'b0011: ALUResult = ArithmeticResult; // OR
            4'b0100: ALUResult = ArithmeticResult; // XOR
            4'b0101: ALUResult = A << ShiftAmount; // Shift Left
            4'b0110: ALUResult = A >> ShiftAmount; // Shift Right
            4'b0111: ALUResult = ArithmeticResult; // BEQ
            default: ALUResult = 0;
        endcase
    end

    // Zero = 1 when result is zero
    assign Zero = (ALUResult == 0);

endmodule