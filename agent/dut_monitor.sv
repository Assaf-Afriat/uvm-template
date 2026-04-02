// 
// dut_monitor.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Monitor for the DUT
//

class dut_monitor extends uvm_monitor;

    `uvm_component_utils(dut_monitor)

    //future callback 

    //configuration object
    dut_agent_config agent_cfg;
    //virtual interface
    virtual dut_if vif;

    uvm_analysis_port #(dut_item) analysis_imp; // DUT in to subscribers
    uvm_analysis_port #(dut_item) analysis_exp; // DUT out to subscribers

    function new (string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
        analysis_exp = new("analysis_exp", this);
    endfunction

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        //get agent configuration
        if(!uvm_config_db#(dut_agent_config)::get(this, "", "agent_cfg", agent_cfg)) begin
            `uvm_fatal("NO_CFG", "Configuration not set")
        end
        //get virtual interface
        vif = agent_cfg.vif;
        if(vif == null) begin
            `uvm_fatal("MON_VIF", "Monitor virtual interface not set")
        end
    endfunction

    task run_phase(uvm_phase phase);
    
        fork
            monitor_in();
            monitor_out();
        join

    endtask

    task monitor_in();
        forever begin
            @(posedge vif.clk);
            if(vif.valid_in) begin
                dut_item item = dut_item::type_id::create("item");  // create dut_item object from interface signals
                item.a = vif.a;
                item.b = vif.b;
                //future callback - post capture callback
                analysis_imp.write(item); // write to analysis port - publish once multiple subscribers 
            end
        end
    endtask

    task monitor_out(); 
        forever begin
            @(posedge vif.clk);
            if(vif.valid_out) begin
                dut_item item = dut_item::type_id::create("item");
                item.result = vif.result;
                //future callback - post capture callback
                analysis_exp.write(item); // write to analysis port - publish once multiple subscribers 
            end
        end
    endtask
endclass