# UVM Template — Progress Tracker

> Last updated: 2026-04-02

---

## Overall Progress: 19 / 19 steps complete

```
Phase 1   [##########] 100%  (2/2)  COMPLETE
Phase 2   [##########] 100%  (5/5)  COMPLETE
Phase 2.5 [##########] 100%  (1/1)  COMPLETE
Phase 3   [##########] 100%  (3/3)  COMPLETE
Phase 4   [##########] 100%  (4/4)  COMPLETE
Phase 5   [##########] 100%  (4/4)  COMPLETE
```

Simulation (Questa): **passing** — compile, elaborate, `dut_base_test`, assertions/UCDB flow verified.

---

## Phase 1 — Design Under Test -- COMPLETE

| Step | File                   | Status | Notes     |
|------|------------------------|--------|-----------|
| 1    | `dut/dut.sv`           | DONE   | No issues |
| 2    | `interface/dut_if.sv`  | DONE   | No issues |

## Phase 2 — Transaction and Agent -- COMPLETE

| Step | File                      | Status | Notes                  |
|------|---------------------------|--------|------------------------|
| 3    | `transaction/dut_item.sv` | DONE   | No issues              |
| 4    | `agent/dut_sequencer.sv`  | DONE   | No issues              |
| 5    | `agent/dut_driver.sv`     | DONE   | Refactored to use config |
| 6    | `agent/dut_monitor.sv`    | DONE   | Refactored to use config |
| 7    | `agent/dut_agent.sv`      | DONE   | Refactored to use config |

## Phase 2.5 — Agent Configuration -- COMPLETE

| Step | File                          | Status | Notes     |
|------|-------------------------------|--------|-----------|
| 8    | `config/dut_agent_config.sv`  | DONE   | No issues |

## Phase 3 — Checking and Coverage -- COMPLETE

| Step | File                            | Status | Notes     |
|------|---------------------------------|--------|-----------|
| 9    | `scoreboard/dut_scoreboard.sv`  | DONE   | No issues |
| 10   | `coverage/dut_coverage.sv`      | DONE   | No issues |
| 11   | `sva/dut_assertions.sv`         | DONE   | No issues |

## Phase 4 — Environment and Test -- COMPLETE

| Step | File                             | Status      | Notes |
|------|----------------------------------|-------------|-------|
| 12   | `env/dut_env.sv`                 | DONE        | `super.connect_phase`; monitor → scoreboard/coverage via FIFO **`analysis_export`** (UVM 1.1d TLM) |
| 13   | `callbacks/dut_callback_base.sv` | DONE        | Validated; added explicit `new()` |
| 14   | `sequences/dut_base_sequence.sv` | DONE        | Explicit create + `start_item`/`finish_item`; `uvm_do` optional — see **Project decisions** |
| 15   | `test/dut_base_test.sv`          | DONE        | `get` `vif` from DB → `agent_cfg.vif` → `set` `agent_cfg` → `create` env; sequence + objections; `report_phase` |

## Phase 5 — Integration -- COMPLETE

| Step | File              | Status | Notes |
|------|-------------------|--------|-------|
| 16   | `pkg/dut_pkg.sv`  | DONE   | `uvm` import + macros; includes: item → callback → config → agent → sb/cov/env → sequence → test — **`interface/dut_if.sv` is not in the package** (compiled separately; see Step 18) |
| 17   | `tb_top.sv`       | DONE   | `` `include "uvm_macros.svh" `` + `` `include "dut_pkg.sv" ``; clk/rst, DUT, `dut_if`, `dut_assertions`, `config_db` `vif`, `run_test`, optional VCD |
| 18   | `scripts/Run/`    | DONE   | **`python run.py`** (Questa): `compile.do` / `elaborate.do` — interface → DUT → SVA → **`tb_top.sv`** only; built-in **`uvm_pkg`**; **`+incdir+`** must match Questa’s UVM (**`uvm-1.1d/src`** for `mtiUvm` + `uvm_macros.svh`); `logs/`, `sim/`; optional **`assertion_report.do`** on UCDB |
| 19   | `README.md`       | DONE   | Usage guide present; **optional polish:** point to `scripts/Run/run.py`, Questa **1.1d** macros path, and current tree (`pkg/`, `sequences/`, `test/`) — see **Documentation follow-up** |

