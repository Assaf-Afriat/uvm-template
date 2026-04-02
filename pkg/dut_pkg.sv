//
// dut_pkg.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Package for the DUT
//
package dut_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Transaction Item (must be first)
    `include "transaction/dut_item.sv"

    // Callback Base (before components that use it)
    `include "callbacks/dut_callback_base.sv"

    // Configuration Components
    `include "config/dut_agent_config.sv"

    // Agent Components
    `include "agent/dut_sequencer.sv"
    `include "agent/dut_driver.sv"
    `include "agent/dut_monitor.sv"
    `include "agent/dut_agent.sv"

    // Environment Components
    `include "scoreboard/dut_scoreboard.sv"
    `include "coverage/dut_coverage.sv"
    `include "env/dut_env.sv"

    // placeholder for future Callback Implementations (after components)

    // Sequences
    `include "sequences/dut_base_sequence.sv"

    // Tests
    `include "test/dut_base_test.sv"

endpackage
