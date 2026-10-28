# APB Protocol with Memory Interface

**Portfolio project:** PRJ_05 — Protocol Design & Verification  
**Language:** Verilog-2001  
**Simulation:** Icarus Verilog on EDA Playground

## Objective
Implement a simple APB-style memory-mapped slave and verify read/write data integrity through a self-checking testbench.

## Repository layout
```text
rtl/
  apb_memory_slave.v       # APB memory slave RTL
tb/
  tb_apb_memory_slave.v    # clock/reset, APB transactions, scoreboarding
sim/
  run.sh                   # local Icarus Verilog run script
.gitignore
README.md
```

## Design overview
- Parameterized address width, data width, and memory depth.
- Uses `PSEL` and `PENABLE` to identify the APB ACCESS phase.
- Supports word-aligned 32-bit memory accesses.
- Exposes `PREADY` and `PSLVERR`; this learning implementation keeps `PREADY` high and does not model wait states.
- The testbench drives SETUP then ACCESS phases and checks read-back data.

## Verification scenarios
| Address | Operation | Expected data |
|---|---|---|
| `0x00` | Write then read | `0x1234ABCD` |
| `0x04` | Write then read | `0xDEADBEEF` |
| `0x0C` | Write then read | `0xA5A55A5A` |

## EDA Playground
1. Open [EDA Playground](https://www.edaplayground.com/).
2. Select Verilog and Icarus Verilog.
3. Paste `rtl/apb_memory_slave.v` in the Design pane.
4. Paste `tb/tb_apb_memory_slave.v` in the Testbench pane.
5. Click **Run**. Use **Get Signals** in EPWave to add signals to the waveform.

### Observed run
The EDA Playground transcript supplied during project development reported:

```text
PASS: addr=0x0 data=0x1234abcd
PASS: addr=0x4 data=0xdeadbeef
PASS: addr=0xc data=0xa5a55a5a
APB test summary: PASS=3 FAIL=0
ALL APB TESTS PASSED
```

This records the observed run; it is not a claim of full AMBA APB compliance.

## Run locally
Install Icarus Verilog, then run from the repository root:

```bash
bash sim/run.sh
```

## Scope and limitations
This is a learning/portfolio implementation, not production-ready AMBA compliance IP. It completes ACCESS immediately with `PREADY=1` and does not implement wait states or a complete protocol assertion suite. Additional work could include robust invalid-address handling, reset checks, wait-state support, and protocol assertions.

## Skills demonstrated
Verilog RTL, APB SETUP/ACCESS concepts, memory-mapped I/O, task-based stimulus, self-checking testbenches, simulation, and waveform inspection.
