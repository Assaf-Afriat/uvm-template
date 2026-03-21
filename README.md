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
├── coverage/       Functional coverage (WIP)
├── env/            UVM environment (WIP)
├── sequences/      Base sequence (WIP)
├── sva/            SVA assertions (WIP)
├── callbacks/      Callback base class (WIP)
├── test/           Base test (WIP)
└── scripts/        Compile and run scripts (WIP)
```

## Quick Start

1. Clone this repo
2. Find-replace `dut_` with your design name (e.g. `fifo_`, `uart_`)
3. Replace `dut/dut.sv` with your RTL
4. Update `interface/dut_if.sv` to match your DUT ports
5. Update the driver, monitor, and scoreboard reference model

## Status

Work in progress -- 9 of 19 implementation steps complete. See [progress.md](progress.md) for details.

## Tools

- SystemVerilog / UVM 1.2
- QuestaSim (or any UVM-compatible simulator)
