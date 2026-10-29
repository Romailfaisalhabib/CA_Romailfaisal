`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 09:07:54 AM
// Design Name: 
// Module Name: instructionMemory_tb
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
module instructionMemory_tb;
    reg  [31:0] instAddress;
    wire [31:0] instruction;
    integer i, errors;
    instructionMemory #(.OPERAND_LENGTH(31)) dut (
        .instAddress(instAddress),
        .instruction(instruction)
    );

    initial begin
        errors = 0;
        instAddress = 0;
        #10;
        // Display all 42 instructions (PC: 0x00 to 0xA4)
        $display("Dumping All Instructions");
        for (i = 0; i < 42; i = i + 1) begin
            instAddress = i * 4;
            #10;
            $display("PC=%h instruction=%h", instAddress, instruction);
        end
        $display("\nRunning Pass/Fail Checks");
        // 1. PC = 0x00
        instAddress = 32'h00;
        #10;
        if (instruction === 32'h1F000113)
            $display("PC_00 PASS: %h", instruction);
        else begin
            $display("PC_00 FAIL: Expected 1F000113, Got %h", instruction);
            errors = errors + 1;
        end
        // 2. PC = 0x30
        instAddress = 32'h30;
        #10;
        if (instruction === 32'h008000EF)
            $display("PC_30 PASS: %h", instruction);
        else begin
            $display("PC_30 FAIL: Expected 008000EF, Got %h", instruction);
            errors = errors + 1;
        end
        // 3. PC = 0x74
        instAddress = 32'h74;
        #10;
        if (instruction === 32'h00008067)
            $display("PC_74 PASS: %h", instruction);
        else begin
            $display("PC_74 FAIL: Expected 00008067, Got %h", instruction);
            errors = errors + 1;
        end
        // 4. PC = 0x80
        instAddress = 32'h80;
        #10;
        if (instruction === 32'h006292B3)
            $display("PC_80 PASS: %h", instruction);
        else begin
            $display("PC_80 FAIL: Expected 006292B3, Got %h", instruction);
            errors = errors + 1;
        end
        // 5. PC = 0x94
        instAddress = 32'h94;
        #10;
        if (instruction === 32'hFFF28293)
            $display("PC_94 PASS: %h", instruction);
        else begin
            $display("PC_94 FAIL: Expected FFF28293, Got %h", instruction);
            errors = errors + 1;
        end
        // 6. PC = 0xA4 (Last valid instruction in your 42-word memory)
        instAddress = 32'hA4;
        #10;
        if (instruction === 32'h00008067)
            $display("PC_A4 PASS: %h", instruction);
        else begin
            $display("PC_A4 FAIL: Expected 00008067, Got %h", instruction);
            errors = errors + 1;
        end
        // 7. PC = 0xA8: First unused instruction slot
        instAddress = 32'hA8;
        #10;
        if (instruction === 32'h00000000)
            $display("PC_A8 PASS: unused slot is zero");
        else begin
            $display("PC_A8 FAIL: Expected 00000000, Got %h", instruction);
            errors = errors + 1;
        end

        // Final summary
        if (errors == 0)
            $display("\nALL CHECKS PASSED");
        else
            $display("\n%0d CHECK(S) FAILED", errors);

        $finish;
    end

endmodule
