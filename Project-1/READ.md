<img width="958" height="140" alt="Vending_machine" src="https://github.com/user-attachments/assets/2c66abf8-ba3c-40b8-a606-3185689c1e64" />
# Vending Machine Controller (FSM) using Verilog

A synthesizable, high-performance **Finite State Machine (FSM)** based Vending Machine Controller implemented in Verilog HDL. This controller is designed using a **Moore Machine** architecture, ensuring outputs are glitch-free and depend solely on the current state.

---

## 📌 Project Specifications

* **Product Cost:** 15 cents (or currency units)
* **Supported Inputs (Coins):**
  * **Nickel (5 cents):** Input `coin = 2'b01`
  * **Dime (10 cents):** Input `coin = 2'b10`
  * **No Coin:** Input `coin = 2'b00`
* **Outputs:**
  * **`dispense`:** Activates (high) when total money deposited reaches or exceeds 15 cents.
  * **`change`:** Activates (high) only when 20 cents is deposited, returning 5 cents change.

---

## 🛠️ Finite State Machine (FSM) Design

The system uses **One-Hot Encoding** for fast state transitions and low propagation delay.

### State Definitions:
1. `IDLE` (`5'b00001`): Initial state (0 cents deposited)
2. `S5` (`5'b00010`): 5 cents deposited
3. `S10` (`5'b00100`): 10 cents deposited
4. `S15` (`5'b01000`): 15 cents deposited (Dispense = 1, Change = 0)
5. `S20` (`5'b10000`): 20 cents deposited (Dispense = 1, Change = 1)

---

## 📁 File Structure

```text
├── vending_machine_controller.v  # Design File (FSM logic)
├── tb_vending_machine.v          # Testbench File (Simulation scenarios)
├── waveform.png                  # Waveform Screenshot
└── README.md                     # Project Documentation
