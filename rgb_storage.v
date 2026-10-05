`timescale 1ns / 1ps
/*
    This module drives the location data of the interactable box. It intakes any movement button signals and
    outputs the current bounds of the box. 
*/
module rgb_storage(
    input clk,
    input upd,
    input downd,
    input leftd,
    input rightd,
    input reset,
    output reg[9:0]pixel_LH,//Set the bounds of the image
    output reg[9:0]pixel_RH,//LH---RHG    UV
    output reg[9:0]pixel_UV,//            |
    output reg[9:0]pixel_DV//             DV
    );
    
    reg [9:0]pixel_LH_next,pixel_RH_next;
    reg [9:0]pixel_UV_next,pixel_DV_next;
    always @(*)begin
        if(upd) begin //Update up if Up input
            pixel_UV_next <= (pixel_UV - 'd1); 
            pixel_DV_next <= (pixel_DV - 'd1);
            pixel_LH_next <= pixel_LH; 
            pixel_RH_next <= pixel_RH;
        end
        else if(downd) begin //Update down if Down input
            pixel_UV_next <= (pixel_UV + 'd1); 
            pixel_DV_next <= (pixel_DV + 'd1);
            pixel_LH_next <= pixel_LH; 
            pixel_RH_next <= pixel_RH;
        end
        else if(leftd) begin //Update left if Left input
            pixel_UV_next <= pixel_UV; 
            pixel_DV_next <= pixel_DV;
            pixel_LH_next <= (pixel_LH - 'd1); 
            pixel_RH_next <= (pixel_RH - 'd1);
        end
        else if(rightd) begin //Update right if Right input
            pixel_UV_next <= pixel_UV; 
            pixel_DV_next <= pixel_DV;
            pixel_LH_next <= (pixel_LH + 'd1); 
            pixel_RH_next <= (pixel_RH + 'd1);
        end
        else begin //If no input, hold 
            pixel_UV_next <= pixel_UV; 
            pixel_DV_next <= pixel_DV;
            pixel_LH_next <= pixel_LH; 
            pixel_RH_next <= pixel_RH;
        end
    end
    
    always @(posedge clk_25m or posedge reset)begin
        if (reset == 'd1)begin
            pixel_UV <= 'd253;//Resets the box position to the center of the screen
            pixel_DV <= 'd277;
            pixel_LH <= 'd442; 
            pixel_RH <= 'd466;
        end
        else begin
            pixel_UV <= pixel_UV_next;//Updates current box position data at clk tick
            pixel_DV <= pixel_DV_next;
            pixel_LH <= pixel_LH_next;
            pixel_RH <= pixel_RH_next;
        end
    end
    
endmodule
