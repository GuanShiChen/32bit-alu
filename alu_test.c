#include <stdio.h>
#include <stdint.h>
#include "alu.h"

// Assertion macro for testing
#define ASSERT_EQ(expected, actual, test_name) \
    if ((expected) != (actual)) { \
        printf("FAILED: %s - Expected: %d (0x%X), Got: %d (0x%X)\n", test_name, expected, expected, actual, actual); \
    } else { \
        printf("PASSED: %s\n", test_name); \
    }

// Unsigned assertion macro
#define ASSERT_EQ_U(expected, actual, test_name) \
    if ((uint32_t)(expected) != (uint32_t)(actual)) { \
        printf("FAILED: %s - Expected: %u (0x%X), Got: %u (0x%X)\n", test_name, (uint32_t)expected, (uint32_t)expected, (uint32_t)actual, (uint32_t)actual); \
    } else { \
        printf("PASSED: %s\n", test_name); \
    }

void run_arithmetic_tests() {
    printf("--- Arithmetic Tests ---\n");
    // Standard operations
    ASSERT_EQ(150, alu(100, 50, ADD_OP), "ADD positive");
    ASSERT_EQ(115, alu(100, 15, ADDI_OP), "ADDI positive");
    ASSERT_EQ(50, alu(100, 50, SUB_OP), "SUB positive");
    
    // Negative number operations
    ASSERT_EQ(-10, alu(-20, 10, ADD_OP), "ADD negative and positive");
    ASSERT_EQ(-30, alu(-20, -10, ADD_OP), "ADD two negatives");
    ASSERT_EQ(-30, alu(-20, 10, SUB_OP), "SUB negative from positive");
    
    // Boundary cases
    int32_t max_int = INT32_MAX;
    int32_t min_int = INT32_MIN;
    ASSERT_EQ(min_int + 1, alu(min_int, 1, ADDI_OP), "ADDI to MIN_INT");
    ASSERT_EQ(min_int + 1, alu(max_int, 2, ADD_OP), "ADD overflow INT32_MAX + 2");
    ASSERT_EQ(min_int + 2, alu(min_int, -2, SUB_OP), "SUB underflow");
    
    // LUI test
    ASSERT_EQ_U(0x12345000, alu(0, 0x12345, LUI_OP), "LUI standard value");
    ASSERT_EQ_U(0xFFFFF000, alu(0, 0xFFFFF, LUI_OP), "LUI max immediate value");
    printf("\n");
}

void run_logical_tests() {
    printf("--- Logical Tests ---\n");
    uint32_t op1 = 0xF00F0F00;
    uint32_t op2 = 0x0F00F0F0;
    
    // Standard operations
    ASSERT_EQ_U(0x0, alu(op1, op2, AND_OP), "AND standard");
    ASSERT_EQ_U(0xFF0FFFF0, alu(op1, op2, OR_OP), "OR standard");
    ASSERT_EQ_U(0xFF0FFFF0, alu(op1, op2, XOR_OP), "XOR standard");
    
    // Immediate operations
    ASSERT_EQ_U(0x0F00, alu(op1, 0x0F00, ANDI_OP), "ANDI standard");
    ASSERT_EQ_U(0xF00F0FFF, alu(op1, 0xFFF, ORI_OP), "ORI standard");
    ASSERT_EQ_U(0xF00F000F, alu(op1, 0xF0F, XORI_OP), "XORI standard");
    printf("\n");
}

