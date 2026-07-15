<img width="957" height="165" alt="8_bit_ALU" src="https://github.com/user-attachments/assets/ef407910-e79c-4e82-8529-42b3cfa798f2" />
# 8-Bit ALU (Arithmetic Logic Unit) using Verilog

A synthesizable 8-bit Arithmetic Logic Unit (ALU) designed and simulated strictly using **Verilog-2001**. This project avoids any SystemVerilog constructs and focuses on core behavioral modeling concepts, function logic implementation, and combinational circuit design.

The design handles bit-growth appropriately by utilizing a 9-bit output register to prevent data loss or carry-truncation during arithmetic operations (e.g., $255 + 255 = 510$).

---

## Features & Supported Operations

The ALU decodes a 4-bit Operation Select (`ALU_Sel`) signal to execute 16 distinct arithmetic, logical, shift, and comparison operations:

| Opcode (`ALU_Sel`) | Operation | Description |
| :--- | :--- | :--- |
| `4'b0000` | **ADD** | 8-bit Addition ($A + B$) with Carry retention |
| `4'b0001` | **SUB** | 8-bit Subtraction ($A - B$) |
| `4'b0010` | **MUL** | Multiplication |
| `4'b0011` | **DIV** | Division |
| `4'b0100` | **SHL** | Logical Shift Left ($A \ll 1$) |
| `4'b0101` | **SHR** | Logical Shift Right ($A \gg 1$) |
| `4'b0110` | **ROL** | Rotate Left |
| `4'b0111` | **ROR** | Rotate Right |
| `4'b1000` | **AND** | Bitwise AND |
| `4'b1001` | **OR**  | Bitwise OR |
| `4'b1010` | **XOR** | Bitwise XOR |
| `4'b1011` | **NOR** | Bitwise NOR |
| `4'b1100` | **NAND**| Bitwise NAND |
| `4'b1101` | **XNOR**| Bitwise XNOR |
| `4'b1110` | **CMP_GT**| Greater than comparison ($A > B$) |
| `4'b1111` | **CMP_EQ**| Equality check ($A == B$) |

---

## Hardware Architecture

* **Inputs:** 
  * `A` [7:0] : 8-bit Data Input
  * `B` [7:0] : 8-bit Data Input
  * `ALU_Sel` [3:0] : 4-bit Operation Selector
* **Outputs:** 
  * `ALU_Out` [8:0] : 9-bit Output Bus (handles overflow/carry seamlessly)

---

## Simulation & Testbench Results

The design was simulated using a custom testbench capturing distinct edge cases. Value Change Dump (`.vcd`) configurations were enabled to evaluate signal transitions automatically.

### Console Log Output
```text
Time=0  | A=255, B=255, Sel=0000 | Out=510  (Addition with Carry)
Time=10 | A=240, B=15,  Sel=0001 | Out=225  (Subtraction)
Time=20 | A=170, B=204, Sel=1000 | Out=136  (Bitwise AND)
