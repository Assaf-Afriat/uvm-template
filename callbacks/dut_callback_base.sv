//
// dut_callback_base.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Base callback for the DUT
//
class dut_callback_base extends uvm_callback;
    `uvm_object_utils(dut_callback_base)

    function new(string name = "dut_callback_base");
        super.new(name);
    endfunction

    //driver callbacks
    // Called before driving a transaction to the DUT
    // Can modify the transaction or skip it entirely
    virtual function void pre_drive(uvm_component drv, dut_item item, ref bit drop);
    endfunction

    // Called after driving a transaction to the DUT
    virtual function void post_drive(uvm_component drv, dut_item item);
    endfunction

    //monitor callbacks
    // Called after capturing a request transaction
    virtual function void post_req_capture(uvm_component mon, dut_item item, ref bit drop);
    endfunction

    // Called after capturing a response transaction
    virtual function void post_resp_capture(uvm_component mon, dut_item item, ref bit drop);
    endfunction

    //scoreboard callbacks
    // Called before comparing expected vs actual
    virtual function void pre_compare(uvm_component scb, dut_item req, dut_item resp, 
                                       ref logic [8:0] expected_result);
    endfunction

    // Called after comparison (with result)
    virtual function void post_compare(uvm_component scb, dut_item req, dut_item resp,
                                        logic [8:0] expected_result, bit passed);
    endfunction

endclass    