# UVM Reusable Verification Template — Implementation Plan

## Goal

Build a **simple, well-commented UVM template** inside `UVM-template/` that you can clone and adapt for any new DUT. Every file will have clear `// TODO:` markers showing what you need to customize, plus explanatory comments about *why* each UVM construct exists.

The template uses a **simple combinational adder** as the placeholder DUT — trivial enough that the focus stays on the UVM infrastructure, not the design.

---

## Directory Structure

```
UVM-template/
├── dut/
│   └── dut.sv                    # Placeholder DUT (simple adder)
├── interface/
│   └── dut_if.sv                 # SystemVerilog interface
├── transaction/
│   └── dut_item.sv               # Sequence item (transaction)
├── config/
│   └── dut_agent_config.sv       # Agent configuration object
├── agent/
│   ├── dut_sequencer.sv          # Sequencer (thin wrapper)
│   ├── dut_driver.sv             # Driver (interface stimulus)
│   ├── dut_monitor.sv            # Monitor (passive observer)
│   └── dut_agent.sv              # Agent (groups driver/monitor/sequencer)
├── scoreboard/
│   └── dut_scoreboard.sv         # Scoreboard with reference model
├── coverage/
│   └── dut_coverage.sv           # Functional coverage collector
├── env/
│   └── dut_env.sv                # Environment (top UVM container)
├── sequences/
│   └── dut_base_sequence.sv      # Base random sequence
├── sva/
│   └── dut_assertions.sv         # SVA assertions module
├── callbacks/
│   └── dut_callback_base.sv      # Callback base class (optional extension point)
├── test/
│   └── dut_base_test.sv          # Base test
├── pkg/
│   └── dut_pkg.sv                # Package (include order)
├── tb_top.sv                     # Testbench top module
├── scripts/
│   └── Run/
│       ├── run.py                # Questa driver: compile, elaborate, sim, logs
│       ├── compile.do            # vlog order: if → DUT → SVA → tb_top (includes pkg)
│       ├── elaborate.do          # vopt + vsim +UVM_TESTNAME=...
│       └── assertion_report.do   # Optional: UCDB assertion report
├── modelsim.ini                  # Optional: project overrides (copy from Questa if needed)
└── README.md                     # Usage guide and customization instructions
```

---

## File Creation Order (dependency-safe)

The order below ensures you never reference something that hasn't been defined yet. Each step is a single file to write and understand before moving on.

---

### Phase 1 — Design Under Test

- [x] **Step 1: `dut/dut.sv`** — Placeholder combinational adder
  - Ports: `clk`, `rst_n`, `a[7:0]`, `b[7:0]`, `valid_in`, `result[8:0]`, `valid_out`
  - Single-cycle: `result = a + b`, `valid_out = valid_in` (registered for clean timing)
  - Keep it dead simple so UVM is the learning focus

- [x] **Step 2: `interface/dut_if.sv`** — SV interface
  - Mirrors the DUT ports (minus `clk`/`rst_n` which are passed in)
  - Signals: `logic [7:0] a, b; logic valid_in; logic [8:0] result; logic valid_out`
  - No clocking blocks or modports (keeps it simulator-portable, matches your ALU style)

---

### Phase 2 — Transaction and Agent

- [x] **Step 3: `transaction/dut_item.sv`** — Sequence item
  - `rand bit [7:0] a, b` (inputs, randomizable)
  - `bit [8:0] result` (output, not randomized)
  - `uvm_object_utils_begin/end` with field macros
  - `convert2string()` for debug printing
  - `// TODO:` markers for adding constraints and extra fields

- [x] **Step 4: `agent/dut_sequencer.sv`** — Sequencer
  - Typedef of `uvm_sequencer#(dut_item)` — one line plus registration
  - Comment explaining why it's usually thin

- [x] **Step 5: `agent/dut_driver.sv`** — Driver
  - `build_phase`: get virtual interface from config DB
  - `run_phase`: wait for reset, then forever loop: `get_next_item` → `drive_item` → `item_done`
  - `drive_item` task: apply signals on `@(posedge clk)`, hold one cycle, deassert
  - `// TODO:` for handshake/protocol-specific driving

- [x] **Step 6: `agent/dut_monitor.sv`** — Monitor
  - Dual analysis ports (`analysis_imp` for inputs, `analysis_exp` for outputs)
  - Forked `monitor_in()` / `monitor_out()` tasks
  - `run_phase`: forever sample on posedge, capture when valid, write to analysis port
  - `// TODO:` for callbacks

- [x] **Step 7: `agent/dut_agent.sv`** — Agent wrapper
  - `is_active` field (UVM_ACTIVE / UVM_PASSIVE)
  - `build_phase`: always build monitor, conditionally build driver + sequencer
  - `connect_phase`: connect driver to sequencer when active

