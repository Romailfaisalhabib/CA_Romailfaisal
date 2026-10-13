`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: RF_ALU_FSM_tb
// Description:
// Directly tests the Register File and ALU using an FSM.
//
// Register values:
// x1 = 0x10101010
// x2 = 0x01010101
// x3 = 0x00000005
//
// The FSM performs:
// ADD, SUB, AND, OR, XOR, SLL, SRL and BEQ.
//
// The Register File and ALU are directly instantiated in this testbench.
//////////////////////////////////////////////////////////////////////////////////
module RF_ALU_FSM_tb;
    reg clk, rst, WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;
    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;
    // FSM States
    reg [4:0] state;
    localparam IDLE       = 5'd0,
               WRITE_X1   = 5'd1,
               WRITE_X2   = 5'd2,
               WRITE_X3   = 5'd3,
               ADD_STATE  = 5'd4,
               SUB_STATE  = 5'd5,
               AND_STATE  = 5'd6,
               OR_STATE   = 5'd7,
               XOR_STATE  = 5'd8,
               SLL_STATE  = 5'd9,
               SRL_STATE  = 5'd10,
               BEQ_STATE  = 5'd11,
               RAW_WRITE  = 5'd12,
               RAW_READ   = 5'd13,
               DONE       = 5'd14;

    // Instantiate Register File
    RegisterFile RF (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Instantiate ALU
    ALU_32bit ALU (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // Clock generation
    always #5 clk = ~clk;

    // FSM State Register (Asynchronous Reset applied)
    always @(posedge clk or posedge rst) begin
        if (rst) 
            state <= IDLE;
        else begin
            case (state)
                IDLE:      state <= WRITE_X1;
                WRITE_X1:  state <= WRITE_X2;
                WRITE_X2:  state <= WRITE_X3;
                WRITE_X3:  state <= ADD_STATE;
                ADD_STATE: state <= SUB_STATE;
                SUB_STATE: state <= AND_STATE;
                AND_STATE: state <= OR_STATE;
                OR_STATE:  state <= XOR_STATE;
                XOR_STATE: state <= SLL_STATE;
                SLL_STATE: state <= SRL_STATE;
                SRL_STATE: state <= BEQ_STATE;
                BEQ_STATE: state <= RAW_WRITE;
                RAW_WRITE: state <= RAW_READ;
                RAW_READ:  state <= DONE;
                DONE:      state <= DONE;
                default:   state <= IDLE;
            endcase
        end
    end

    // FSM Output Logic
    always @(*) begin
        // Default assignments
        WriteEnable = 0;
        rd = 0;
        WriteData = 0;
        rs1 = 0;
        rs2 = 0;
        ALUControl = 0;
        case (state)
            WRITE_X1: begin
                WriteEnable = 1;
                rd = 1;
                WriteData = 32'h10101010;
            end
            WRITE_X2: begin
                WriteEnable = 1;
                rd = 2;
                WriteData = 32'h01010101;
            end
            WRITE_X3: begin
                WriteEnable = 1;
                rd = 3;
                WriteData = 32'h00000005;
            end

            ADD_STATE: begin
                rs1 = 1;
                rs2 = 2;
                ALUControl = 4'b0000;
                WriteEnable = 1;
                rd = 4;
                WriteData = ALUResult;
                // Expected: ALUResult = 32'h11111111
            end
            SUB_STATE: begin
                rs1 = 1;
                rs2 = 2;
                ALUControl = 4'b0001;
                WriteEnable = 1;
                rd = 5;
                WriteData = ALUResult;
                // Expected: ALUResult = 32'h0F0F0F0F
            end
            AND_STATE: begin
                rs1 = 1;
                rs2 = 2;
                ALUControl = 4'b0010;
                WriteEnable = 1;
                rd = 6;
                WriteData = ALUResult;
                // Expected: ALUResult = 32'h00000000
            end
            OR_STATE: begin
                rs1 = 1;
                rs2 = 2;
                ALUControl = 4'b0011;
                WriteEnable = 1;
                rd = 7;
                WriteData = ALUResult;
                // Expected: ALUResult = 32'h11111111
            end
            XOR_STATE: begin
                rs1 = 1;
                rs2 = 2;
                ALUControl = 4'b0100;
                WriteEnable = 1;
                rd = 8;
                WriteData = ALUResult;
                // Expected: ALUResult = 32'h11111111
            end
            SLL_STATE: begin
                rs1 = 1;
                rs2 = 3; // Shift amount taken from x3
                ALUControl = 4'b0101;
                WriteEnable = 1;
                rd = 9;
                WriteData = ALUResult;
                // Expected: ALUResult = 32'h02020200
            end
            SRL_STATE: begin
                rs1 = 1;
                rs2 = 3; // Shift amount taken from x3
                ALUControl = 4'b0110;
                WriteEnable = 1;
                rd = 10;
                WriteData = ALUResult;
                // Expected: ALUResult = 32'h00808080
            end
            BEQ_STATE: begin
                rs1 = 1;
                rs2 = 2;
                ALUControl = 4'b0111;
                WriteEnable = 1;
                rd = 11;
                WriteData = Zero ? 32'd1 : 32'd0;
                // Expected: Zero = 0 (since x1 != x2), so WriteData = 0
            end

            RAW_WRITE: begin
                WriteEnable = 1;
                rd = 12;
                WriteData = 32'h12345678;
            end

            RAW_READ: begin
                rs1 = 12;
                // Expected: ReadData1 = 32'h12345678
            end
        endcase
    end
        // PASS / FAIL Assertions
    always @(posedge clk) begin
        #1;
        case (state)
            ADD_STATE: begin
                if (ALUResult == 32'h11111111)
                    $display("ADD PASS: ALUResult = %h", ALUResult);
                else
                    $display("ADD FAIL: Expected = 11111111, Got = %h", ALUResult);
            end
            SUB_STATE: begin
                if (ALUResult == 32'h0F0F0F0F)
                    $display("SUB PASS: ALUResult = %h", ALUResult);
                else
                    $display("SUB FAIL: Expected = 0F0F0F0F, Got = %h", ALUResult);
            end
            AND_STATE: begin
                if (ALUResult == 32'h00000000)
                    $display("AND PASS: ALUResult = %h", ALUResult);
                else
                    $display("AND FAIL: Expected = 00000000, Got = %h", ALUResult);
            end
            OR_STATE: begin
                if (ALUResult == 32'h11111111)
                    $display("OR PASS: ALUResult = %h", ALUResult);
                else
                    $display("OR FAIL: Expected = 11111111, Got = %h", ALUResult);
            end
            XOR_STATE: begin
                if (ALUResult == 32'h11111111)
                    $display("XOR PASS: ALUResult = %h", ALUResult);
                else
                    $display("XOR FAIL: Expected = 11111111, Got = %h", ALUResult);
            end
            SLL_STATE: begin
                if (ALUResult == 32'h02020200)
                    $display("SLL PASS: ALUResult = %h", ALUResult);
                else
                    $display("SLL FAIL: Expected = 02020200, Got = %h", ALUResult);
            end
            SRL_STATE: begin
                if (ALUResult == 32'h00808080)
                    $display("SRL PASS: ALUResult = %h", ALUResult);
                else
                    $display("SRL FAIL: Expected = 00808080, Got = %h", ALUResult);
            end
            BEQ_STATE: begin
                if (Zero == 1'b0)
                    $display("BEQ PASS: Zero = %b", Zero);
                else
                    $display("BEQ FAIL: Expected Zero = 0, Got = %b", Zero);
            end
            RAW_READ: begin
                if (ReadData1 == 32'h12345678)
                    $display("RAW READ PASS: ReadData1 = %h", ReadData1);
                else
                    $display("RAW READ FAIL: Expected = 12345678, Got = %h", ReadData1);
            end
        endcase
    end
    // Testbench Control
    initial begin
        clk = 0;
        rst = 1;
        #12 rst = 0;
        // Wait until FSM completes its sequence
        wait (state == DONE);
        #20 $finish;
    end

endmodule
