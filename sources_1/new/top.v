`timescale 1ns / 1ps
module top(
input wire [7:0]data_in,///
input clk,
input wire reset,start,
input convert,
output [7:0]data_out,
output wire done
    );

//internal wires
 wire R1_in, R2_in, R3_in, R4_in;
wire cnt_load, cnt_dec;
wire msb_copy;
wire cnt_zero;

//CU  
  control CU (
    .clk(clk),
    .reset(reset),
    .start(start),
    .cnt_zero(cnt_zero),
    .R1_in(R1_in),
    .R2_in(R2_in),
    .R3_in(R3_in),
    .R4_in(R4_in),
    .cnt_load(cnt_load),
    .cnt_dec(cnt_dec),
    .msb_copy(msb_copy),
    .done(done)
);


//datapath
datapath DP (
    .clk(clk),
    .reset(reset),
    .cnt_load(cnt_load),
    .cnt_dec(cnt_dec),
    .msb_copy(msb_copy),
    .convert(convert),
    .R1_in(R1_in),
    .R2_in(R2_in),
    .R3_in(R3_in),
    .R4_in(R4_in),
    .bus_in(data_in),
    .bus_out(data_out),
    .cnt_zero(cnt_zero)
);
endmodule
