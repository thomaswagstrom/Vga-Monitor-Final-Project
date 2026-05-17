`timescale 1ns / 1ps

module rgb_storage(
    input clk_25m,
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
        if(upd) begin //Update if Up
            pixel_UV_next <= (pixel_UV + 'd1); 
            pixel_DV_next <= (pixel_DV + 'd1);
            pixel_LH_next <= pixel_LH; 
            pixel_RH_next <= pixel_RH;
        end
        else if(downd) begin //Update if Down
            pixel_UV_next <= (pixel_UV - 'd1); 
            pixel_DV_next <= (pixel_DV - 'd1);
            pixel_LH_next <= pixel_LH; 
            pixel_RH_next <= pixel_RH;
        end
        else if(leftd) begin //Update if Left
            pixel_UV_next <= pixel_UV; 
            pixel_DV_next <= pixel_DV;
            pixel_LH_next <= (pixel_LH - 'd1); 
            pixel_RH_next <= (pixel_RH - 'd1);
        end
        else if(rightd) begin //Update if Right
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
            pixel_UV <= 'd253;//Should make/move a box in the center of the screen on reset
            pixel_DV <= 'd277;
            pixel_LH <= 'd442; 
            pixel_RH <= 'd466;
        end
        else begin
            pixel_UV <= pixel_UV_next;//Updates data at clk
            pixel_DV <= pixel_DV_next;
            pixel_LH <= pixel_LH_next;
            pixel_RH <= pixel_RH_next;
        end
    end
    
endmodule
