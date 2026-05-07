`timescale 1ns / 1ps

//Code handout for project
module dff(
    input clk,
    input reset,
    input d,
    output reg q
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset==1) q<=1'b0;
        else q<=d;
    end
    
endmodule
