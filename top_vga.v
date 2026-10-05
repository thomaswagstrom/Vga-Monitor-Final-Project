`timescale 1ns / 1ps

module top_vga(
    input clk,
    input up,//Inputs
    input down,
    input left,
    input right,
    input color,//Toggles background color
    input reset,
    output reg[3:0]red,//Signals for pixel color
    output reg[3:0]grn,
    output reg[3:0]blu,
    output reg hsync,//Syncronizors for the monitor
    output reg vsync
    );
    wire clk_25m;
    clk_div pxl(clk,reset,3'd1,clk_25m);//Creates a 25MHz clk for refreshing the screen
    
    wire upd,downd,leftd,rightd;
    //Debounces the button inputs. (The d means debounced)
    debouncer U1(clk,reset,up,upd);
    debouncer D1(clk,reset,down,downd);
    debouncer L1(clk,reset,left,leftd);
    debouncer R1(clk,reset,right,rightd);
    
    wire [9:0] valuev,valueh; //Refresh counter for the screen
    refresh ref(clk_25m,reset,valueh,valuev);

    //Syncronizing pulse counters:
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
    
    rgb_storage data(clk,upd,downd,leftd,rightd,reset,pxlLH,pxlRH,pxlUV,pxlDV);//Need to use default basis clk for input updates, slower 25MHz clk causes issues
    
    wire letterW,letterT;//    Upper|Lower|Left|Right
    characterT T(valueh,valuev,'d472,'d480,'d150,'d158,letterT);//Calculates if pixel is part of the "T"
    characterW W(valueh,valuev,'d472,'d480,'d160,'d168,letterW);//Calculates if pixel is part of the "W"
    
    //RGB output logic:
    always @(*) begin
        if ((valueh > 142) && (valueh < 783) && (valuev > 33) && (valuev < 514)) begin//Checks if in display range
            if ((valueh > pxlLH) && (valueh < pxlRH) && (valuev > pxlUV) && (valuev < pxlDV))begin //If in box range, display black. This is the moveable icon
                red <= 'b0000;
                blu <= 'b0000;
                grn <= 'b0000;
            end
            else if ((letterT=='d1) || (letterW=='d1))begin //Makes pixel part of a letter blue
                red <= 'b0000;
                blu <= 'b1111;
                grn <= 'b0000;
            end
            else if (color == 'd1)begin//If color switch is on, changes background to Magenta
                red <= 'b1111;
                blu <= 'b1111;
                grn <= 'b0000;
            end
            else begin //Default background "color" is white
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
