`timescale 1ns / 1ps

module datapath(
input clk,
input reset,
input cnt_load,//
input cnt_dec,
input msb_copy,
input  convert,  // // 0=bin2gray, 1=gray2bin
input R1_in,R2_in,R3_in,R4_in,
input [7:0] bus_in,
output [7:0] bus_out,
output cnt_zero
    );
    
    //internal wires for reg


reg [7:0]R1,R2;    //R1 for binary R2 for grey code
reg R3,R4;         //R3 for R1(i+1) and R4 for R1(i)
reg [2:0] cnt;

//counter from 7
always @(posedge clk or posedge reset) begin
    if (reset)
        cnt <= 3'd0;
    else if (cnt_load)
        cnt <= 3'd7;
    else if (cnt_dec)
        cnt <= cnt - 1'b1;
end

assign cnt_zero = (cnt == 3'd0);

//LOAD R1
always @(posedge clk) begin
    if (R1_in)
        R1 <= bus_in;
end


//select bits
wire r1_bit_i = R1[cnt];
wire r1_bit_next_to_i_bit = R1[cnt+1];
wire r2_bit_i = R2[cnt];
wire r2_bit_next_to_i_bit = R2[cnt+1];

//loading R3 and R4
wire r3_wire = convert?r2_bit_next_to_i_bit:r1_bit_next_to_i_bit;
wire r4_wire = r1_bit_i;

always @(posedge clk) begin
    if (R3_in)
        R3 <= r3_wire;
end
always @(posedge clk) begin
    if (R4_in)
        R4 <= r4_wire;
end

//XOR GATE
wire xor_out = R3 ^ R4;

//R2 logic
always @(posedge clk or posedge reset) begin
  if (reset)
    R2 <= 8'd0;
  else if (R2_in) begin
    if (msb_copy)
      R2[7] <= R1[7];
    else if (cnt != 3'd7)
      R2[cnt] <= xor_out;
  end
end

//assign  R2[7] = R1[7];
assign bus_out = R2;



endmodule
