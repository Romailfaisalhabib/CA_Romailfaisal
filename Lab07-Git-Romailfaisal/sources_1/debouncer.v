`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aaisha Siddiqui, Romail Faisal

// Module Name: debouncer
// Project Name: Counter
// Target Devices: Baasys 3
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer(
    input clk,
    input pbin,
    output pbout
    );
  
    assign pbout = pbin;
endmodule