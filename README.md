# UVM Template

A clean, reusable UVM verification template for SystemVerilog designs. Clone it, rename the `dut_` prefix, swap in your DUT, and start verifying.

## What's Inside

```
UVM-template/
├── dut/            Placeholder DUT (simple registered adder)
├── interface/      SystemVerilog interface
├── transaction/    Sequence item (dut_item)
├── config/         Agent configuration object
├── agent/          Driver, monitor, sequencer, agent wrapper
├── scoreboard/     Reference model + comparison logic
├── coverage/       Functional coverage
├── sva/            SVA assertions (bound in testbench when integrated)
├── env/            UVM environment (agent, scoreboard, coverage TLM)
├── callbacks/      Callback base class (driver, monitor, scoreboard hooks)
├── sequences/      Base sequence (not yet added)
├── test/           Base test (not yet added)
└── scripts/        Compile and run scripts (not yet added)
```

Phase 5 will add `dut_pkg.sv`, `tb_top.sv`, and `scripts/run.do` (and related integration) at the repo root.

## Quick Start

1. Clone this repo
2. Find-replace `dut_` with your design name (e.g. `fifo_`, `uart_`)
3. Replace `dut/dut.sv` with your RTL
4. Update `interface/dut_if.sv` to match your DUT ports
5. Update the driver, monitor, and scoreboard reference model

Full integration (package, top-level testbench, run script) is tracked in [progress.md](progress.md) as Phase 5.

## Status

**13 of 19** implementation steps complete. Phases 1–3 and Phase 2.5 are done; Phase 4 is half done (environment and callback base in place; base sequence and base test remain); Phase 5 (package, `tb_top`, `scripts/run.do`, README polish as a tracked step) is not started. See [progress.md](progress.md) for the step-by-step checklist.

## Tools

- SystemVerilog / UVM 1.2
- QuestaSim (or any UVM-compatible simulator)
