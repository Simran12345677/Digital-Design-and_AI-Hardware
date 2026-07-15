<img width="960" height="237" alt="sync_FIFO" src="https://github.com/user-attachments/assets/80213f35-d780-4a9e-a129-8e5c0bec70b2" />
# Parameterized Synchronous FIFO Memory Buffer

A high-performance, parameterized Synchronous FIFO (First-In, First-Out) memory buffer designed in Verilog HDL. This architecture uses a dual-pointer scheme with an integrated extra-bit pointer tracking methodology to robustly eliminate full/empty flag ambiguity. The design has been verified across multiple functional test scenarios using industry-standard simulation metrics.

---

## 🛠 Features
* **Fully Parameterized Architecture:** Depth (`FIFO_DEPTH`) and data bus width (`DATA_WIDTH`) can be dynamic configured during instantiation.
* **Flag Optimization:** Employs an $(N+1)$-bit pointer strategy for an $N$-bit address space to distinctively resolve structural boundary conditions (Full vs. Empty states).
* **Active-Low Asynchronous Reset:** Includes hardware-compliant asynchronous control circuitry for determinism upon bootup.
* **Chip Select Control Line:** Embedded `cs` line logic allows clean power/signal isolation within multi-subsystem environments.

---

## 📐 Architecture & Flag Logic
The design relies on two internal pointers (`wr_ptr` and `rd_ptr`) of bit-width $\log_2(\text{FIFO\_DEPTH}) + 1$. 

### **Flag Conditions**
* **Empty Flag (`empty`):** Asserted when the write pointer matches the read pointer exactly, indicating that all written data blocks have been read.
    $$\text{empty} = (\text{wr\_ptr} == \text{rd\_ptr})$$
* **Full Flag (`full`):** Asserted when the pointers point to the same physical memory index but reside in opposite rotation cycles (MSBs do not match).
    $$\text{full} = (\text{wr\_ptr}[\text{MSB}] \neq \text{rd\_ptr}[\text{MSB}]) \ \&\& \ (\text{wr\_ptr}[\text{MSB}-1:0] == \text{rd\_ptr}[\text{MSB}-1:0])$$

---

## 💾 Block Diagram & Pin Description

| Signal Name | Direction | Bit-Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1-bit | Global System Clock |
| `rst_n` | Input | 1-bit | Active-Low Asynchronous Reset |
| `cs` | Input | 1-bit | Chip Select (Active High) |
| `we` | Input | 1-bit | Write Enable |
| `re` | Input | 1-bit | Read Enable |
| `data_in` | Input | `[DATA_WIDTH-1:0]` | Input Parallel Data Bus |
| `data_out` | Output | `[DATA_WIDTH-1:0]` | Output Parallel Data Bus |
| `empty` | Output | 1-bit | Buffer Empty Status Indicator Flag |
| `full` | Output | 1-bit | Buffer Full Status Indicator Flag |

---

## 🧪 Verification Scenarios
The accompanying testbench handles functional boundary validation through three distinct algorithmic blocks:

1.  **Scenario 1: Standard Sequential Write & Read**
    * Writes deterministic test vectors ($1, 10, 100$) into the memory array and reads them out to verify strict FIFO ordering constraints.
2.  **Scenario 2: Back-to-Back Continuous Operations**
    * Executes simultaneous/consecutive write and read pipelines using walking bit patterns (`1 << i`) to prove datapath reliability under zero-wait state conditions.
3.  **Scenario 3: Boundary Flag Checks (Overflow & Underflow Prevention)**
    * Fills the buffer up to its limit (`FIFO_DEPTH = 8`) to force `full = 1`. Verifies that subsequent data injections (`500`) are safely dropped.
    * Drains the buffer until `empty = 1` and confirms that data bus floating/latching remains safe during underflow attempts.

---

## 📈 Simulation & Waveform Verification
To view the hardware timing constraints digitally, configure your EDA tool suite (e.g., EDA Playground, ModelSim, or Icarus Verilog) with the following steps:

1. Map `design.sv` and `testbench.sv` into your project directory.
2. Select **SystemVerilog/Verilog** language parameters and run the compiler.
3. Pull the following key tracking signals to the timeline viewing panel:
   * `clk`, `rst_n` (Clock and Control lines)
   * `wr_ptr`, `rd_ptr` (Set radix representation format to **Unsigned Decimal** or **Hexadecimal** to view pointer rollover cycles easily)
   * `full`, `empty` (Flag toggling states)
   * `data_in`, `data_out` (Bus transaction integrity checks)

*(Optional: Insert your EPWave/ModelSim timing diagram screenshot right here for higher recruiter conversion metrics)*
