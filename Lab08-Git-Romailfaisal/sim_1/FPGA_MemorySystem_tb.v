`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 09:38:45 AM
// Design Name: 
// Module Name: FPGA_MemorySystem_tb
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

module FPGA_MemorySystem_tb;

    // TESTBENCH SIGNALS
    reg clk;
    reg pbin;
    reg [15:0] physical_sw;
    wire [15:0] physical_leds;

    // DUT INSTANTIATION
    FPGA_MemorySystem uut (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(physical_leds)
    );

    // 10 ns CLOCK PERIOD (100 MHz)
    always #5 clk = ~clk;

    // TEST SEQUENCE
    initial begin
        // INITIAL CONDITIONS
        clk = 1'b0;
        pbin = 1'b1;          // Start with pbin high to trigger initial reset
        physical_sw = 16'b0000000000000000;
        #20;
        pbin = 1'b0;          // Release reset
        #20;
        // Example A: Writing a value to Data Memory
        // Goal: Write binary data 01100 (12) into Data Memory address 00001111 (15).
        // Binary Switch Inputs:
        //   sw[15]    = 1        (Write mode)
        //   sw[14:10] = 01100    (Data to write: 12)
        //   sw[9:8]   = 00       (Selector: Data Memory)
        //   sw[7:0]   = 00001111 (Address: 15)
        // Combined Binary Input: 16'b1_01100_00_00001111
        // Expected LED Output:   16'b0000000000000000 (Read bus not driving active output)    
        physical_sw = 16'b1011000000001111;
        #20;
   
        // Example B: Reading from Data Memory
        // Goal: Read whatever is stored at Data Memory address 00001111 (15).
        // Binary Switch Inputs:
        //   sw[15]    = 0        (Read mode)
        //   sw[14:10] = 00000    (Ignored during reads)
        //   sw[9:8]   = 00       (Selector: Data Memory)
        //   sw[7:0]   = 00001111 (Address: 15)
        // Combined Binary Input: 16'b0_00000_00_00001111
        // Expected LED Output:   16'b0000000000001100 (Displays the exact 01100 we just wrote) 
        physical_sw = 16'b0000000000001111; 
        #20;

        // Example C: Writing a value to the LEDs (Memory-Mapped)
        // Goal: Write binary data 10101 (21) directly to the LEDs.
        // Binary Switch Inputs:
        //   sw[15]    = 1        (Write mode)
        //   sw[14:10] = 10101    (Data to write: 21)
        //   sw[9:8]   = 10       (Selector: LEDs)
        //   sw[7:0]   = 00000111 (Address: 7) 
        // Combined Binary Input: 16'b1_10101_10_00000111
        // Expected LED Output:   16'b0000000000010101 (Displays the exact 10101 we are writing) 
        physical_sw = 16'b1101011000000111; 
        #20;
        
        // Example D: Reading from the Switches (Memory-Mapped)
        // Goal: Read the state of the lower 5 switches via the memory-map.
        // Binary Switch Inputs:
        //   sw[15]    = 0        (Read mode)
        //   sw[14:10] = 00000    (Ignored during reads)
        //   sw[9:8]   = 11       (Selector: Switches)
        //   sw[7:0]   = 00000011 (Address: 3) 
        // Combined Binary Input: 16'b0_00000_11_00000011
        // Expected LED Output:   16'b0000000000000011 (Displays 00011, which are the lower 5 bits of the input above)
        physical_sw = 16'b0000001100000011; 
        #20;

        // END SIMULATION
        $finish;
    end
endmodule