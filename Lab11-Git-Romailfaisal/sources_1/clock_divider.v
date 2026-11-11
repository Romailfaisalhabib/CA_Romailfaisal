`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aaisha Siddiqui, Romail Faisal

// Module Name: clock_divider
// Project Name: Counter
// Target Devices: Baasys 3
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_divider (
    input wire clk_in,    // The super fast 100MHz board clock
    input wire rst,       // The reset button
    output reg clk_out    // Our new slow 1Hz clock
);

    // A register big enough to hold the number 50,000,000
    reg [25:0] count = 0; 
    
    // We toggle the output every 50 Million ticks. 
    // 50M High + 50M Low = 100M total ticks = 1 full second.
    
    // TEMPORARILY CHANGED FOR SIMULATION ONLY!
    // Change this back to 50_000_000 - 1 before programming the board!
  
    //localparam MAX_COUNT = 2;	// comment out for simulation
    localparam MAX_COUNT = 50_000_000 - 1;	//comment out for hw impl

    // Asynchronous active-high reset
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count   <= 0;
            clk_out <= 0;
        end
        else if (count == MAX_COUNT) begin
            count   <= 0;
            clk_out <= ~clk_out;
        end
        else begin
            count <= count + 1'b1;
        end
    end

endmodule