---

### Phase 2.5 — Agent Configuration

- [x] **Step 8: `config/dut_agent_config.sv`** — Agent config object
  - `uvm_object` with factory registration
  - Fields:
    - `virtual dut_if vif` — virtual interface handle
    - `uvm_active_passive_enum is_active = UVM_ACTIVE` — active/passive mode
    - `bit has_coverage = 1` — enable/disable coverage collector (available for future env logic)
    - `bit has_checks = 1` — enable/disable scoreboard checks (available for future env logic)
  - `// TODO:` for adding protocol-specific config fields (timeout, burst length, etc.)
  - **After creating this file, refactor these existing files to use the config object:**
    - `agent/dut_agent.sv` — get config from config DB, use `cfg.is_active` instead of `get_is_active()`, pass config to sub-components
    - `agent/dut_driver.sv` — get vif from config object (`cfg.vif`) instead of directly from config DB
    - `agent/dut_monitor.sv` — get vif from config object (`cfg.vif`) instead of directly from config DB

---

### Phase 3 — Checking and Coverage

- [x] **Step 9: `scoreboard/dut_scoreboard.sv`** — Scoreboard
  - `uvm_tlm_analysis_fifo` to receive transactions
  - Reference model: `expected = a + b` (trivial, shows the pattern)
  - Compare actual vs expected, `uvm_error` on mismatch
  - `report_phase`: print pass/fail summary
  - `// TODO:` for your own reference model logic

- [x] **Step 10: `coverage/dut_coverage.sv`** — Functional coverage
  - `uvm_analysis_imp` to receive transactions
  - Covergroup with coverpoints for `a`, `b`, `result`
  - Cross coverage `a x b`
  - `report_phase`: print coverage percentage
  - `// TODO:` for adding bins, transitions, and cross coverage

- [x] **Step 11: `sva/dut_assertions.sv`** — SVA assertions module
  - Basic protocol assertions: `valid_out` only when `valid_in` was asserted, output stable during valid
  - Pass/fail counters
  - `// TODO:` for protocol-specific assertions

---

### Phase 4 — Environment and Test

- [x] **Step 12: `env/dut_env.sv`** — Environment
  - Builds agent, scoreboard, coverage (always instantiated in this template)
  - **`dut_agent_config`** includes `has_coverage` / `has_checks`; the template does **not** yet use them to skip scoreboard/coverage — optional extension
  - `connect_phase`: monitor analysis ports → scoreboard/coverage **`uvm_tlm_analysis_fifo`** ports via **`.analysis_export`** (required for UVM 1.1d / `mtiUvm` TLM wiring)

- [x] **Step 13: `callbacks/dut_callback_base.sv`** — Callback base
  - Virtual methods: `pre_drive`, `post_drive`, `post_monitor`
  - All empty by default — extension points for tests
  - Comment explaining the callback pattern

- [x] **Step 14: `sequences/dut_base_sequence.sv`** — Base sequence
  - Sends N random transactions (`num_items` configurable, default 20)
  - Template uses **explicit** `start_item` / `randomize` / `finish_item` (with optional `uvm_do` noted in comments)
  - `// TODO:` for constrained-random and directed sequences

- [x] **Step 15: `test/dut_base_test.sv`** — Base test
  - Creates `dut_agent_config` object, sets fields, puts in config DB
  - Creates environment in `build_phase`
  - Starts base sequence in `run_phase` with objection raise/drop
  - `report_phase`: summary banner
  - `// TODO:` for creating derived tests

---

### Phase 5 — Integration

- [x] **Step 16: `pkg/dut_pkg.sv`** — Package file
  - `import uvm_pkg::*`, include macros (`uvm_macros.svh`)
  - Includes UVM classes only, in dependency order: **transaction → callback base → config → agent → scoreboard → coverage → env → sequences → tests**
  - **`interface/dut_if.sv` is NOT included here** — the interface is a separate compile unit; **`compile.do`** runs **`vlog interface/dut_if.sv`** before **`tb_top.sv`** so `virtual dut_if` in config/agent classes resolves. Do not put the interface inside the package.
  - Config must be included **before** agent components (they depend on it)

- [x] **Step 17: `tb_top.sv`** — Testbench top
  - `` `include "uvm_macros.svh" `` then `` `include "dut_pkg.sv" `` (single compile of TB; package not compiled separately)
  - `import uvm_pkg::*; import dut_pkg::*;` inside the module
  - Clock generation (10ns period)
  - Reset generation
  - Interface instantiation
  - DUT instantiation connected to interface
  - SVA assertions instantiation
  - `uvm_config_db::set` for virtual interface
  - `run_test("dut_base_test")`
  - VCD dump
  - No backpressure logic (keep template simple; add as TODO)

