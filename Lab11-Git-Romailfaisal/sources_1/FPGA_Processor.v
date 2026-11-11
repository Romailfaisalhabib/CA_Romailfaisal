`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 09:58:16 AM
// Design Name: 
// Module Name: FPGA_Processor
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

module FPGA_Processor(
    input  wire  clk, // 100 MHz clock from Basys 3
    input  wire  btnC,       // Center button for reset
    input  wire [15:0] sw,         // 16 Switches
    output wire [15:0] led         // 16 LEDs
);

    wire slow_clk;
    wire rst_debounced;

    // 1. Clock Divider
    clock_divider clk_div (
        .clk_in(clk),
        .rst(btnC),
        .clk_out(slow_clk)
    );

    // 2. Debouncer for Reset
    debouncer db (
        .clk(clk),
        .pbin(btnC),
        .pbout(rst_debounced)
    );

    // 3. Top Level Processor
    TopLevelProcessor cpu (
        .clk(slow_clk),
        .rst(rst_debounced),
        .switches(sw),
        .leds(led) 
    );

endmodule