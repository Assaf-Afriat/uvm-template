//
// dut_agent.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Agent for the DUT
//

class dut_agent extends uvm_agent;

    `uvm_component_utils(dut_agent);

    dut_monitor monitor;
    dut_driver driver;
    dut_sequencer sequencer;
    //configuration object
    dut_agent_config agent_cfg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(dut_agent_config)::get(this, "", "agent_cfg", agent_cfg)) begin
            `uvm_fatal("NO_CFG", "Configuration not set")
        end

        monitor = dut_monitor::type_id::create("monitor", this);

        //only build driver/sequencer if active
        if(agent_cfg.is_active == UVM_ACTIVE) begin
            driver = dut_driver::type_id::create("driver", this);
            sequencer = dut_sequencer::type_id::create("sequencer", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        if(agent_cfg.is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass