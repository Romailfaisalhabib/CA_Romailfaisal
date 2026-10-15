`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 08:56:48 AM
// Design Name: 
// Module Name: addressDecoderTop
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

module addressDecoderTop (
    input wire clk,
    input wire rst,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] writeData,
    input wire [15:0] switches,
    output wire [31:0] readData,
    output wire [15:0] leds
);

    wire DataMemRead;
    wire DataMemWrite;
    wire LEDWrite;
    wire SwitchReadEnable;

    wire [31:0] memoryReadData;
    wire [31:0] switchReadData;
    wire [15:0] ledOutput;

    // Decode the base address 
    AddressDecoder decoder (
        .address(address[9:0]),
        .MemRead(readEnable),
        .MemWrite(writeEnable),
        .DataMemRead(DataMemRead),
        .DataMemWrite(DataMemWrite),
        .LEDWrite(LEDWrite),
        .SwitchReadEnable(SwitchReadEnable)
    );

    // Primary data storage RAM
    DataMemory data_memory (
        .clk(clk),
        .rst(rst),              // Asynchronous reset clears memory contents
        .MemWrite(DataMemWrite),
        .address(address[8:0]),
        .write_data(writeData),
        .read_data(memoryReadData)
    );
    
    // Memory-mapped interface for reading physical switch states
    leds switch_interface (
        .clk(clk),
        .rst(rst),
        .btns(16'd0),
        .writeData(writeData),
        .writeEnable(1'b0),
        .readEnable(SwitchReadEnable),
        .memAddress(address[29:0]),
        .switches(switches),
        .readData(switchReadData)
    );

    // Memory-mapped register used to drive the physical LED outputs
    switches led_interface (
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(LEDWrite),
        .readEnable(1'b0),
        .memAddress(address[29:0]),
        .readData(),
        .leds(ledOutput)
    );

    // Route the internal LED output register to the top-level port
    assign leds = ledOutput;

    // Multiplex the outgoing read bus based on the active decoded read signal
    assign readData = DataMemRead  ? memoryReadData : SwitchReadEnable ? switchReadData : 32'd0;

endmodule
