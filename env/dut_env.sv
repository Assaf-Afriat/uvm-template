//
// dut_env.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Environment for the DUT
//
class dut_env extends uvm_env;

    `uvm_component_utils(dut_env)

    dut_agent agent;
    dut_scoreboard scoreboard;
    dut_coverage coverage;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = dut_agent::type_id::create("agent", this);
        scoreboard = dut_scoreboard::type_id::create("scoreboard", this);
        coverage = dut_coverage::type_id::create("coverage", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect Monitor -> Scoreboard (2 channels)
        agent.monitor.analysis_imp.connect(scoreboard.in_fifo.analysis_export);
        agent.monitor.analysis_exp.connect(scoreboard.out_fifo.analysis_export);

        // Connect Monitor -> Coverage (both request and response)
        agent.monitor.analysis_imp.connect(coverage.dut_in_port.analysis_export);
        agent.monitor.analysis_exp.connect(coverage.dut_out_port.analysis_export);
    endfunction

endclass