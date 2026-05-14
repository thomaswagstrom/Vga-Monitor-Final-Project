`timescale 1ns / 1ps

module top_vga(
    input clk,
    input up,
    input down,
    input left,
    input right,
    input reset,
    output reg[3:0]red,
    output reg[3:0]grn,
    output reg[3:0]blu,
    output reg hsync,
    output reg vsync
    );
    wire clk_25m;
    clk_div pxl(clk,reset,'d1,clk_25m);//Sets the clock to 25MHz
    
    wire upd,downd,leftd,rightd;
    
    debouncer U1(clk,reset,up,upd);
    debouncer D1(clk,reset,down,downd);
    debouncer L1(clk,reset,left,leftd);
    debouncer R1(clk,reset,right,rightd);
    
    wire [9:0] valuev,valueh; //Refreshes the screen
    refresh ref(clk_25m,reset,valueh,valuev);

    always @(*) begin //For the horizontal sync pulse
        if (valueh < 97) hsync <= 0;
        else hsync <= 1;
    end

    always @(*) begin //For the Verticle sync pulse
        if (valuev < 3) vsync <= 0;
        else vsync <= 1;
    end 
    
    wire [9:0] pxlLH,pxlRH;
    wire [9:0] pxlUV,pxlDV;
    
    rgb_storage data(clk_25m,upd,downd,leftd,rightd,reset,pxlLH,pxlRH,pxlUV,pxlDV);
     
    always @(*) begin
        if ((valueh > 142) && (valueh < 783) && (valuev > 33) && (valuev < 514)) begin
            if ((valueh > pxlLH) && (valueh < pxlRH) && (valuev > pxlUV) && (valuev < pxlDV))begin //If in box range, display black
                red <= 'b0000;
                blu <= 'b0000;
                grn <= 'b0000;
            end
            else begin
                red <= 'b1111;
                blu <= 'b1111;
                grn <= 'b1111;
            end
        end
        else begin //Pixel outside display range are set to black
            red <= 'b0000;
            grn <= 'b0000;
            blu <= 'b0000;
        end
    end


endmodule
