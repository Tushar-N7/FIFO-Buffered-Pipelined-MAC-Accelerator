# RISC-V Based PPA-Optimized MAC Accelerator

## Project Overview

This project implements and verifies a parameterized
Multiply-Accumulate (MAC) accelerator using SystemVerilog.

The MAC performs:

    Result = (A × B) + ACC

The project will progressively cover:

- RTL design
- Functional verification
- Python reference modeling
- Randomized testing
- Assertions
- RTL synthesis
- Static Timing Analysis
- PPA optimization
- Pipelined architecture
- RISC-V integration
- ASIC physical design
- RTL-to-GDSII flow

## Current Version

### Version 1 - Basic MAC

- 8-bit unsigned operands
- 16-bit multiplication result
- 16-bit accumulator
- Combinational implementation
- SystemVerilog RTL
- Simulation testbench
- Python reference model

## Tools

- SystemVerilog
- Python
- Icarus Verilog
- GTKWave
- Yosys
- OpenSTA
- OpenLane
- SKY130