void run_shift_tests() {
    printf("--- Shift Tests ---\n");
    int32_t pos_val = 256;  // 0x00000100
    int32_t neg_val = -256; // 0xFFFFFEE0
    
    // SLL/SLLI
    ASSERT_EQ(1024, alu(pos_val, 2, SLL_OP), "SLL positive");
    ASSERT_EQ(1024, alu(pos_val, 2, SLLI_OP), "SLLI positive");
    ASSERT_EQ(pos_val << 31, alu(pos_val, 31, SLL_OP), "SLL by 31");
    ASSERT_EQ(pos_val, alu(pos_val, 0, SLL_OP), "SLL by 0");
    ASSERT_EQ(pos_val, alu(pos_val, 32, SLL_OP), "SLL by >31 (wraps around)");
    
    // SRL/SRLI (unsigned shifts)
    ASSERT_EQ_U(64, alu(pos_val, 2, SRL_OP), "SRL positive");
    ASSERT_EQ_U(64, alu(pos_val, 2, SRLI_OP), "SRLI positive");
    ASSERT_EQ_U(0, alu(pos_val, 31, SRLI_OP), "SRLI positive by 31");
    ASSERT_EQ_U(0x7FFFFFFF, alu(0xFFFFFFFF, 1, SRLI_OP), "SRLI -1");
    ASSERT_EQ_U(0x7FFFFFFE, alu(0xFFFFFFFC, 1, SRLI_OP), "SRLI negative number");
    
    // SRA/SRAI (signed shifts)
    ASSERT_EQ(neg_val >> 2, alu(neg_val, 2, SRA_OP), "SRA negative");
    ASSERT_EQ(neg_val >> 2, alu(neg_val, 2, SRAI_OP), "SRAI negative");
    ASSERT_EQ(-1, alu(-1, 31, SRA_OP), "SRA -1 by 31");
    ASSERT_EQ(-1, alu(-1, 31, SRAI_OP), "SRAI -1 by 31");
    ASSERT_EQ(0, alu(1, 31, SRA_OP), "SRA 1 by 31");
    ASSERT_EQ(0, alu(1, 31, SRAI_OP), "SRAI 1 by 31");
    printf("\n");
}

void run_comparison_tests() {
    printf("--- Comparison Tests ---\n");
    int32_t pos1 = 100, pos2 = 50;
    int32_t neg1 = -100, neg2 = -50;
    uint32_t u_pos1 = 100, u_pos2 = 50;
    uint32_t u_neg1 = 0xFFFFFF9C; // -100 as unsigned
    uint32_t u_neg2 = 0xFFFFFFD2; // -50 as unsigned

    // SLT/SLTI (signed)
    ASSERT_EQ(0, alu(pos1, pos2, SLT_OP), "SLT pos1 > pos2");
    ASSERT_EQ(1, alu(pos2, pos1, SLT_OP), "SLT pos2 < pos1");
    ASSERT_EQ(1, alu(neg1, neg2, SLT_OP), "SLT neg1 < neg2");
    ASSERT_EQ(0, alu(neg2, neg1, SLT_OP), "SLT neg2 > neg1");
    ASSERT_EQ(1, alu(neg1, pos1, SLT_OP), "SLT negative < positive");
    ASSERT_EQ(1, alu(50, 100, SLTI_OP), "SLTI positive");
    ASSERT_EQ(0, alu(50, -100, SLTI_OP), "SLTI negative immediate");

    // SLTU/SLTIU (unsigned)
    ASSERT_EQ(0, alu(u_pos1, u_pos2, SLTU_OP), "SLTU pos1 > pos2");
    ASSERT_EQ(1, alu(u_pos2, u_pos1, SLTU_OP), "SLTU pos2 < pos1");
    ASSERT_EQ(1, alu(u_neg1, u_neg2, SLTU_OP), "SLTU unsigned neg1 < unsigned neg2");
    ASSERT_EQ(0, alu(u_neg2, u_neg1, SLTU_OP), "SLTU unsigned neg2 > unsigned neg1");
    ASSERT_EQ(0, alu(u_neg1, u_pos1, SLTU_OP), "SLTU unsigned negative > positive");
    ASSERT_EQ(1, alu(100, 200, SLTIU_OP), "SLTIU positive");
    ASSERT_EQ(1, alu(100, -200, SLTIU_OP), "SLTIU positive vs negative immediate");
    printf("\n");
}

int main() {
    printf("--- Comprehensive RISC-V ALU Test Suite ---\n\n");
    
    run_arithmetic_tests();
    run_logical_tests();
    run_shift_tests();
    run_comparison_tests();
    
    return 0;
}