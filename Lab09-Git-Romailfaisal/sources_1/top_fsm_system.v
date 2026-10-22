`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 10:59:22 PM
// Design Name: 
// Module Name: top_fsm_system
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

module top_fsm_system(
    input clk,
    input pbin,
    input [15:0] physical_sw,
    output [15:0] physical_leds
);

    wire rst;
    wire slow_clk;

    wire [31:0] switch_data;
    wire [31:0] led_read_data;
    wire [31:0] led_write_data;

    reg [6:0] opcode_reg;
    reg [2:0] funct3_reg;
    reg [6:0] funct7_reg;

    wire RegWrite;
    wire [1:0] ALUOp;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;
    wire [3:0] ALUControl;

    reg state;
    reg [31:0] led_data_reg;

    // Reset button debouncer
    debouncer reset_debouncer (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst)
    );

    // Slow clock for the verification FSM
    clock_divider clk_div (
        .clk_in(clk),
        .rst(rst),
        .clk_out(slow_clk)
    );

    // Read physical switches through the Lab 5 interface
    leds switch_reader (
        .clk(clk),
        .rst(rst),
        .btns(4'b0000),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(32'b0),
        .switches(physical_sw),
        .readData(switch_data)
    );

    // Write control outputs through the Lab 5 LED interface
    switches led_writer (
        .clk(clk),
        .rst(rst),
        .writeData(led_data_reg),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(32'b0),
        .readData(led_read_data),
        .leds(physical_leds)
    );

    // Main control and ALU control path
    ControlPath control_path (
        .opcode(opcode_reg),
        .funct3(funct3_reg),
        .funct7(funct7_reg),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    // Two-state FSM
    always @(posedge slow_clk or posedge rst) begin
        if (rst) begin
            state        <= 1'b0;
            opcode_reg   <= 7'b0;
            funct3_reg   <= 3'b0;
            funct7_reg   <= 7'b0;
            led_data_reg <= 32'b0;
        end
        else begin
            case (state)

                // State 0: capture the switch inputs
                1'b0: begin
                    opcode_reg <= switch_data[6:0];
                    funct3_reg <= switch_data[9:7];
                    funct7_reg <= {
                        1'b0,
                        switch_data[10],
                        5'b00000
                    };

                    state <= 1'b1;
                end

                // State 1: display the control signals
                1'b1: begin
                    led_data_reg <= {
                        19'b0,
                        ALUControl,
                        Branch,
                        MemtoReg,
                        MemWrite,
                        MemRead,
                        ALUSrc,
                        ALUOp,
                        RegWrite
                    };

                    state <= 1'b0;
                end

            endcase
        end
    end

endmodule

