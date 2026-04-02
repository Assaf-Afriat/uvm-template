//
// dut_base_test.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Base test for the DUT
//
class dut_base_test extends uvm_test;
    `uvm_component_utils(dut_base_test)

    dut_env env;
    dut_agent_config agent_cfg;
    virtual dut_if vif;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        agent_cfg = dut_agent_config::type_id::create("agent_cfg", this);
        agent_cfg.is_active = UVM_ACTIVE;
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("TEST", "virtual dut_if not found in config DB (set vif from tb_top)")
        end
        agent_cfg.vif = vif;
        uvm_config_db#(dut_agent_config)::set(this, "*", "agent_cfg", agent_cfg);
        env = dut_env::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        // Print topology
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        dut_base_sequence seq;

        phase.raise_objection(this);
        seq = dut_base_sequence::type_id::create("seq");
        
        `uvm_info("TEST", "Starting Sequence", UVM_LOW)
        seq.start(env.agent.sequencer);
        `uvm_info("TEST", "Sequence Complete", UVM_LOW)

        // Drain time for pending responses
        #100ns;

        phase.drop_objection(this);
    endtask

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("TEST", "Test Complete", UVM_LOW)
    endfunction
endclass
