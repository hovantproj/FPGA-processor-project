`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID: 36164003 - Hovan
Please enter your student ID: 36167762 - Philo

*/
module components_tb.v;
	// Sign Extender
	reg signed [8:0] in;
	wire signed [15:0] out;
	reg signed [15:0] expected1;
	sign_extend sign_extend(.in(in), .ext(out));
	
	// tick_FSM
	reg tick_clk;
	reg tick_enable;
	reg tick_rst;
	wire [3:0] tick_out;
	reg [3:0] expected2;
	
	// ALU
	reg [15:0] input_a;
	reg [15:0] input_b;
	reg [2:0] alu_op;
	wire [15:0] result;
	reg [15:0] expected3;
	ALU ALU(.input_a(input_a), .input_b(input_b), .alu_op(alu_op));
	
	// Multiplexer
	reg [15:0] SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G;
	reg [3:0] sel;
	wire [15:0] bus;
	wire [15:0] expected4;
	multiplexer multiplexer(.SignExtDin(SignExtDin), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7), .G(G), .sel(sel), .Bus(Bus));
	
	
	// Registers
	parameter NUM_BITS = 16;
	reg [NUM_BITS-1:0] data_in;
	reg r_in;
	reg clk;
	reg rst;
	wire [NUM_BITS-1:0] out;
	reg [NUM_BITS-1:0] expected
	register_n #(.N(NUM_BITS)) register_n(.data_in(data_in), .r_in(r_in), .clk(clk), .rst(rst), .Q(out)))
endmodule