`timescale 1ns / 1ps

module refresh(
    input clk_m25,
    output reg [9:0]cnth,
    output reg [9:0]cntv
    );
    reg [9:0]next_cnth;
    reg hpulse;
    
    always @(posedge clk_m25) begin//Runs throught the horizontal line on the screen, sends out a pulse at the end of the line to jump down to the next line
        if (cnth == 800)begin
            next_cnth = 0; hpulse = 1;
        end
        else begin
            next_cnth = cnth +1; hpulse = 0;
        end
    end
   
    reg [9:0] next_cntv;

    always @(posedge clk_m25) begin //Cycles down one line each time there is an hpulse
        if(hpulse==1)begin
            if(cntv == 525) next_cntv = 0;
            else next_cntv = cntv + 1;
        end
        else cntv = cntv;
    end
endmodule
