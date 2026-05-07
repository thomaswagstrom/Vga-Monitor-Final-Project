`timescale 1ns / 1ps

//Code handout for project

module counter_enable(
    input en,
    input clk,
    input reset,
    input clear,
    output pulse,
    output reg [31:0] cnt
    );

parameter terminal_count = 32'd1000000; // This sets the time between successive button pushes. Lock out for at least 10 ms.
                                   // 10 ms = 10e-3. 100 MHz = 100 million clocks per second * 10e-3 = 1000000 
reg [31:0] next_cnt;

// flip-flops (state memeory) Counts up with a reset
always @(posedge clk or posedge reset) begin
    if (reset==1'b1) cnt<=terminal_count; // reset to zero by setting the counter to max
    else cnt <= next_cnt;
end

// next-state logic 
always @(*) begin
    if(en) begin // check for the enable 
        if (cnt == terminal_count) begin
            if (clear==1) next_cnt = 0; // if the counter reaches terminal count and is cleared 
            else next_cnt = cnt;
        end
        else next_cnt = cnt + 1; // else counts up
    end 
    else next_cnt = cnt; // if enable is low stay in the same state 
end

// output logic 
assign pulse = (cnt == (terminal_count-1)); // at the 2nd to last state send out a pulse... not last state otherwise reset would cause a pulse

endmodule
