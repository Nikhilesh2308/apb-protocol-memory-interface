# APB Protocol with Memory Interface

A Verilog RTL example of an APB-style memory-mapped slave and a self-checking testbench for basic read/write transactions.

## Features
- APB SETUP and ACCESS phase stimulus in the testbench.
- Memory-mapped writes and reads.
- `PSEL`, `PENABLE`, `PWRITE`, `PADDR`, `PWDATA`, `PRDATA`, `PREADY`, and `PSLVERR` signals.
- Testbench checks data written to and read from memory.

## Files
- `rtl/apb_memory_slave.v` — synthesizable-style RTL example.
- `tb/tb_apb_memory_slave.v` — self-checking simulation testbench.
- `sim/run.sh` — local Icarus Verilog compile/run script.

## Run locally
Install Icarus Verilog, then run from the repository root:

```bash
bash sim/run.sh
```

Expected output includes PASS lines and a final `APB test summary`. Run it yourself and confirm `FAIL=0` before reporting the project as verified.

## Run on EDA Playground
1. Open [EDA Playground](https://www.edaplayground.com/).
2. Select Verilog and a supported simulator.
3. Paste `rtl/apb_memory_slave.v` into the Design pane.
4. Paste `tb/tb_apb_memory_slave.v` into the Testbench pane.
5. Run and inspect the transcript. Enable EPWave for waveforms if desired.

## Notes
This is a learning/portfolio implementation, not a complete AMBA compliance IP. It assumes word-aligned 32-bit register addresses and completes ACCESS immediately with `PREADY=1`. Extend the checks for wait states, reset behavior, invalid addresses, and full protocol assertions as needed.

## Verification status
Source and testbench have been added. Simulation results have not been independently confirmed in this repository yet.

## Skills
Verilog RTL, APB protocol concepts, memory-mapped I/O, self-checking testbenches, simulation.
