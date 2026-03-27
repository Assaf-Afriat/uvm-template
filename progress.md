# UVM Template — Progress Tracker

> Last updated: 2026-03-28

---

## Overall Progress: 11 / 19 steps complete

```
Phase 1   [##########] 100%  (2/2)  COMPLETE
Phase 2   [##########] 100%  (5/5)  COMPLETE
Phase 2.5 [##########] 100%  (1/1)  COMPLETE
Phase 3   [##########] 100%  (3/3)  COMPLETE
Phase 4   [----------]   0%  (0/4)
Phase 5   [----------]   0%  (0/4)
```

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

## Phase 4 — Environment and Test

| Step | File                             | Status      | Notes |
|------|----------------------------------|-------------|-------|
| 12   | `env/dut_env.sv`                 | NOT STARTED |       |
| 13   | `callbacks/dut_callback_base.sv` | NOT STARTED |       |
| 14   | `sequences/dut_base_sequence.sv` | NOT STARTED |       |
| 15   | `test/dut_base_test.sv`          | NOT STARTED |       |

## Phase 5 — Integration

| Step | File              | Status      | Notes |
|------|-------------------|-------------|-------|
| 16   | `dut_pkg.sv`      | NOT STARTED |       |
| 17   | `tb_top.sv`       | NOT STARTED |       |
| 18   | `scripts/run.do`  | NOT STARTED |       |
| 19   | `README.md`       | NOT STARTED |       |

---

## Current Open Items

None.

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

---

## What to Do Next

Phase 4 — Environment and Test. Four files:

**Step 12: `env/dut_env.sv`** — The environment ties everything together:
- Builds agent, scoreboard, coverage (use `cfg.has_checks` and `cfg.has_coverage` to conditionally build)
- `connect_phase`: wire monitor's `analysis_imp` and `analysis_exp` to scoreboard FIFOs and coverage FIFOs
- Get config from config DB and pass it down

**Step 13: `callbacks/dut_callback_base.sv`** — Virtual callback methods (pre_drive, post_drive, post_monitor)

**Step 14: `sequences/dut_base_sequence.sv`** — Base random sequence (N transactions)

**Step 15: `test/dut_base_test.sv`** — Creates config, creates env, starts sequence

---