- [x] **Step 18: `scripts/Run/`** — QuestaSim compile and run
  - **`run.py`**: invokes ModelSim/Questa with project root, `UVM_MACROS_PATH` pointing to **`uvm-1.1d/src`** (match built-in `mtiUvm`), `compile.do` → `elaborate.do`, logs under `logs/`, build under `sim/`
  - **`compile.do`**: `vlog` interface → DUT → SVA → **`tb_top.sv`** with `+incdir+` for sources and UVM macro directory
  - **`elaborate.do`**: `vopt`, `vsim` with `+UVM_TESTNAME=dut_base_test` (and typical UVM defines)
  - Optional **`assertion_report.do`** for UCDB assertion reporting (path aligned with test/UCDB name)
  - Vivado flow not included (Questa-only template)

- [x] **Step 19: `README.md`** — Documentation
  - What this template is
  - Directory map with one-line descriptions
  - How to customize (step-by-step: rename prefix, swap DUT, update interface, modify ref model)
  - How to compile and run
  - Checklist for adapting to a new project
  - **Note:** keep README in sync with `scripts/Run/`, Questa UVM **1.1d** vs generic “1.2”, and `pkg/dut_pkg.sv` layout

---

## Design Ideas and Suggestions

- **Naming convention**: All files use `dut_` prefix. When you clone for a real design, do a global find-replace of `dut_` with your design name (e.g., `fifo_`, `uart_`, `arbiter_`).
- **Inline `// TODO:` markers**: Every customization point gets a `// TODO: [description]` so you can grep for them: `grep -rn "TODO" .`
- **Keep callbacks optional**: The callback base is included but the driver/monitor don't use callbacks by default — you can add them later as you did in the ALU project.
- **Dual analysis ports**: The monitor uses `analysis_imp` (inputs) and `analysis_exp` (outputs) for independent observation of request and response paths.
- **Agent config object**: Centralizes all agent-level settings (active/passive, coverage enable, vif) into one object passed through config DB. The test controls everything from the top.
- **No field macros debate**: Template uses `uvm_field_*` macros (like your ALU project) but includes a comment noting the performance trade-off and the manual `do_compare`/`do_copy` alternative.

---

## Key Patterns Carried Over from ALU Project

- Factory registration (`type_id::create`)
- Config DB for virtual interface
- Analysis ports + TLM FIFOs
- Phase methods (`build_phase`, `connect_phase`, `run_phase`, `report_phase`)
- Clean include order in package
- Section separator comments (`// ========`)
- `convert2string()` in transaction items
- Active/passive agent configuration
- Agent config object (new addition — best practice for reusable agents)
- **`scripts/Run/run.py`** driver matching ALU-style Questa flow

---

## Quick Reference: UVM Testbench Architecture

```
                    ┌─────────────────────────────────────────┐
                    │            dut_base_test                │
                    │  (creates config, raises objection,     │
                    │   starts sequence)                      │
                    └──────────────┬──────────────────────────┘
                                   │ config DB
                    ┌──────────────▼──────────────────────────┐
                    │             dut_env                     │
                    │                                         │
                    │  ┌─────────────────────────────────┐    │
                    │  │          dut_agent              │    │
                    │  │     (reads dut_agent_config)    │    │
                    │  │                                 │    │
                    │  │  ┌───────────┐ ┌───────────┐    │    │
                    │  │  │  driver   │ │  monitor  │    │    │
                    │  │  │ (cfg.vif) │ │ (cfg.vif) │    │    │
                    │  │  │           │ │           │    │    │
                    │  │  │ gets txns │ │ observes  │    │    │
                    │  │  │ from seqr │ │ DUT pins  │    │    │
                    │  │  └─────┬─────┘ └──┬────┬───┘    │    │
                    │  │        │          │    │        │    │
                    │  │  ┌─────▼─────┐    │    │        │    │
                    │  │  │ sequencer │    │    │        │    │
                    │  │  └───────────┘    │    │        │    │
                    │  └───────────────────┼────┼────────┘    │
                    │                      │    │             │
                    │              in_port │    │ out_port    │
                    │                      │    │             │
                    │  ┌──────────────┐  ┌─▼────▼──────────┐  │
                    │  │  scoreboard  │  │   coverage      │  │
                    │  │  (ref model) │  │   (groups)      │  │
                    │  └──────────────┘  └─────────────────┘  │
                    │  (cfg.has_checks / has_coverage reserved) │
                    └───────────────────────────────────────────┘
                                   │
                          ┌────────▼────────┐
                          │    tb_top.sv    │
                          │  clk, rst, if   │
                          │  DUT instance   │
                          │  SVA instance   │
                          └─────────────────┘
```

---

Good luck — check off each step as you go. When you're stuck or done, come back and we'll review it together.
