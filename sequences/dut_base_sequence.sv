//
// dut_base_sequence.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Base sequence for the DUT
//
class dut_base_sequence extends uvm_sequence#(dut_item);
    `uvm_object_utils(dut_base_sequence)

    // Number of items to generate
    int num_items = 50;

    // Constructor
    function new(string name = "dut_base_sequence");
        super.new(name);
    endfunction

    // Body task
    task body();
        dut_item item;

        `uvm_info("SEQ", $sformatf("Starting Base Sequence with %0d items", num_items), UVM_LOW)

        // Generate the items   
        repeat(num_items) begin

            // Create the item --- optioanl - `uvm_do(item)
            item = dut_item::type_id::create("item");
            start_item(item);
            if(!item.randomize()) `uvm_error("SEQ", "Randomization failed")
            finish_item(item);

        end

        `uvm_info("SEQ", $sformatf("Base Sequence Finished with %0d items", num_items), UVM_LOW)

    endtask
endclass