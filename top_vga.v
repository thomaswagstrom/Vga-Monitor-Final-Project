`timescale 1ns / 1ps

module top_vga(
    input clk,
    input up,
    input down,
    input left,
    input right,
    output [3:0]red,
    output [3:0]grn,
    output [3:0]blu,
    output reg hsync,
    output reg vsync
    );
    wire reset;
    wire clk_25m;
    assign reset = 0;
    clk_div pxl(clk,reset,36'd4,clk_25m);//Sets the clock to 25MHz
    
    wire [9:0] valuev,valueh; //Refreshes the scren
    refresh ref(clk_25m,valuev,valueh);
    
    always @(*) begin //For the horizontal sync pulse
        if (valueh < 97) hsync = 0;
        else hsync <= 1;
    end
    
    always @(*) begin //For the Verticle sync pulse
        if (valuev < 3) vsync = 0;
        else vsync <= 1;
    end
    
    //always @(*) begin
       // if (valueh > 
        
    
endmodule
