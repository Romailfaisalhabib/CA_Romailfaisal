`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 08:58:20 AM
// Design Name: 
// Module Name: MemorySytem_tb
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

module MemorySystem_tb;
    reg clk;
    reg rst;
    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;
    reg [15:0] switches;
    wire [31:0] readData;
    wire [15:0] leds;

    // Instantiate the Memory System
    addressDecoderTop DUT (
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(switches),
        .readData(readData),
        .leds(leds)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // INITIAL VALUES
        clk         = 1'b0;
        rst         = 1'b1;
        address     = 32'd0;
        readEnable  = 1'b0;
        writeEnable = 1'b0;
        writeData   = 32'd0;
        switches    = 16'd0;

        #20;
        rst = 1'b0;
        #10;

        // TEST CASE 1: DATA MEMORY WRITE
        // Address = 100
        // Data Memory range = 0 to 511
        // Written value = 0x12345678
        address     = 32'd100;
        writeData   = 32'h12345678;
        writeEnable = 1'b1;
        #10;
        writeEnable = 1'b0;
        #10;

        // TEST CASE 2: DATA MEMORY READ
        // Expected readData = 0x12345678
        address    = 32'd100;
        readEnable = 1'b1;
        #10;
        readEnable = 1'b0;
        #10;

        // TEST CASE 3: LED WRITE
        // Address = 600
        // LED address range = 512 to 767
        // Written value = 0x0000ABCD
        // Expected leds = 0xABCD
        address     = 32'd600;
        writeData   = 32'h0000ABCD;
        writeEnable = 1'b1;
        #10;
        writeEnable = 1'b0;
        #10;

        // TEST CASE 4: SWITCH READ
        // Address = 800
        // Switch address range = 768 to 1023
        // Switch value = 0x55AA
        // Expected readData = 0x000055AA
        switches   = 16'h55AA;
        address    = 32'd800;
        readEnable = 1'b1;
        #10;
        readEnable = 1'b0;
        #10;

        // TEST CASE 5: LED READ
        // LEDs are WRITE-ONLY
        // Expected readData = 0
        address    = 32'd600;
        readEnable = 1'b1;
        #10;
        readEnable = 1'b0;
        #10;

        // TEST CASE 6: SWITCH WRITE PROTECTION
        // Switches are READ-ONLY
        // Attempt to write 0xFFFFFFFF
        // Expected switch value remains 0x55AA
        address     = 32'd800;
        writeData   = 32'hFFFFFFFF;
        writeEnable = 1'b1;
        #10;
        writeEnable = 1'b0;
        #10;

        // Read switches again
        // Expected readData = 0x000055AA
        readEnable = 1'b1;
        #10;
        readEnable = 1'b0;

        // SIMULATION COMPLETE
        #20;
        $finish;
    end
endmodule