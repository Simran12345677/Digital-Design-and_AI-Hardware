#UART Protocol design
# UART Protocol Implementation in Verilog

This repository contains a purely RTL-based Universal Asynchronous Receiver-Transmitter (UART) protocol designed in Verilog and verified using Xilinx Vivado. 

The design is fully modular and features a testbench that loops serial data from the transmitter back into the receiver to verify data integrity and timing.

## Repository Structure
* `baud_rate_generator.v`: Divides the system clock to generate `tx_clk_en` and `rx_clk_en` ticks (utilizing 16x oversampling for the receiver).
* `uart_sender.v`: Converts parallel 8-bit input data into a serial stream with standard start and stop bits.
* `uart_rx.v`: Samples the incoming serial stream and reconstructs the 8-bit parallel data.
* `uart_top.v`: The top-level wrapper that instantiates the sub-modules and routes the transmitter's serial output directly into the receiver's serial input for internal loopback testing.
* `tb.v`: The simulation testbench that applies reset conditions, injects 8-bit hex payloads (e.g., `8'h41`, `8'h55`), and monitors the reconstructed output data.

## RTL Schematic
<img width="960" height="540" alt="uart schematic" src="https://github.com/user-attachments/assets/06276c35-ac1e-44cf-af77-1a5afb4c1e0d" />


## Simulation Waveforms
<img width="746" height="338" alt="self checking" src="https://github.com/user-attachments/assets/e07aab11-7aaf-461e-9f20-4094fb39f827" />

## How to Run in Xilinx Vivado
1. Create a new RTL Project in Vivado.
2. Add `baud_rate_generator.v`, `uart_sender.v`, `uart_rx.v`, and `uart_top.v` as **Design Sources**.
3. Add `tb.v` as a **Simulation Source**.
4. In the Flow Navigator, click **Run Behavioral Simulation**.
5. Use the waveform viewer to observe the `tx_temp` serial line and verify that `data_out` matches the `data_in` payloads.
