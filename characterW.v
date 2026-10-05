`timescale 1ns / 1ps
/* 
    This file is a representation of the first character of my initials, 'W'. 
    Inputs are the bounds of where the character is on the display as well as the value of the
    current pixel in the refresh cycle. The output is whether this pixel is part of the character or not.
*/
module characterW(
    input [9:0]valueh,//Current H value
    input [9:0]valuev,//Current V value
    input [9:0]Uvaluev,//Upper bound of the character
    input [9:0]Bvaluev,//Bottom bound of the character
    input [9:0]Lvalueh,//Left bound of the character
    input [9:0]Rvalueh,//Right bound of the character
    output reg letter//Is the current pixel part of the letter?
    );
    
    wire [7:0] v0,v1,v2,v3,v4,v5,v6,v7;//Verticle axis, 0/1's Horizontal Axis
    assign v0 = 8'b00000000;//          //Essentially a 2D array for "drawing" whatever character
    assign v1 = 8'b11000011;// ##    ##
    assign v2 = 8'b11011011;// ## ## ##
    assign v3 = 8'b11011011;// ## ## ##
    assign v4 = 8'b11011011;// ## ## ##
    assign v5 = 8'b01111110;//  ###### 
    assign v6 = 8'b01100110;//  ##  ## 
    assign v7 = 8'b00100100;//   #  #  
    
    always @(*) begin
        if ((valueh < Rvalueh) && (valuev < Bvaluev) && (valueh > Lvalueh -1) && (valuev > Uvaluev -1))begin //Checks if in bounds of the character
            if (((valuev-Uvaluev)=='d0)) begin letter <= (v0[valueh-Lvalueh]); end //Finds whether this value in the 2D array is a pixel in the letter
            else if (((valuev-Uvaluev)=='d1)) begin letter <= (v1[valueh-Lvalueh]); end
            else if (((valuev-Uvaluev)=='d2)) begin letter <= (v2[valueh-Lvalueh]); end
            else if (((valuev-Uvaluev)=='d3)) begin letter <= (v3[valueh-Lvalueh]); end
            else if (((valuev-Uvaluev)=='d4)) begin letter <= (v4[valueh-Lvalueh]); end
            else if (((valuev-Uvaluev)=='d5)) begin letter <= (v5[valueh-Lvalueh]); end
            else if (((valuev-Uvaluev)=='d6)) begin letter <= (v6[valueh-Lvalueh]); end
            else if (((valuev-Uvaluev)=='d7)) begin letter <= (v7[valueh-Lvalueh]); end
            else begin letter <= 'd0; end
        end
        else letter <= 'd0; //If not in character bounds, is not part of the letter
    end
    
endmodule
