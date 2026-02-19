`timescale 1ns / 1ps

module control(///
input  wire clk,
input  wire reset,
input  wire start,
input  wire cnt_zero,

output reg R1_in, R2_in, R3_in, R4_in,
output reg cnt_load, cnt_dec,
output reg msb_copy,
output reg done
);

//states
reg [2:0] state,next_state;

localparam S0_IDLE       = 3'd0,
           S1_LOAD       = 3'd1,
           S2_MSB        = 3'd2,
           S3_LOAD_R3R4  = 3'd3,
           S4_STORE      = 3'd4,
           S5_DEC        = 3'd5,
           S6_DONE       = 3'd6;
           
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= S0_IDLE;
    else
        state <= next_state;
end

//next state logic
always@(*)begin
next_state = state;
case(state)
S0_IDLE: if(start) next_state = S1_LOAD;
S1_LOAD: next_state = S2_MSB;
S2_MSB : next_state = S3_LOAD_R3R4;
S3_LOAD_R3R4 : next_state = S4_STORE;
S4_STORE:     next_state = S5_DEC;
S5_DEC:  if (cnt_zero) next_state = S6_DONE;
        else          next_state = S3_LOAD_R3R4;
        
 S6_DONE:
        if (!start) next_state = S0_IDLE;
endcase 
end

//output signal logic for each state
always@(*) begin
// default all zero
R1_in = 0; R2_in = 0; R3_in = 0; R4_in = 0;
cnt_load = 0; cnt_dec = 0;
msb_copy = 0;
done = 0;

case(state)
S1_LOAD: begin
    R1_in   = 1;
    cnt_load= 1;   // load counter = 7
end
S2_MSB: begin
    R2_in   = 1;
    msb_copy= 1;   // copy MSB directly
end
S3_LOAD_R3R4: begin
    R3_in = 1;
    R4_in = 1;
end
S4_STORE: begin
    R2_in = 1;     // write XOR result
end
S5_DEC: begin
    cnt_dec = 1;
end
S6_DONE: begin
    done = 1;
end
endcase
end
           
endmodule
