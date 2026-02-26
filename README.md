# 8-Bit Binary ↔ Gray Code Converter (FSM Architecture)

## 📌 Overview

This project implements an **8-bit Binary to Gray** and **Gray to Binary** converter using a structured hardware architecture in Verilog.

Design constraints followed:

- Only **1 XOR gate**
- 8-bit **PIPO Registers (R1, R2)**
- Two 1-bit registers (R3, R4)
- **Tri-state 8-bit bus**
- Bit-selector MUXes
- 3-bit down counter (7 → 0)
- **Moore FSM Control Unit**
- Verified using a **Testbench**

---

## 🔧 Hardware Components

- **R1** – Stores input number  
- **R2** – Stores converted output  
- **R3, R4** – Hold bits for XOR operation  
- **Single XOR gate** – Performs bitwise conversion  
- **3-bit Down Counter** – Controls bit position  
- **Tri-state Bus** – Prevents bus contention  
- **MUXes** – Select required bits  
- **Moore FSM** – Controls full process  

---

## 🔄 Conversion Logic

### Binary → Gray
- MSB copied directly
- Gray[i] = Binary[i+1] XOR Binary[i]

### Gray → Binary
- MSB copied directly
- Binary[i] = Binary[i+1] XOR Gray[i]

---

## 🎛 Control Unit

Inputs:
- `Start`
- `Convert` (0 → Bin→Gray, 1 → Gray→Bin)
- `Clock`

Outputs:
- Register control signals
- `Done` (High when conversion completes)

When `Start = 0`, R2 holds `8'bzzzzzzzz`.

---

## 🧪 Verification

A Verilog **testbench** is written to:

- Apply Binary input
- Apply Gray input
- Toggle Convert signal
- Verify correct output
- Check Done signal

---

## 🎯 Objective

To implement a **resource-constrained, FSM-controlled code converter architecture** using proper bus management and sequential bit processing.

---

**Author:** Advaith Manoj  
