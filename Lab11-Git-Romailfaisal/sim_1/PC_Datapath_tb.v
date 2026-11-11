`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 08:49:08 AM
// Design Name: 
// Module Name: PC_Datapath_tb
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

module PC_Datapath_tb;

    reg clk;
    reg rst;
    reg PCSrc;
    reg [31:0] instruction;

    wire [31:0] PC;
    wire [31:0] immediate;

    // Instantiate the Top-Level Datapath
    PC_Datapath uut (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrc),
        .instruction(instruction),
        .PC(PC),
        .immediate(immediate)
    );

    // Clock generation (10ns period / 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        PCSrc = 0;
        instruction = 32'd0;

        // Wait for global reset to finish
        #20;
        rst = 0;

        // Test 1: PC increments correctly by 4 when PCSrc = 0
        #10;
        // PC should be 4 here. 
        // Feed an I-type instruction to check standard immediate generation: ADDI x1, x0, 10
        instruction = 32'h00A00093; // 10 is generated as the immediate
        
        #10;
        // PC should be 8 here.

        // Test 2: PC updates to branch target when PCSrc = 1
        // Feed a B-type instruction to check branch addition: BEQ x0, x0, +8
        // For +8 offset, the imm field fed to branchAdder needs to be 4 (since it shifts left by 1)
        PCSrc = 1;
        instruction = 32'h00000463; // immGen outputs 4. branchTarget = PC(8) + (4 << 1) = 16.
        
        #10;
        // PC should update to 16 based on the PCSrc = 1 selection.

        // Test 3: Resume sequential execution
        PCSrc = 0;
        instruction = 32'h00000000;
        
        #10;
        // PC should increment sequentially from 16 to 20.
        
        #20;
        $finish;
    end

endmodule
