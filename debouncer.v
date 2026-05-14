`timescale 1ns / 1ps

//Code handout for project,
// This module simulates debounce of an incoming push button signal with the result only a single 
// 1 clock wide output. The output locks out for 10 ms so a maximum of one pulse per 10 ms.
module debouncer(
    input clk,
    input reset,
    input pb_in, // input from push button
    output pb_pulse // output pulse (1 clock wide)
    /*output [31:0] count*/); //don't need count as an out
    wire [31:0] count;    
    wire pulse;
    wire rising_edge;
    wire q0, q1, q2;
    
    // look for a rising edge 
    dff U2(.clk(clk), .reset(reset), .d(pb_in), .q(q0));
    dff U3(.clk(clk), .reset(reset), .d(q0), .q(q1));
    assign rising_edge = q0 & (~q1);

    counter_enable U1(
    .en(1'b1),
    .clk(clk),
    .reset(reset),
    .clear(rising_edge),
    .pulse(pb_pulse),
    .cnt(count)
    );
                             
endmodule