#ifndef ALU_H
#define ALU_H

#include <stdint.h>

// Enum of opcodes for the ALU
typedef enum {
    // R-type instructions
    ADD_OP,     // add
    SUB_OP,     // sub
    AND_OP,     // and
    OR_OP,      // or
    XOR_OP,     // xor
    SLL_OP,     // sll (shift left logical)
    SRL_OP,     // srl (shift right logical)
    SRA_OP,     // sra (shift right arithmetic)
    SLT_OP,     // slt (set if less than)
    SLTU_OP,    // sltu (set if less than unsigned)
    
    // I-type instructions
    ADDI_OP,    // addi
    ANDI_OP,    // andi
    ORI_OP,     // ori
    XORI_OP,    // xori
    SLLI_OP,    // slli
    SRLI_OP,    // srli
    SRAI_OP,    // srai
    SLTI_OP,    // slti
    SLTIU_OP,   // sltiu

    // U-type instruction
    LUI_OP      // lui (load upper immediate)
} alu_opcode;

int32_t alu(int32_t op1, int32_t op2, alu_opcode opcode);

#endif