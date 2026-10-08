`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aaisha Siddiqui , Romail Faisal

// Module Name: top_fsm_system
// Project Name: Counter
// Target Devices: Basys 3
// 
//////////////////////////////////////////////////////////////////////////////////

module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire [31:0] switch_data; // hold the value read from the switches
    reg [31:0] led_write_data = 32'd0; // counter value here
    wire slow_clk;
 
    debouncer rst_db (
                .clk(clk),
                .pbin(pbin), 
                .pbout(rst_clean)   //generated a clean signal
    ); 

    
    
    leds switch_reader (
                    .clk(clk), .rst(rst_clean),
                    .btns(16'd0),           // Not used for this FSM
                    .writeData(32'd0),          // We don't write to switches
                    .writeEnable(1'b0),         // Disabled
                    .readEnable(1'b1),          // Always ON so we can monitor switches
                    .memAddress(30'd0),       
                    .switches(physical_sw),     // Plug in the physical switches
                    .readData(switch_data)      // output data 
    );
    
    switches led_writer (
                    .clk(clk), .rst(rst_clean),
                    .writeData(led_write_data),
                    .writeEnable(1'b1),         // Always ON so LEDs update instantly
                    .readEnable(1'b0), .memAddress(30'd0),
                    .readData(),                // Ignored
                    .leds(physical_leds)      
    );
    
    clock_divider ticker (
                    .clk_in(clk),               // Feed it the 100MHz fast clock
                    .rst(rst_clean),            // Feed it the clean reset signal
                    .clk_out(slow_clk)          // It spits out the 1Hz slow clock!
    );

    // YOUR FSM AND COUNTER LOGIC
    // FSM states
    localparam WAIT      = 1'b0;
    localparam COUNTDOWN = 1'b1;

    reg state;
    reg [15:0] counter;

    always @(posedge slow_clk or posedge rst_clean) begin

        if (rst_clean) begin
            state   <= WAIT;
            counter <= 16'd0;
        end

        // WAIT STATE
        else if (state == WAIT) begin

            if (switch_data != 32'd0) begin

                // Capture switch value (taking bottom 16 bits of the 32-bit data)
                counter <= switch_data[15:0];

                // Go to countdown
                state <= COUNTDOWN;

            end

            else begin

                counter <= 16'd0;
                state   <= WAIT;

            end
        end

        // COUNTDOWN STATE
        else if (state == COUNTDOWN) begin

            // When counter reaches 1,
            // next clock makes it zero
            // and returns to WAIT
            if (counter == 16'd1) begin

                counter <= 16'd0;
                state   <= WAIT;

            end

            else if (counter != 16'd0) begin

                counter <= counter - 16'd1;
                state   <= COUNTDOWN;

            end

            else begin

                counter <= 16'd0;
                state   <= WAIT;

            end
        end

        // Safety condition
        else begin

            state   <= WAIT;
            counter <= 16'd0;

        end
    end

    // LED output
    always @(*) begin

        if (state == COUNTDOWN)
            led_write_data = {16'd0, counter}; // Padded to match 32-bit reg size

        else
            led_write_data = 32'd0;

    end

endmodule