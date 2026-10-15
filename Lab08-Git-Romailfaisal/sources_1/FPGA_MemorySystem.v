`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 09:32:26 AM
// Design Name: 
// Module Name: FPGA_MemorySystem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FPGA_MemorySystem (
    input wire clk,
    input wire pbin, // Physical center button used for debounced system reset
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);
    wire rst;
    // Debounce the physical button to ensure a clean reset signal
    debouncer db (.clk(clk), .pbin(pbin), .pbout(rst)); 
    // physical_sw[15] dictates the operation mode: High = Write, Low = Read
    wire MemWrite = physical_sw[15];
    wire MemRead  = ~physical_sw[15]; 
    // Address construction: 
    // physical_sw[9:8] select the memory region, physical_sw[7:0] provide the address offset.
    // Together they form a 10-bit address bus, zero-extended to 32 bits.
    wire [31:0] address = {22'd0, physical_sw[9:0]};    
    // Data input construction:
    // physical_sw[14:10] supply 5-bit data (values ranging from 0 to 31).
    wire [31:0] writeData = {27'd0, physical_sw[14:10]}; 
    wire [31:0] readData;
    wire [15:0] mem_mapped_leds;
    // Instantiate the main address decoder module
    addressDecoderTop uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(MemRead),
        .writeEnable(MemWrite),
        .writeData(writeData),
        // Route the lowest 5 physical switches to the internal memory-mapped switch register
        .switches({11'd0, physical_sw[4:0]}),  
        .readData(readData),
        .leds(mem_mapped_leds)
    );
    // Output Routing Logic:
    // 2'b10 corresponds to the LED module.
    // If selector (physical_sw[9:8]) is set to 2'b10, output the memory-mapped LED data.
    // For all other, display the lower 16 bits of the active read bus.
    assign physical_leds = (physical_sw[9:8] == 2'b10) ? mem_mapped_leds : readData[15:0];
endmodule
