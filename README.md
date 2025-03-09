# variant_of_multiplier_ST
design for 32-bit and parameterized RTL for variant of multiplier : right_shift_algorithm multiplier ,radix_8_booth_Recoding multiplier and at last combinational Array_multiplier
# Multiplier Designs: Shift-Add, Radix-8 Booth, and Array Multiplier  
This repository contains three Verilog implementations of signed multipliers:  
1. **Shift-Add Multiplier**  
2. **Radix-8 Booth Multiplier**  
3. **Array Multiplier**  

---

## Overview  
Each design targets a balance between speed, area, and power efficiency, with trade-offs suited for different applications (e.g., low-latency vs. resource-constrained systems).  

---

## Design Descriptions  

### 1. Shift-Add Multiplier  
- **Algorithm**: Iterative addition and shifting.  
- **Features**:  
  - Parameterized bit-width (`WIDTH`).  
  - Latency: `WIDTH` clock cycles.  
  - Low area footprint, suitable for small operands.
  - critical path is Adder in the datapath
- **Key Signals**:  
  - `clk`, `rst`: Clock and active-low reset.  
  - `x`, `y`: `WIDTH`-bit signed inputs.  
  - `product`: `2*WIDTH`-bit signed output.  

### 2. Radix-8 Booth Multiplier  
- **Algorithm**: Radix-8 Booth encoding for reduced iterations.  
- **Features**:  
  - Processes **3 bits per cycle**, reducing iterations to `ceil(WIDTH/3)`.  
  - Handles signed numbers .  
  - Optimized for medium-speed, medium-area applications.
  - critical path is Final carry-propagate adder
- **Key Components**:  
  - **Booth Encoder**: Generates partial products (±x, ±2x, ±3x, ±4x).  
  - **Carry-Save Adder (CSA)**: Accumulates partial products.  

### 3. Array Multiplier  
- **Algorithm**: Parallel adder array for combinatorial multiplication.  
- **Features**:  
  - Zero clock latency (combinational logic).  
  - High area usage due to adder grid.  
  - Ideal for high-speed, non-pipelined applications.
  - critical path is Longest adder chain in the grid (carry[width-1][width-2])
- **Structure**:  
  - **AND Gates**: Generate partial products.  
  - **Full Adders**: Sum partial products in a grid.  

---

## Simulation Instructions  
### Tools Required:  
- **Simulator**: Icarus Verilog (`iverilog`), questa, or ModelSim.  
- **Waveform Viewer**: GTKWave.  

### Steps:  
1. **Compile and Simulate**:  
   ```bash
   testbensh included
