module top_rf_alu (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire [31:0] switch_data;
    reg [31:0] led_write_data;

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

    wire choice;
    wire manual_write;
    wire [4:0] switch_rs1;
    wire [4:0] switch_rd;
    wire [3:0] switch_alu_control;

    assign choice = switch_data[15];
    assign manual_write = switch_data[14];
    assign switch_rs1 = switch_data[13:9];
    assign switch_rd = switch_data[8:4];
    assign switch_alu_control = switch_data[3:0];

    reg rf_write_enable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    RegisterFile rf (
        .clk(clk),
        .rst(rst_clean),
        .WriteEnable(rf_write_enable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(write_data),
        .ReadData1(read_data1),
        .ReadData2(read_data2)
    );

    reg [3:0] alu_control;
    wire [31:0] alu_result;
    wire zero;


    ALU_32bit alu (
        .A(read_data1),
        .B(read_data2),
        .ALUControl(alu_control),
        .ALUResult(alu_result),
        .Zero(zero)
    );

    localparam INIT_X1  = 3'd0;
    localparam INIT_X2  = 3'd1;
    localparam INIT_X3  = 3'd2;
    localparam IDLE     = 3'd3;
    localparam EXECUTE = 3'd4;

    reg [2:0] state;

   always @(posedge clk or posedge rst_clean) begin
        if (rst_clean)
            state <= INIT_X1;
        else begin
            case (state)
                INIT_X1: state <= INIT_X2;
                INIT_X2: state <= INIT_X3;
                INIT_X3: state <= IDLE;
                IDLE: begin
                    if ((choice == 1'b0) ||
                        ((choice == 1'b1) && (manual_write == 1'b1)))
                        state <= EXECUTE;
                end
                EXECUTE: state <= IDLE;
                default: state <= INIT_X1;
            endcase
        end
    end

    always @(*) begin
        rf_write_enable = 1'b0;
        rs1 = 5'd0;
        rs2 = 5'd0;
        rd = 5'd0;
        write_data = 32'd0;
        alu_control = 4'b0000;

        case (state)

            INIT_X1: begin
                rf_write_enable = 1'b1;
                rd = 5'd1;
                write_data = 32'h10101010;
            end

            INIT_X2: begin
                rf_write_enable = 1'b1;
                rd = 5'd2;
                write_data = 32'h01010101;
            end

            INIT_X3: begin
                rf_write_enable = 1'b1;
                rd = 5'd3;
                write_data = 32'h00000005;
            end

            IDLE, EXECUTE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                if (choice && manual_write) begin

                    rs1 = switch_rs1;
                    rs2 = 5'd2;
                    rd = switch_rd;
                    alu_control = switch_alu_control;

                    if (state == EXECUTE) begin
                        rf_write_enable = 1'b1;
                        write_data = alu_result;
                    end

                    if (switch_alu_control == 4'b0111) begin
                        rd = 5'd0;
                        rf_write_enable = 1'b0;
                        write_data = 32'd0;
                    end

                end
                else begin

                    case (switch_alu_control)

                        4'b0000: begin
                            alu_control = 4'b0000;
                            rd = 5'd4;
                        end

                        4'b0001: begin
                            alu_control = 4'b0001;
                            rd = 5'd5;
                        end

                        4'b0010: begin
                            alu_control = 4'b0010;
                            rd = 5'd6;
                        end

                        4'b0011: begin
                            alu_control = 4'b0011;
                            rd = 5'd7;
                        end

                        4'b0100: begin
                            alu_control = 4'b0100;
                            rd = 5'd8;
                        end

                        4'b0101: begin
                            rs2 = 5'd3;
                            alu_control = 4'b0101;
                            rd = 5'd9;
                        end

                        4'b0110: begin
                            rs2 = 5'd3;
                            alu_control = 4'b0110;
                            rd = 5'd10;
                        end

                        4'b0111: begin
                            alu_control = 4'b0111;
                            rd = 5'd0;
                        end

                        default: begin
                            alu_control = 4'b0000;
                            rd = 5'd0;
                        end

                    endcase

                    if ((state == EXECUTE) &&
                        (switch_alu_control != 4'b0111)) begin
                        rf_write_enable = 1'b1;
                        write_data = alu_result;
                    end

                end

            end

            default: begin
                rf_write_enable = 1'b0;
                write_data = 32'd0;
            end

        endcase
    end

    always @(*) begin
        led_write_data = {
            16'd0,
            zero,
            alu_result[14: 0]
        };
    end

endmodule