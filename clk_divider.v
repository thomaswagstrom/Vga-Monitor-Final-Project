`timescale 1ns / 1ps

//clock_divider from LB11
module clk_div(
        input mainclk, // Basys Clock runs at 100MHz
        input reset,
        input [2:0]div,
        output reg div_clk);
        reg [2:0] pulsecount;
        always @ (posedge mainclk or posedge reset) begin
            if (reset == 1'd1) begin
                pulsecount <= 0;
                div_clk <= 0;
            end
            else begin
                if (pulsecount == div) begin //div allows for variable clk division
                    div_clk <= ~div_clk;
                    pulsecount <= 0;
                end
            else begin
                pulsecount <= pulsecount + 1;
            end
        end
    end
endmodule
