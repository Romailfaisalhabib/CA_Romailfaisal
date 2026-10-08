`timescale 1ns / 1ps

module top_sim();
    reg clk;
    reg rst;
    reg [15:0] switch_value;
    wire [15:0] led_value;
    top_fsm_system counter (.clk(clk), .pbin(rst), .physical_sw(switch_value), .physical_leds(led_value));
    initial begin
    clk = 1'b0;
    end
    always #5 clk = ~clk;
    initial begin
    rst = 1'b1;
    switch_value = 16'd0;
    
    #20;
    
    rst =1'b0;
    
    #20;
    
    switch_value = 16'd5;
    
    #250;
    
    switch_value = 16'd10;
    
    #80;
    
    switch_value = 16'd0;
    
    #20;
    
    switch_value = 16'd3;
    
    #60;
    
    rst = 1'b1;
    
    #10;
    
    rst = 1'b0;
    switch_value = 16'd0;
    
    #20;
    $finish;
    end
endmodule