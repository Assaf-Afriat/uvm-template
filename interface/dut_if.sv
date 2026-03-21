//
// dut_if.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Interface for the DUT
//

interface dut_if(input clk, input rst_n);

    // input signals 
    logic [7:0] a;
    logic [7:0] b;
    logic valid_in;

    // output signals
    logic [8:0] result;
    logic valid_out;


endinterface

