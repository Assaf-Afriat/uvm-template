//
// dut_driver.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Driver for the DUT
//

class dut_driver extends uvm_driver#(dut_item);

    `uvm_component_utils(dut_driver)

    //future callback 
    
    //configuration object
    dut_agent_config cfg;
    //virtual interface
    virtual dut_if vif;


    //constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        //get agent configuration
        if (!uvm_config_db#(dut_agent_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal("NO_CFG", "Configuration not set")
        end

        vif = cfg.vif;

        if(vif == null) begin
            `uvm_fatal("DRV_VIF", "Driver virtual interface not set")
        end
    endfunction

    task run_phase(uvm_phase phase);
        //reset signals
        vif.valid_in <= 0;
        //wait for reset
        wait(vif.rst_n === 0);
        wait(vif.rst_n === 1);

        forever begin
            bit drop = 0;

            // Get next transaction from Sequencer
            seq_item_port.get_next_item(req);

            // Pre-drive callback - can modify or drop transaction
            //`uvm_do_callbacks(dut_driver, dut_callback_base, pre_drive(this, req, drop))

            // Drive Transaction
            drive_item(req);
            
            // Post-drive callback
            //`uvm_do_callbacks(dut_driver, dut_callback_base, post_drive(this, req))

            // Signal completion
            seq_item_port.item_done();
        end
    endtask


    task drive_item(dut_item req);
        
        @ (posedge vif.clk);    // Cycle N: align to edge
        vif.valid_in <= 1;      // Assert valid + data (takes effect after this edge)
        vif.a        <= req.a;
        vif.b        <= req.b;
        
        @(posedge vif.clk);     // Cycle N+1: data was held for 1 full cycle
        vif.valid_in <= 0;
    endtask

endclass