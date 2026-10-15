`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2026 03:12:52 PM
// Design Name: 
// Module Name: RegisterFile_sim
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2026 03:12:52 PM
// Design Name: 
// Module Name: RegisterFile_tb
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

module RegisterFile_tb;
    reg clk, rst, WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;
    // Instantiate Register File
    RegisterFile uut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    // Clock generation
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        WriteEnable = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        WriteData = 0;
        // Reset register file
        #20;
        rst = 0;
        // Test 1: Write x5 = DEADBEEF
        WriteEnable = 1;
        rd = 5;
        WriteData = 32'hDEADBEEF;
        #10;
        // Read x5
        WriteEnable = 0;
        rs1 = 5;
        #10;
        // Expected: ReadData1 = DEADBEEF
        // Test 2: Attempt to write x0
        WriteEnable = 1;
        rd = 0;
        WriteData = 32'hFFFFFFFF;
        #10;
        // Read x0
        WriteEnable = 0;
        rs1 = 0;
        #10;
        // Expected: ReadData1 = 00000000
        // Test 3: Write x6 for Simultaneous two-port read
        WriteEnable = 1;
        rd = 6;
        WriteData = 32'h12345678;
        #10;
        // Read x5 and x6 simultaneously
        WriteEnable = 0;
        rs1 = 5;
        rs2 = 6;
        #10;
        // Expected: ReadData1 = DEADBEEF
        // Expected: ReadData2 = 12345678
        // Test 4: Overwrite x5 = CAFEBABE
        WriteEnable = 1;
        rd = 5;
        WriteData = 32'hCAFEBABE;
        #10;
        // Read overwritten x5
        WriteEnable = 0;
        rs1 = 5;
        #10;
        // Expected: ReadData1 = CAFEBABE
        // Test 5: Reset behavior
        rst = 1;
        #10;
        rst = 0;
        rs1 = 5;
        rs2 = 6;
        #10;
        // Expected: ReadData1 = 00000000
        // Expected: ReadData2 = 00000000

        // End simulation
        $finish;
    end

endmodule
