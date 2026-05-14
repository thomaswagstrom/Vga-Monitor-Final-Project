`timescale 1ns / 1ps

module refresh(
    input clk_m25,
    input reset,
    output reg [9:0]cnth,
    output reg [9:0]cntv
    );
    reg hpulse;
    
    always @(posedge clk_m25 or posedge reset) begin//Runs throught the horizontal line on the screen, sends out a pulse at the end of the line to jump down to the next line
        if (reset==1) cnth <= 0;
        else begin
            if (cnth == 800)begin
                cnth <= 0; hpulse <= 1;
            end
            else begin
                cnth <= cnth +1; hpulse <= 0;
            end
        end
    end

    always @(posedge clk_m25 or posedge reset) begin //Cycles down one line each time there is an hpulse
        if (reset==1) cntv <= 0;
        else begin
            if(hpulse==1)begin
                if(cntv == 525) cntv <= 0;
                else cntv <= cntv + 1;
            end
            else cntv <= cntv;
       end
    end
endmodule
