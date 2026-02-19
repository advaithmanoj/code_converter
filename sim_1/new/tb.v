`timescale 1ns / 1ps

module tb_codeconv_dual;

//////////////////////////
// DUT signals
//////////////////////////

reg clk;
reg reset;
reg start;
reg convert;              // 0=bin2gray, 1=gray2bin
reg [7:0] data_in;

wire [7:0] data_out;
wire done;

//////////////////////////
// Instantiate DUT
//////////////////////////

top DUT (
    .clk(clk),  //
    .reset(reset),
    .start(start),
    .convert(convert),
    .data_in(data_in),
    .data_out(data_out),   // rename if needed
    .done(done)
);

//////////////////////////
// Clock
//////////////////////////

initial clk = 0;
always #5 clk = ~clk;

//////////////////////////
// Reference models
//////////////////////////

function [7:0] bin2gray;
input [7:0] b;
begin
    bin2gray = b ^ (b >> 1);
end
endfunction


function [7:0] gray2bin;
input [7:0] g;
integer i;
begin
    gray2bin[7] = g[7];
    for (i=6; i>=0; i=i-1)
        gray2bin[i] = gray2bin[i+1] ^ g[i];
end
endfunction

//////////////////////////
// Start pulse task
//////////////////////////

task start_pulse;
begin
    // ensure FSM is not in DONE
    wait(done == 0);

    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;
end
endtask


//////////////////////////
// Run one test
//////////////////////////

task run_test;
input [7:0] val;
reg [7:0] expected;
begin
    data_in = val;

    start_pulse();

    @(posedge done);
    @(posedge clk);   // allow output register settle

    if (convert == 0)
        expected = bin2gray(val);
    else
        expected = gray2bin(val);

    if (data_out === expected)
        $display("PASS convert=%0d in=%b out=%b",
                  convert, val, data_out);
    else
        $display("FAIL convert=%0d in=%b out=%b expected=%b",
                  convert, val, data_out, expected);

end
endtask



//////////////////////////
// Test sequence
//////////////////////////

initial begin

    $display("==== Dual Mode Code Converter Test ====");

    reset = 1;
    start = 0;
    convert  = 0;
    data_in = 0;

    repeat(3) @(posedge clk);
    reset = 0;

    ////////////////////////////////////
    // Mode 0 - Binary → Gray
    ////////////////////////////////////

    $display("\n--- Binary to Gray ---");
    convert = 0;

    run_test(8'h00);
    run_test(8'h01);
    run_test(8'h0F);
    run_test(8'h55);
    run_test(8'hA3);
    run_test(8'hFF);

    repeat(5)
        run_test($random);

    ////////////////////////////////////
    // Mode 1 - Gray → Binary
    ////////////////////////////////////

    $display("\n--- Gray to Binary ---");
    convert = 1;

    run_test(8'h00);
    run_test(8'h01);
    run_test(8'h08);
    run_test(8'h7F);
    run_test(8'hF2);
    run_test(8'h80);

    repeat(5)
        run_test($random);

    $display("\n==== TEST COMPLETE ====");
   #50
    $stop;
end

endmodule
