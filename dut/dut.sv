//
// dut.sv
// Author: Assaf Afriat
// Date: 2026-03-15
// Description: DUT for the UVM template
//

module dut(
    
    //inputs
    input clk,
    input rst_n,
    input [7:0] a,
    input [7:0] b,
    input valid_in,

    // outputs (logic so always_ff can drive them; plain output is a net in SV)
    output logic [8:0] result,
    output logic valid_out
    
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            result <= 0;
            valid_out <= 0;
        end else begin
            if (valid_in) begin
                result <= a+b;
                valid_out <= 1;
            end else begin
                result <= 0;
                valid_out <= 0;
            end
        end
    end

endmodule