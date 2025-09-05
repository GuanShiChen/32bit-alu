`timescale 1ns / 1ps

module alu (
    input  [31:0] operand_a, // First 32-bit operand
    input  [31:0] operand_b, // Second 32-bit operand or immediate value
    input  [4:0]  opcode,    // 5-bit opcode to select the operation
    output reg [31:0] result // 32-bit result of the operation
);

    // -- Opcodes --
    // Arithmetic & Logical (R-type)
    localparam ADD_OP  = 5'd0;
    localparam SUB_OP  = 5'd1;
    localparam AND_OP  = 5'd2;
    localparam OR_OP   = 5'd3;
    localparam XOR_OP  = 5'd4;
    localparam SLL_OP  = 5'd5;
    localparam SRL_OP  = 5'd6;
    localparam SRA_OP  = 5'd7;
    localparam SLT_OP  = 5'd8;
    localparam SLTU_OP = 5'd9;
    
    // Immediate Instructions
    localparam ADDI_OP  = 5'd10;
    localparam ANDI_OP  = 5'd11;
    localparam ORI_OP   = 5'd12;
    localparam XORI_OP  = 5'd13;
    localparam SLLI_OP  = 5'd14;
    localparam SRLI_OP  = 5'd15;
    localparam SRAI_OP  = 5'd16;
    localparam SLTI_OP  = 5'd17;
    localparam SLTIU_OP = 5'd18;
    localparam LUI_OP   = 5'd19;

    // -- ALU Logic --
    always @(*) begin
        case (opcode)
            // Arithmetic Operations
            ADD_OP, ADDI_OP:
                result = operand_a + operand_b;
            SUB_OP:
                result = operand_a - operand_b;
            LUI_OP:
                result = operand_b << 12;

            // Logical Operations
            AND_OP, ANDI_OP:
                result = operand_a & operand_b;
            OR_OP, ORI_OP:
                result = operand_a | operand_b;
            XOR_OP, XORI_OP:
                result = operand_a ^ operand_b;

            // Shift Operations
            SLL_OP, SLLI_OP:
                result = operand_a << operand_b[4:0];
            SRL_OP, SRLI_OP:
                result = operand_a >> operand_b[4:0];
            SRA_OP, SRAI_OP:
                result = $signed(operand_a) >>> operand_b[4:0];

            // Comparison Operations
            SLT_OP, SLTI_OP:
                result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            SLTU_OP, SLTIU_OP:
                result = (operand_a < operand_b) ? 32'd1 : 32'd0;
            
            // Default Case
            default:
                result = 32'b0;
        endcase
    end

endmodule