// 
// dut_sequencer.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Sequencer for the DUT
//

class dut_sequencer extends uvm_sequencer#(dut_item);

    `uvm_component_utils(dut_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass