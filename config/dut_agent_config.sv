//
// dut_agent_config.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Configuration for the DUT agent
//

//agent config is an object - used to configure the agent
class dut_agent_config extends uvm_object;
    `uvm_object_utils(dut_agent_config);

    //virtual interface
    virtual dut_if vif;
    //defines if the agent is active or passive
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    //defines if the agent has coverage
    bit has_coverage = 1;
    //defines if the agent has checks
    bit has_checks =   1;

    //constructor
    function new(string name = "dut_agent_config");
        super.new(name);
    endfunction
endclass