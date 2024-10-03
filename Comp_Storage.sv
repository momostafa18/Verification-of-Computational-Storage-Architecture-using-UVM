//=====================================================================
// Project:       Computational Storage Module
// File:          computational_storage module.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   Computational storage design to reduce the redundancy of moving the addresses and 
//                then get the results back where the add and sub can be done in the memory
//=====================================================================
module computational_storage(
    input logic clk,
    input logic reset,
    input logic [7:0] addA,     // Memory Address A (8-bit address space)
    input logic [7:0] addB,     // Memory Address B (8-bit address space)
    input logic [7:0] addC,     // Memory Address C (8-bit address space)
    inout logic [15:0] DQ,      // Data bus for reading/writing (16-bit data width)
    input logic [1:0] cmd       // Command selector: 00 - RD_MEM, 01 - WR_MEM, 10 - ADD, 11 - SUB
);

	localparam RD_MEM_CMD = 2'b00 , WR_MEM_CMD = 2'b01 , ADD_CMD = 2'b10 , SUB_CMD = 2'b11;

    logic [15:0] memory [255:0]; // Memory array with 256 locations, 16-bit wide

    // Tri-state logic for DQ
    assign DQ    = (cmd == RD_MEM_CMD) ?  memory[addA]     : 16'bz; // Output data when RD_MEM_CMD

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Initialize memory to zero on reset
            integer i;
            for (i = 0; i < 256; i++) begin
                memory[i] <= 16'd0;
            end
        end
        else begin
            case (cmd)
                WR_MEM_CMD: begin
                    // Write operation: DQ -> Mem[addC]
                    memory[addC] <= DQ;
                end

                ADD_CMD: begin
                    // Addition operation: Mem[addC] = Mem[addA] + Mem[addB]
                    memory[addC] <= memory[addA] + memory[addB];
                end

                SUB_CMD: begin
                    // Subtraction operation: Mem[addC] = Mem[addA] - Mem[addB]
                    memory[addC] <= memory[addA] - memory[addB];
                end

                default: begin
                    memory[addC] <= memory[addC];
                end
            endcase
        end
    end
endmodule
