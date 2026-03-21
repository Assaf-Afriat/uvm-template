# UVM Template — Progress Tracker

> Last updated: 2026-03-21

---

## Overall Progress: 9 / 19 steps complete

```
Phase 1   [##########] 100%  (2/2)  COMPLETE
Phase 2   [##########] 100%  (5/5)  COMPLETE
Phase 2.5 [##########] 100%  (1/1)  COMPLETE
Phase 3   [###-------]  33%  (1/3)
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

## Phase 3 — Checking and Coverage

| Step | File                            | Status      | Notes     |
|------|---------------------------------|-------------|-----------|
| 9    | `scoreboard/dut_scoreboard.sv`  | DONE        | No issues |
| 10   | `coverage/dut_coverage.sv`      | NOT STARTED |           |
| 11   | `sva/dut_assertions.sv`         | NOT STARTED |           |

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

---

## What to Do Next

**Step 10: `coverage/dut_coverage.sv`** — Functional coverage collector:
- Subscribes to the monitor's input analysis port
- Covergroup with coverpoints for `a`, `b`, `result`
- Cross coverage `a x b`
- `report_phase`: print coverage percentage
- `// TODO:` for adding bins, transitions, and custom cross coverage

---
