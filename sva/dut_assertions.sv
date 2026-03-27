//
// DUT Assertions
// Assaf Afriat
// 28/03/2026
// description:
// This file contains the assertions for the DUT.
//

module dut_assertions (

    input logic clk,
    input logic rst_n,

    // Request Interface
    input logic [7:0] a,
    input logic [7:0] b,
    input logic valid_in,

    // Response Interface
    input logic [8:0] result,
    input logic valid_out

);

    // Global counters
    int unsigned assert_pass_count = 0;
    int unsigned assert_fail_count = 0;

    // Per-assertion counters
    int unsigned valid_out_follows_pass = 0, valid_out_follows_fail = 0;
    int unsigned no_valid_in_pass = 0, no_valid_in_fail = 0;
    int unsigned result_correct_pass = 0, result_correct_fail = 0;
    int unsigned reset_clears_pass = 0, reset_clears_fail = 0;

    // ========================================================================
    // ASSERTION 1: valid_out follows valid_in by exactly 1 cycle
    // DUT registers valid_in, so valid_out should appear on the next clock
    // ========================================================================
    property p_valid_out_follows_valid_in;
        @(posedge clk) disable iff (!rst_n)
        valid_in |=> valid_out;
    endproperty
    a_valid_out_follows: assert property (p_valid_out_follows_valid_in)
        begin assert_pass_count++; valid_out_follows_pass++; end
        else begin assert_fail_count++; valid_out_follows_fail++;
            $error("ASSERT FAIL: valid_out did not follow valid_in after 1 cycle"); end

    // ========================================================================
    // ASSERTION 2: No valid_in means no valid_out next cycle
    // When nothing is driven, DUT should not produce output
    // ========================================================================
    property p_no_valid_in_no_valid_out;
        @(posedge clk) disable iff (!rst_n)
        !valid_in |=> !valid_out;
    endproperty
    a_no_valid_in: assert property (p_no_valid_in_no_valid_out)
        begin assert_pass_count++; no_valid_in_pass++; end
        else begin assert_fail_count++; no_valid_in_fail++;
            $error("ASSERT FAIL: valid_out asserted without prior valid_in"); end

    // ========================================================================
    // ASSERTION 3: Result correctness
    // When valid_out is high, result must equal the sum of previous a and b
    // ========================================================================
    property p_result_correct;
        @(posedge clk) disable iff (!rst_n)
        valid_in |=> (result == ($past(a) + $past(b)));
    endproperty
    a_result_correct: assert property (p_result_correct)
        begin assert_pass_count++; result_correct_pass++; end
        else begin assert_fail_count++; result_correct_fail++;
            $error("ASSERT FAIL: result (%0d) != expected (%0d + %0d = %0d)",
                   result, $past(a), $past(b), $past(a) + $past(b)); end

    // ========================================================================
    // ASSERTION 4: Reset clears outputs
    // After reset, valid_out and result must both be 0
    // ========================================================================
    property p_reset_clears;
        @(posedge clk)
        !rst_n |=> (!valid_out && (result == 0));
    endproperty
    a_reset_clears: assert property (p_reset_clears)
        begin assert_pass_count++; reset_clears_pass++; end
        else begin assert_fail_count++; reset_clears_fail++;
            $error("ASSERT FAIL: outputs not cleared after reset"); end

    // ========================================================================
    // FINAL REPORT
    // ========================================================================
    final begin
        $display("");
        $display("############################################################");
        $display("                 SVA ASSERTION REPORT                       ");
        $display("############################################################");
        $display("  SUMMARY:");
        $display("    Total Assertions Checked : %0d", assert_pass_count + assert_fail_count);
        $display("    Passed                   : %0d", assert_pass_count);
        $display("    Failed                   : %0d", assert_fail_count);
        $display("");
        $display("  PER-ASSERTION BREAKDOWN:");
        $display("    valid_out follows valid_in : %0d pass, %0d fail", valid_out_follows_pass, valid_out_follows_fail);
        $display("    no valid_in => no out      : %0d pass, %0d fail", no_valid_in_pass, no_valid_in_fail);
        $display("    result correctness         : %0d pass, %0d fail", result_correct_pass, result_correct_fail);
        $display("    reset clears outputs       : %0d pass, %0d fail", reset_clears_pass, reset_clears_fail);
        $display("############################################################");
        $display("");
    end
endmodule