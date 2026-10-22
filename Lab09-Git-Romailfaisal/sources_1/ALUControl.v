`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 10:13:11 PM
// Design Name: 
// Module Name: ALUControl
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

module ALUControl(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] ALUControl
);

always @(*) begin
    // Safe default: ADD
    ALUControl = 4'b0000;

    case (ALUOp)

// Load/store: calculate address using addition
        2'b00: begin
            ALUControl = 4'b0000;
        end

// BEQ: subtraction for comparison
        2'b01: begin
            ALUControl = 4'b0111;
        end

// R-type and I-type arithmetic
        2'b10: begin
            case (funct3)

// ADD / SUB / ADDI
                3'b000: begin
                    if (funct7 == 7'b0100000)
                        ALUControl = 4'b0001; // SUB
                    else
                        ALUControl = 4'b0000; // ADD
                end

// SLL
                3'b001: begin
                    ALUControl = 4'b0101;
                end

// Not required by this lab
                3'b010: begin
                    ALUControl = 4'b0000;
                end

// Not required by this lab
                3'b011: begin
                    ALUControl = 4'b0000;
                end

// XOR
                3'b100: begin
                    ALUControl = 4'b0100;
                end

// SRL; SRA is not required
                3'b101: begin
                    if (funct7 == 7'b0000000)
                        ALUControl = 4'b0110;
                    else
                        ALUControl = 4'b0000;
                end

// OR
                3'b110: begin
                    ALUControl = 4'b0011;
                end

// AND
                3'b111: begin
                    ALUControl = 4'b0010;
                end

                default: begin
                    ALUControl = 4'b0000;
                end

            endcase  // End inner case (funct3)
        end

        // ADDI
        2'b11: begin
            ALUControl = 4'b0000;
        end

        default: begin
            ALUControl = 4'b0000;
        end

    endcase  // End outer case (ALUOp)
end

endmodule