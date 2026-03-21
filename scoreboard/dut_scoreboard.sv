//
// dut_scoreboard.sv
// Assaf Afriat
// 2026-03-21
//description:
//This file contains the scoreboard for the DUT.
//The scoreboard is responsible for comparing the expected and actual results of the DUT.


class dut_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(dut_scoreboard)

    //future callbacks

    //analysis exports from monitor in/out 
    uvm_tlm_analysis_fifo #(dut_item) in_fifo;
    uvm_tlm_analysis_fifo #(dut_item) out_fifo;

    //statistics
    int unsigned pass_count;
    int unsigned fail_count;
    int unsigned total_count;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //create analysis ports
        in_fifo = new("in_fifo", this);
        out_fifo = new("out_fifo", this);

        //initialize statistics
        pass_count = 0;
        fail_count = 0;
        total_count = 0;      
    endfunction

    //connect phase - connect analysis ports - no need to connect in this case

    task run_phase(uvm_phase phase);
    
        dut_item dut_in;
        dut_item dut_out;
        logic [8:0] expected_result;

        forever begin
            //get input from monitor
            in_fifo.get(dut_in);

            //compute expected result from input (reference model)
            expected_result = dut_in.a + dut_in.b;

            //get actual result from monitor
            out_fifo.get(dut_out);

            //increment transaction count
            total_count++;

            //print transaction details
            $display("============================================================");
            $display("  Transaction #%0d", total_count);
            $display("============================================================");
            $display("  OPERANDS (from Monitor/Bus):");
            $display("    Operand A : %0d (0x%02h)", dut_in.a, dut_in.a);
            $display("    Operand B : %0d (0x%02h)", dut_in.b, dut_in.b);
            $display("------------------------------------------------------------");
            $display("  RESULTS:");
            $display("    Expected  : %0d (0x%02h)", expected_result, expected_result);
            $display("    Actual    : %0d (0x%02h)", dut_out.result, dut_out.result);
            $display("------------------------------------------------------------");

            //compare expected and actual results
            if (dut_out.result == expected_result) begin
                pass_count++;
                $display("  STATUS: PASS:");
                `uvm_info("SCB_PASS", $sformatf("a=%0d, b=%0d => Result: %0d (Expected: %0d)", dut_in.a, dut_in.b, dut_out.result, expected_result), UVM_MEDIUM)
            end else begin
                fail_count++;
                $display("  STATUS: *** MISMATCH ***");
                `uvm_error("SCB_FAIL", $sformatf("a=%0d, b=%0d => Result: %0d (Expected: %0d)", dut_in.a, dut_in.b, dut_out.result, expected_result))
            end
            $display("============================================================\n");     
        end
    endtask

    //report phase - print summary
    function void report_phase(uvm_phase phase);
    
        super.report_phase(phase);

        $display("");
        $display("############################################################");
        $display("                   SCOREBOARD SUMMARY                       ");
        $display("############################################################");
        $display("  Total Transactions : %0d", total_count);
        $display("  Passed             : %0d", pass_count);
        $display("  Failed             : %0d", fail_count);
        $display("############################################################");
        $display("");

        if (fail_count > 0) begin
            `uvm_error("SCB_REPORT", $sformatf("TEST FAILED with %0d errors!", fail_count))
        end else if (total_count > 0) begin
            `uvm_info("SCB_REPORT", "TEST PASSED - All transactions matched!", UVM_NONE)
        end else begin
            `uvm_warning("SCB_REPORT", "No transactions were checked!")
        end
    endfunction

endclass