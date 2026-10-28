# APB Protocol with Memory Interface

A Verilog RTL project implementing an AMBA APB-style slave interface connected to an internal memory, with a self-checking testbench for basic read and write transactions.

## Project goals

- Implement the APB SETUP and ACCESS phases.
- Support memory-mapped read and write transactions.
- Handle `PSEL`, `PENABLE`, `PWRITE`, `PADDR`, `PWDATA`, and `PRDATA`.
- Verify transaction timing and data integrity with a self-checking testbench.

## Design overview

The APB master-side stimulus in the testbench drives the interface signals. The slave decodes the address and performs a memory read or write during the appropriate transfer phase. The testbench checks that written data can be read back correctly and reports pass/fail results.

## Repository layout

```text
.
├── rtl/       # RTL modules
├── tb/        # Testbench
├── sim/       # Simulator scripts and supporting files
└── README.md
```

> The folders above describe the intended project structure. Add the corresponding source files as they are finalized.

## Run online with EDA Playground

1. Open [EDA Playground](https://www.edaplayground.com/).
2. Select Verilog/SystemVerilog and a supported simulator.
3. Paste the design modules into the Design pane and the testbench into the Testbench pane.
4. Click **Run** and inspect the transcript for the test results. Enable EPWave if you want to inspect waveforms.

## Run locally with Icarus Verilog

Once the RTL and testbench files have been added, compile the relevant source files, for example:

```bash
iverilog -g2012 -o sim.out rtl/*.v tb/*.v
vvp sim.out
```

Adjust the file paths if the source files use different names or locations.

## Verification checklist

- [ ] APB SETUP phase precedes ACCESS phase.
- [ ] Write transactions update the selected memory location.
- [ ] Read transactions return the expected data.
- [ ] Back-to-back transactions behave as expected.
- [ ] Testbench reports no mismatches.

## Status

**Documentation scaffold:** This README describes the project scope and intended verification. Run the testbench and update this section with actual simulator, test count, and results before presenting it as validated.

## Skills demonstrated

Verilog RTL, finite-state machines, AMBA APB protocol concepts, memory-mapped interfaces, self-checking testbenches, simulation-based functional verification.

## License

Choose a license before distributing or reusing this project.
