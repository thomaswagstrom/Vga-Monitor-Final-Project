`timescale 1ns / 1ps

//clock_divider from LB11, a lab previously done in this class. This module is from that
module clk_div(
        input mainclk, // Basys Clock runs at 100MHz
        input reset,
        input [2:0]div,//Only set to 1 for this project. Becomes 1/4th 100MHz
        output reg div_clk);//This is because it counts skips one clk edge, then toggles the divided clk, skips again, then toggles back.
        reg [2:0] pulsecount;
        always @ (posedge mainclk or posedge reset) begin //Reset
            if (reset == 'd1) begin
                pulsecount <= 'd0;
                div_clk <= 'd0;
            end
            else begin
                if (pulsecount == div) begin //div allows for variable clk division
                    div_clk <= ~div_clk;//Toggles clk H/L
                    pulsecount <= 'd0;//Then resets to 0
                end
            else begin
                pulsecount <= pulsecount + 'd1;//Otherwise, counts up
            end
        end
    end
endmodule