---

## Current Open Items

None for RTL/TB/simulation.

---

## Documentation follow-up (optional)

| Item | Action |
|------|--------|
| `README.md` | Refresh directory tree, “Quick Start”, and tool versions to match `scripts/Run/`, `python run.py`, and UVM **1.1d** (Questa `mtiUvm`) vs generic “UVM 1.2”. |

---

## Resolved Issues Log

| # | File | Issue | Resolution |
|---|------|-------|------------|
| 1 | `dut_item.sv` | `conver2string` typo | FIXED |
| 2 | `dut_item.sv` | Redundant `result` constraint | FIXED (removed) |
| 3 | `dut_item.sv` | Redundant `a`/`b` constraints | FIXED (now `> 0`) |
| 4 | `dut_if.sv` | `inputsignals` missing space | FIXED |
| 5 | `dut_driver.sv` | `virutal` typo | FIXED |
| 6 | `dut_driver.sv` | `vif.req_valid` wrong signal | FIXED |
| 7 | `dut_driver.sv` | Callback refs before class exists | FIXED (commented out) |
| 8 | `dut_driver.sv` | `drive_item` waited on `valid_out` | FIXED (two-edge pattern) |
| 9 | `dut_monitor.sv` | `super.mew` typo | FIXED |
| 10 | `dut_monitor.sv` | Missing comma in config_db::get | FIXED |
| 11 | `dut_monitor.sv` | Missing semicolons after `@(posedge)` | FIXED |
| 12 | `dut_agent.sv` | `type_it` typo (should be `type_id`) | FIXED |
| 13 | `dut_agent.sv` | `"sequncer"` instance name typo | FIXED |
| 14 | `dut_agent.sv` | `sequncer` variable typo in connect_phase | FIXED |
| 15 | `dut_agent_config.sv` | `extentds` typo (should be `extends`) | FIXED |
| 16 | `dut_scoreboard.sv` | `uvm_analysis_port` should be `uvm_tlm_analysis_fifo` | FIXED |
| 17 | `dut_scoreboard.sv` | `connect_phase` connected port to itself | FIXED (removed) |
| 18 | `dut_scoreboard.sv` | `op1`/`op2` should be `a`/`b` | FIXED |
| 19 | `dut_scoreboard.sv` | `uvm_info` used for mismatch instead of `uvm_error` | FIXED |
| 20 | `dut_scoreboard.sv` | `uvm_error` given 3 args (only takes 2) | FIXED |
| 21 | `dut_coverage.sv` | `uvm_subscriber` doesn't support dual ports | FIXED (use `uvm_component`) |
| 22 | `dut_coverage.sv` | `uvm_analysis_export` has no `get()` | FIXED (use `uvm_tlm_analysis_fifo`) |
| 23 | `dut_coverage.sv` | Bin ranges out of range / inverted | FIXED |
| 24 | `dut_coverage.sv` | Cross of covergroups instead of coverpoints | FIXED |
| 25 | `dut_coverage.sv` | `run_phase` declared as function | FIXED (now task) |
| 26 | `dut_coverage.sv` | Tasks nested inside function | FIXED (separate methods) |
| 27 | `dut_coverage.sv` | Wrong variable names (`dut_item_in`/`dut_item_out`) | FIXED |
| 28 | `dut_coverage.sv` | Covergroup `new()` with wrong args | FIXED |
| 29 | `dut_coverage.sv` | `result` sampled before output captured | FIXED |
| 30 | `dut_coverage.sv` | Missing semicolon after `new()` | FIXED |
| 31 | `dut_assertions.sv` | Duplicate properties (`p_result_stable`, `p_result_valid`) | FIXED (removed) |
| 32 | `dut_assertions.sv` | Undeclared counter variables | FIXED |
| 33 | `dut_assertions.sv` | Assertions didn't match DUT behavior (handshake vs registered) | FIXED (rewritten) |
| 34 | `dut_env.sv` | Missing `super.connect_phase(phase)` call | FIXED |
| 35 | `dut_callback_base.sv` | Missing explicit `new()` constructor | FIXED |
| 36 | `dut_base_test.sv` | Undefined `print_report()` in `report_phase` | FIXED (removed; `uvm_info` only) |
| 37 | `dut_pkg.sv` | Wrong `` `include`` path for `dut_item` (`agent/` vs `transaction/`) | FIXED |
| 38 | `dut_base_test.sv` / `tb_top` | `config_db`: wrong `get` type for `vif`; missing `agent_cfg` `set` | FIXED (`virtual dut_if` `get`, assign `agent_cfg.vif`, then `set` `agent_cfg`) |
| 39 | `dut_env.sv` | TLM `connect` to FIFO object (vsim-8754 / vsim-12460) | FIXED — connect to **`in_fifo` / `out_fifo` / `dut_in_port` / `dut_out_port` `.analysis_export`** |
| 40 | Compile / UVM | `uvm_macros.svh` / macro–library mismatch | FIXED — **`+incdir+`** to Questa **`verilog_src/uvm-1.1d/src`** (matches built-in **`mtiUvm`**) |
| 41 | `scripts/Run/` | Single entry: ALU-style **`run.py`** + **`compile.do`** / **`elaborate.do`** | DONE — Questa-only; paths under repo / `UVM_MACROS_PATH` |

---

## Project decisions (not bugs)

| Topic | Choice |
|-------|--------|
| Base sequence (Step 14) | **Explicit** item creation and `start_item` / `randomize` / `finish_item` in `body()`; `` `uvm_do(item) `` kept as an optional shorthand (comment in source). Differs from implementation_plan Step 14, which suggested defaulting to `` `uvm_do``. |
| Package location | Implementation plan originally showed `dut_pkg.sv` at repo root; repo uses **`pkg/dut_pkg.sv`**. |
| Interface vs package | **`dut_if.sv`** is **not** `` `include``d in **`dut_pkg.sv`**. Interfaces belong in their own compile unit; **`compile.do`** **`vlog`s `interface/dut_if.sv` first**, then TB, so classes in the package can use **`virtual dut_if`** without putting the interface inside the package. |
| Virtual interface | **`tb_top`** `set`s `vif` globally; **`dut_base_test`** `get`s `virtual dut_if`, assigns **`agent_cfg.vif`**, then **`set`s `agent_cfg`** before **`env`** build. |
| Environment (Step 12) | **`dut_env`** always builds agent, scoreboard, and coverage. **`dut_agent_config`** has `has_coverage` / `has_checks` for future use; they are **not** used to trim the env in the current template. |
| Questa integration | **`scripts/Run/run.py`** + **`compile.do`** / **`elaborate.do`**; **`tb_top.sv`** is the only testbench compile unit and **includes** `dut_pkg.sv`. Built-in **`uvm_pkg`**; macro include dir **1.1d** aligned with **`mtiUvm`**. Optional root **`modelsim.ini`** for project overrides. |
| `--clean` in `run.py` | Cleans **`sim/`** and **`logs/`** only; does **not** remove RTL/TB sources under **`coverage/`**. |

---

## What to Do Next

Optional: refresh **`README.md`** so the directory map, run instructions, and tool versions match **`scripts/Run/`**, **`python run.py`**, and Questa UVM **1.1d** (see **Documentation follow-up**).

---
