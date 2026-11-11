`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 11:10:29 AM
// Design Name: 
// Module Name: Topprocessor_sim
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

module tb_TopLevelProcessor;

    reg clk;
    reg rst;

    // 16-BIT PHYSICAL SWITCHES
    reg [15:0] physical_sw;

    // 16-BIT PHYSICAL LEDS
    wire [15:0] physical_leds;

    // INSTANTIATION
    TopLevelProcessor uut (
        .clk(clk),
        .rst(rst),
        .switches(physical_sw),
        .leds(physical_leds)
    );

    // 10 NS PERIOD CLOCK -> 100 MHZ
    always #5 clk = ~clk;

    initial begin
        // ==========================================
        // INITIALIZATION
        // ==========================================
        clk = 1'b0;
        rst = 1'b1; // ASSERT RESET

        // ALL SWITCHES OFF
        physical_sw = 16'b0000000000000000;

        // WAIT FOR PROCESSOR TO RESET
        #40;
        rst = 1'b0; // RELEASE RESET
        
        // ==========================================
        // AUTO MODE TESTS (PROCESSOR EXECUTION)
        // ==========================================

        // TEST 1: IDLE STATE 
        // SWITCHES = 0
        // EXPECTED: Processor loops, waiting for a non-zero input. 
        // LED = 16'h0000
        #60; 

        // TEST 2: NON-ZERO INPUT CAPTURE (START COUNTDOWN)
        // SWITCH[3:0] = 0101 (Decimal 5)
        // EXPECTED: Processor reads 5, breaks idle loop, outputs 5 to LEDs.
        // It should then start counting down: 4, 3, 2, 1, 0.
        physical_sw = 16'h0005;
        #20; 
        // Turn switches off immediately to ensure the processor captured the value 
        // and doesn't just read the switches constantly during the countdown.
        physical_sw = 16'h0000; 

        // Wait for the assembly countdown loop to finish. 
        // (Time depends on how many instructions are in your assembly loop)
        #300;


        // ==========================================
        // RESET AND RECOVERY TESTS
        // ==========================================

        // TEST 3: MID-COUNTDOWN RESET
        // SWITCH[3:0] = 1000 (Decimal 8)
        // EXPECTED: Processor starts counting down from 8, but we hit reset.
        // Processor should immediately return to idle state. LED = 16'h0000.
        physical_sw = 16'h0008; 
        #50; // Let it run a few cycles of the countdown loop
        
        rst = 1'b1; // PRESS RESET
        #20;
        rst = 1'b0; // RELEASE RESET
        physical_sw = 16'h0000; // Turn off switches
        
        #40; // Allow processor to settle back into IDLE polling loop

        // TEST 4: POST-RESET RECOVERY 
        // SWITCH[3:0] = 0011 (Decimal 3)
        // EXPECTED: Processor successfully recovers from reset, reads 3, 
        // and counts down: 3, 2, 1, 0.
        physical_sw = 16'h0003;
        #20;
        physical_sw = 16'h0000;

        #200; // Wait for countdown to finish

        // END SIMULATION
        $finish;
    end

endmodule