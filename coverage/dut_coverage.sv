//
// dut_coverage.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: Coverage for the DUT
//
class dut_coverage extends uvm_component;

    `uvm_component_utils(dut_coverage)

    //analysis port
    uvm_tlm_analysis_fifo #(dut_item) dut_in_port;
    uvm_tlm_analysis_fifo #(dut_item) dut_out_port;

    dut_item dut_in_item;
    dut_item dut_out_item;

    //covergroup
    covergroup operand_a;
        option.per_instance = 1;
        option.name = "operand_a";
        cp_operand_a: coverpoint dut_in_item.a {
            bins zero = {0};
            bins one = {1};
            bins low[16] = {[2:15]};
            bins mid_low[16] = {[16:127]};
            bins mid_high[16] = {[128:240]};
            bins high[14] = {[241:254]};
            bins max = {255};
        }
    endgroup
    covergroup operand_b;
        option.per_instance = 1;
        option.name = "operand_b";
        cp_operand_b: coverpoint dut_in_item.b {
            bins zero = {0};
            bins one = {1};
            bins low[16] = {[2:15]};
            bins mid_low[16] = {[16:127]};
            bins mid_high[16] = {[128:240]};
            bins high[14] = {[241:254]};
            bins max = {255};
        }
    endgroup
    covergroup result;
        option.per_instance = 1;
        option.name = "result";
        cp_result: coverpoint dut_out_item.result {
            bins zero = {0};
            bins one = {1};
            bins low[16] = {[2:15]};
            bins mid_low[16] = {[16:255]};
            bins mid_high[16] = {[256:490]};
            bins high[10] = {[491:510]};
            bins max = {511};
        }
    endgroup

    covergroup full_cross;
        option.per_instance = 1;
        option.name = "full_cross";

        cp_operand_a_range: coverpoint dut_in_item.a {
            bins low  = {[8'h00:8'h3F]};
            bins mid  = {[8'h40:8'hBF]};
            bins high = {[8'hC0:8'hFF]};
        }

        cp_operand_b_range: coverpoint dut_in_item.b {
            bins low  = {[8'h00:8'h3F]};
            bins mid  = {[8'h40:8'hBF]};
            bins high = {[8'hC0:8'hFF]};
        }

        cx_full: cross cp_operand_a_range, cp_operand_b_range;
    endgroup

    //constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        operand_a = new();
        operand_b = new();
        result = new();
        full_cross = new();
    endfunction

    //build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        dut_in_port = new("dut_in_port", this);
        dut_out_port = new("dut_out_port", this);
    endfunction

    //connect phase - not needed in this case

    //run phase
    task run_phase(uvm_phase phase);
        fork
            sample_dut_in();
            sample_dut_out();
        join
    endtask

    task sample_dut_in();
        forever begin
            dut_in_port.get(dut_in_item);
            operand_a.sample();
            operand_b.sample();
            full_cross.sample();
        end
    endtask

    task sample_dut_out();
        forever begin
            dut_out_port.get(dut_out_item);
            result.sample();
        end
    endtask


    //report phase
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("############################################################");
        $display("              FUNCTIONAL COVERAGE REPORT                    ");
        $display("############################################################");
        $display("Operand A Coverage: %0.2f%%", operand_a.get_coverage());
        $display("Operand B Coverage: %0.2f%%", operand_b.get_coverage());
        $display("Result Coverage: %0.2f%%", result.get_coverage());
        $display("Full Cross Coverage: %0.2f%%", full_cross.get_coverage());
        $display("############################################################");
    endfunction
endclass