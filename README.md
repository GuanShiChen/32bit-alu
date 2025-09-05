# 32-bit RISC-V ALU: C and Verilog Implementation

## Overview
The project implements an ALU that supports a subset of the base integer (RV32I) instructions, including:

- Addition and Subtraction  
- Bitwise Logical Operations (AND, OR, XOR)  
- Logical and Arithmetic Shifts  
- Set-on-Less-Than Comparisons (signed and unsigned)  
- Load Upper Immediate (LUI)  

## File Structure
The repository is organized into a C model and a Verilog model, each with its own testing file.

- **alu.h** – C header file defining the `alu_opcode` enum
- **alu.c** – C source file containing the ALU logic
- **alu_test.c** – Comprehensive C test program covering standard, negative, and boundary cases
- **alu.v** – Synthesizable Verilog ALU module
- **alu_tb.sv** – SystemVerilog testbench mirroring the C test cases


## Opcode Mapping
| Opcode Name | Value (Decimal) | Instruction Type |
|-------------|-----------------|------------------|
| ADD_OP      | 0               | R-Type           |
| SUB_OP      | 1               | R-Type           |
| AND_OP      | 2               | R-Type           |
| OR_OP       | 3               | R-Type           |
| XOR_OP      | 4               | R-Type           |
| SLL_OP      | 5               | R-Type           |
| SRL_OP      | 6               | R-Type           |
| SRA_OP      | 7               | R-Type           |
| SLT_OP      | 8               | R-Type           |
| SLTU_OP     | 9               | R-Type           |
| ADDI_OP     | 10              | I-Type           |
| ANDI_OP     | 11              | I-Type           |
| ORI_OP      | 12              | I-Type           |
| XORI_OP     | 13              | I-Type           |
| SLLI_OP     | 14              | I-Type           |
| SRLI_OP     | 15              | I-Type           |
| SRAI_OP     | 16              | I-Type           |
| SLTI_OP     | 17              | I-Type           |
| SLTIU_OP    | 18              | I-Type           |
| LUI_OP      | 19              | U-Type           |

---

## Waveform:
![alu_tb waveform](/Waveform.png)
