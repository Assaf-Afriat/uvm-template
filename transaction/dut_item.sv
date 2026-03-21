//
// dut_item.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Transaction for the DUT
//

class dut_item extends uvm_sequence_item;

    // randomizable fields
    rand logic [7:0] a;
    rand logic [7:0] b;

    // output fields
    logic [8:0] result;

    // utility macros
    `uvm_object_utils_begin(dut_item)
        `uvm_field_int(a, UVM_ALL_ON)
        `uvm_field_int(b, UVM_ALL_ON)
        `uvm_field_int(result, UVM_ALL_ON)
    `uvm_object_utils_end

    //constraints
    constraint a_c {a>0;}
    constraint b_c {b>0;}


    // constructor
    function new(string name = "dut_item");
        super.new(name);
    endfunction

    // print helper
    function string convert2string();
        return $sformatf("a=%0d, b=%0d, result=%0d", a, b, result);
    endfunction

endclass

