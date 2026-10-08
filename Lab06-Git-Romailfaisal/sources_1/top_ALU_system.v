`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: top_ALU_system
// Target Devices: Basys 3
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module top_ALU_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // Debouncer and Bus Signals
    wire rst_clean;
    wire [31:0] switch_data;           
    reg  [31:0] led_write_data = 32'd0; 
    wire slow_clk;

    debouncer rst_db (
        .clk(clk),
        .pbin(pbin), 
        .pbout(rst_clean)
    );   

    leds switch_reader (
        .clk(clk), 
        .rst(rst_clean),
        .btns(16'd0),            
        .writeData(32'd0),       
        .writeEnable(1'b0),      
        .readEnable(1'b1),       
        .memAddress(30'd0),       
        .switches(physical_sw),  
        .readData(switch_data)   
    );

    switches led_writer (
        .clk(clk), 
        .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),      
        .readEnable(1'b0), 
        .memAddress(30'd0),
        .readData(),             
        .leds(physical_leds)     
    );

    clock_divider ticker (
        .clk_in(clk),            
        .rst(rst_clean),         
        .clk_out(slow_clk)       
    );

    // FSM STATES
    localparam WAIT    = 1'b0;
    localparam CAPTURE = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (rst_clean) begin
            state          <= WAIT;
            led_write_data <= 32'd0;
        end
        else begin
            case (state)
                WAIT: begin
                    // Check if enable switch [15] is active
                    if (switch_data[15] == 1'b1) begin
                        state <= CAPTURE;
                    end
                    else begin
                        led_write_data <= 32'd0;
                    end
                end
                
                CAPTURE: begin
                    // If switch[15] is turned off, reset output and return to wait
                    if (switch_data[15] == 1'b0) begin
                        state          <= WAIT;
                        led_write_data <= 32'd0;
                    end
                    else begin
                        // Continuously display results while enabled, math is combinational
                        led_write_data <= {16'd0, zero_flag, alu_result[14:0]};
                    end
                end
                
                default: state <= WAIT;
            endcase
        end
    end

    // ALU_32bit INSTANTIATION (32-Bit Binary Operands)
    wire [31:0] alu_result;
    wire zero_flag;

    // A = 0x10101010 
    // B = 0x01010101 
    ALU_32bit u_alu (
        .A(32'h10101010), 
        .B(32'h01010101), 
        .ShiftAmount(switch_data[8:4]), 
        .ALUControl(switch_data[3:0]),  
        .ALUResult(alu_result),
        .Zero(zero_flag)
    );

endmodule