# UVM Template

A minimal UVM testbench for SystemVerilog: registered-adder placeholder DUT, agent, scoreboard, coverage, SVA, and Questa run flow. Use it as a starting point—rename the `dut_` prefix, swap RTL and ports, and extend sequences and tests.

## Project demo

The walkthrough (spec, testbench diagram, captured results, run commands) is in **`deliverables/uvm_template_project_demo.html`**. Open that file in a browser to review architecture and outcomes without running the simulator. To publish it on GitHub Pages, point the site at the `deliverables/` folder or copy the HTML into `docs/` as your hosting workflow requires.

## Requirements

- QuestaSim (or another simulator that supports UVM with a similar compile/elaborate flow; this repo is tested with Questa).
- Python 3.x on `PATH` (for `scripts/Run/run.py`).
- In `scripts/Run/run.py`, set **`UVM_MACROS_PATH`** to your install’s UVM `src` directory if the default path does not match your machine.

## Build / run

From the repo root, all commands go through **`scripts/Run/`**:

```text
cd scripts/Run
python run.py
python run.py --test dut_base_test
python run.py --gui
python run.py --clean
python run.py --help
```

`compile.do` and `elaborate.do` are invoked by the script; default test is **`dut_base_test`**. See `implementation_plan.md` for how the phases map to files.

## Using this template

1. **Clone** the repo and open it in your editor.
2. **Rename** the `dut_` prefix across filenames and types (e.g. `fifo_`, `uart_`) with a project-wide find-and-replace; keep package and compile order consistent (`pkg/dut_pkg.sv`, `tb_top.sv`, `compile.do`).
3. **Replace** `dut/dut.sv` with your RTL and **`interface/dut_if.sv`** with your ports.
4. **Adjust** driver, monitor, scoreboard, and coverage to match your protocol and checks.
5. **Run** from `scripts/Run/` as above; keep `logs/` and `sim/` out of version control (see `.gitignore`).

The package pulls in UVM classes only; the interface is compiled separately before the top module (see `compile.do`).

## Repository layout

| Path | Role |
|------|------|
| `dut/` | RTL placeholder |
| `interface/` | `dut_if` and signals |
| `transaction/` | `dut_item` |
| `config/` | Agent config (`vif`, etc.) |
| `agent/` | Driver, monitor, sequencer, agent |
| `scoreboard/` | Reference model and comparison |
| `coverage/` | Functional coverage |
| `sva/` | Assertions bound in `tb_top.sv` |
| `env/` | UVM environment wiring |
| `callbacks/` | Callback base class |
| `sequences/` | `dut_base_sequence` |
| `test/` | `dut_base_test` |
| `pkg/` | `dut_pkg.sv` (classes only) |
| `tb_top.sv` | Top-level testbench |
| `scripts/Run/` | `run.py`, `compile.do`, `elaborate.do`, `run.do`, assertion/UCDB helpers |
| `deliverables/` | Static project demo HTML |
| `implementation_plan.md` | Phased build plan and checklist |
