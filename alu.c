#include "alu.h"
#include <stdio.h>

int32_t alu(int32_t op1, int32_t op2, alu_opcode opcode) {
    int32_t result;

    switch (opcode) {
        case ADD_OP:
        case ADDI_OP:
            result = op1 + op2;
            break;
        case SUB_OP:
            result = op1 - op2;
            break;
        case LUI_OP:
            result = op2 << 12;
            break;
        case AND_OP:
        case ANDI_OP:
            result = op1 & op2;
            break;
        case OR_OP:
        case ORI_OP:
            result = op1 | op2;
            break;
        case XOR_OP:
        case XORI_OP:
            result = op1 ^ op2;
            break;
        case SLL_OP:
        case SLLI_OP:
            result = op1 << (op2 & 0x1F);
            break;
        case SRL_OP:
        case SRLI_OP:
            result = (uint32_t)op1 >> (op2 & 0x1F);
            break;
        case SRA_OP:
        case SRAI_OP:
            result = op1 >> (op2 & 0x1F);
            break;
        case SLT_OP:
        case SLTI_OP:
            result = (op1 < op2) ? 1 : 0;
            break;
        case SLTU_OP:
        case SLTIU_OP:
            result = ((uint32_t)op1 < (uint32_t)op2) ? 1 : 0;
            break;
        default:
            printf("Error: Unsupported opcode.\n");
            result = 0;
    }

    return result;
}