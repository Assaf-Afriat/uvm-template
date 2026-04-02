//
// tb_top.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Top module for the DUT
//
`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "dut_pkg.sv"

module tb_top;
    import uvm_pkg::*;
    import dut_pkg::*;

    logic clk;
    logic rst_n;

    dut_if vif(.clk(clk), .rst_n(rst_n));
    
    dut dut_inst(
        .clk(clk),
        .rst_n(rst_n),
        //inputs
        .a(vif.a),
        .b(vif.b),
        .valid_in(vif.valid_in),
        //outputs
        .result(vif.result),
        .valid_out(vif.valid_out)
    );

    dut_assertions dut_assertions_inst(
        .clk(clk),
        .rst_n(rst_n),
        .a(vif.a),
        .b(vif.b),
        .valid_in(vif.valid_in),
        .result(vif.result),
        .valid_out(vif.valid_out)
    );

    
    //clk generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    //reset generation
    initial begin
        rst_n = 0;
        #20ns;
        rst_n = 1;
    end

    //UVM Start
    initial begin
        // Set Virtual Interface in Config DB
        uvm_config_db#(virtual dut_if)::set(null, "*", "vif", vif);
    
        // Run Test
        run_test("dut_base_test");
    end

    // Dump Waves (Optional - for VCD format)
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);
    end

    //TODO - Add backpressure statistics
endmodule



