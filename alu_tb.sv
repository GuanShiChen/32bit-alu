`timescale 1ns / 1ps

module alu_tb;

    // -- Testbench Signals --
    reg  [31:0] operand_a;
    reg  [31:0] operand_b;
    reg  [4:0]  opcode;
    wire [31:0] result;

    // -- Opcodes --
    localparam ADD_OP   = 5'd0;
    localparam SUB_OP   = 5'd1;
    localparam AND_OP   = 5'd2;
    localparam OR_OP    = 5'd3;
    localparam XOR_OP   = 5'd4;
    localparam SLL_OP   = 5'd5;
    localparam SRL_OP   = 5'd6;
    localparam SRA_OP   = 5'd7;
    localparam SLT_OP   = 5'd8;
    localparam SLTU_OP  = 5'd9;
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

    // -- DUT Instantiation --
    alu dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .opcode(opcode),
        .result(result)
    );
    
    // -- Test Execution --
    initial begin
        $display("--- Comprehensive RISC-V ALU Test Suite ---\n");
        
        run_arithmetic_tests();
        run_logical_tests();
        run_shift_tests();
        run_comparison_tests();
        
        $display("--- All tests completed. ---");
        $finish;
    end

    // -- Helper Tasks --
    task assert_eq(input [31:0] expected, input string test_name);
        #1;
        if (result !== expected) begin
            $display("FAILED: %s - Expected: %d (0x%h), Got: %d (0x%h)", 
                     test_name, expected, expected, result, result);
        end else begin
            $display("PASSED: %s", test_name);
        end
    endtask

    task assert_eq_u(input [31:0] expected, input string test_name);
        #1;
        if (result !== expected) begin
            $display("FAILED: %s - Expected: %u (0x%h), Got: %u (0x%h)", 
                     test_name, expected, expected, result, result);
        end else begin
            $display("PASSED: %s", test_name);
        end
    endtask

    // -- Test Cases --    
    task run_arithmetic_tests;
        logic signed [31:0] max_int = 32'h7FFFFFFF;
        logic signed [31:0] min_int = 32'h80000000;

        $display("--- Arithmetic Tests ---");
        
        // Addition & Subtraction
        {operand_a, operand_b, opcode} = {100, 50, ADD_OP};       assert_eq(150, "ADD positive");
        {operand_a, operand_b, opcode} = {100, 15, ADDI_OP};      assert_eq(115, "ADDI positive");
        {operand_a, operand_b, opcode} = {100, 50, SUB_OP};       assert_eq(50, "SUB positive");
        {operand_a, operand_b, opcode} = {-20, 10, ADD_OP};       assert_eq(-10, "ADD negative and positive");
        {operand_a, operand_b, opcode} = {-20, -10, ADD_OP};      assert_eq(-30, "ADD two negatives");
        {operand_a, operand_b, opcode} = {-20, 10, SUB_OP};       assert_eq(-30, "SUB negative from positive");
        
        // Boundary cases (overflow/underflow)
        {operand_a, operand_b, opcode} = {max_int, 2, ADD_OP};    assert_eq(min_int + 1, "ADD overflow INT32_MAX + 2");
        {operand_a, operand_b, opcode} = {min_int, -2, SUB_OP};   assert_eq(min_int + 2, "SUB underflow INT32_MIN - 2");
        
        // LUI (Load Upper Immediate)
        {operand_a, operand_b, opcode} = {0, 32'h12345, LUI_OP};  assert_eq_u(32'h12345000, "LUI standard value");
        {operand_a, operand_b, opcode} = {0, 32'hFFFFF, LUI_OP};  assert_eq_u(32'hFFFFF000, "LUI max immediate value");
        
        $display("");
    endtask

    task run_logical_tests;
        logic [31:0] op1 = 32'hF00F0F00;
        logic [31:0] op2 = 32'h0F00F0F0;
        
        $display("--- Logical Tests ---");
        
        // R-type Logical Operations
        {operand_a, operand_b, opcode} = {op1, op2, AND_OP};      assert_eq_u(32'h00000000, "AND standard");
        {operand_a, operand_b, opcode} = {op1, op2, OR_OP};       assert_eq_u(32'hFF0FFFF0, "OR standard");
        {operand_a, operand_b, opcode} = {op1, op2, XOR_OP};      assert_eq_u(32'hFF0FFFF0, "XOR standard");
        
        // I-type Logical Operations (Immediate)
        {operand_a, operand_b, opcode} = {op1, 32'h0F00, ANDI_OP}; assert_eq_u(32'h00000F00, "ANDI standard");
        {operand_a, operand_b, opcode} = {op1, 32'h0FFF, ORI_OP};  assert_eq_u(32'hF00F0FFF, "ORI standard");
        {operand_a, operand_b, opcode} = {op1, 32'h0F0F, XORI_OP}; assert_eq_u(32'hF00F000F, "XORI standard");
        
        $display("");
    endtask

    task run_shift_tests;
        logic signed [31:0] pos_val = 256;    // 0x00000100
        logic signed [31:0] neg_val = -256;   // 0xFFFFFF00
        
        $display("--- Shift Tests ---");
        
        // SLL/SLLI (Logical Left)
        {operand_a, operand_b, opcode} = {pos_val, 2, SLL_OP};    assert_eq(1024, "SLL positive");
        {operand_a, operand_b, opcode} = {pos_val, 2, SLLI_OP};   assert_eq(1024, "SLLI positive");
        
        // SRL/SRLI (Logical Right)
        {operand_a, operand_b, opcode} = {pos_val, 2, SRL_OP};    assert_eq_u(64, "SRL positive");
        {operand_a, operand_b, opcode} = {pos_val, 2, SRLI_OP};   assert_eq_u(64, "SRLI positive");
        {operand_a, operand_b, opcode} = {32'hFFFFFFFF, 1, SRLI_OP}; assert_eq_u(32'h7FFFFFFF, "SRLI -1");
        
        // SRA/SRAI (Arithmetic Right)
        {operand_a, operand_b, opcode} = {neg_val, 2, SRA_OP};    assert_eq(neg_val >>> 2, "SRA negative");
        {operand_a, operand_b, opcode} = {neg_val, 2, SRAI_OP};   assert_eq(neg_val >>> 2, "SRAI negative");
        {operand_a, operand_b, opcode} = {-1, 31, SRA_OP};        assert_eq(-1, "SRA -1 by 31");
        {operand_a, operand_b, opcode} = {1, 31, SRA_OP};         assert_eq(0, "SRA 1 by 31");
        
        $display("");
    endtask

    task run_comparison_tests;
        logic signed [31:0] pos1 = 100, pos2 = 50;
        logic signed [31:0] neg1 = -100, neg2 = -50;

        $display("--- Comparison Tests ---");

        // SLT/SLTI (Signed)
        {operand_a, operand_b, opcode} = {pos1, pos2, SLT_OP};    assert_eq(0, "SLT pos1 > pos2");
        {operand_a, operand_b, opcode} = {pos2, pos1, SLT_OP};    assert_eq(1, "SLT pos2 < pos1");
        {operand_a, operand_b, opcode} = {neg1, neg2, SLT_OP};    assert_eq(1, "SLT neg1 < neg2");
        {operand_a, operand_b, opcode} = {neg2, neg1, SLT_OP};    assert_eq(0, "SLT neg2 > neg1");
        {operand_a, operand_b, opcode} = {neg1, pos1, SLT_OP};    assert_eq(1, "SLT negative < positive");
        
        // SLTU/SLTIU (Unsigned)
        {operand_a, operand_b, opcode} = {pos1, pos2, SLTU_OP};   assert_eq(0, "SLTU pos1 > pos2");
        {operand_a, operand_b, opcode} = {pos2, pos1, SLTU_OP};   assert_eq(1, "SLTU pos2 < pos1");
        {operand_a, operand_b, opcode} = {neg1, pos1, SLTU_OP};   assert_eq(0, "SLTU unsigned negative > positive");
        {operand_a, operand_b, opcode} = {100, 200, SLTIU_OP};    assert_eq(1, "SLTIU positive");
        {operand_a, operand_b, opcode} = {100, -200, SLTIU_OP};   assert_eq(1, "SLTIU positive vs negative immediate");
        
        $display("");
    endtask

endmodule