`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 08:55:45 AM
// Design Name: 
// Module Name: AddressDecoder
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

module AddressDecoder (
    input wire [9:0] address,
    input wire MemRead,
    input wire MemWrite,
    output reg DataMemRead,
    output reg DataMemWrite,
    output reg LEDWrite,
    output reg SwitchReadEnable
);

    always @(*) begin
        DataMemRead      = 1'b0;
        DataMemWrite     = 1'b0;
        LEDWrite         = 1'b0;
        SwitchReadEnable = 1'b0;

        case (address[9:8])
            2'b00, 2'b01: begin
                DataMemRead  = MemRead;
                DataMemWrite = MemWrite;
            end

            2'b10: begin
                LEDWrite = MemWrite;
            end

            2'b11: begin
                SwitchReadEnable = MemRead;
            end
        endcase
    end

endmodule
