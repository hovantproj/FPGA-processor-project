/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual components to be used in 
    the CPU.

Please enter your name and student ID: Hovan Truong 36164003
Please enter your name and student ID: Philo Lee 36167762

*/
module sign_extend(in, ext);

	// This module sign extends the 9-bit input to a 16-bit output
	
	input [8:0] in;
	output [15:0] ext;
	
	assign ext = {{7{in[8]}}, in};
	
endmodule



module tick_FSM(rst, clk, enable, tick);
	/* 
	 * This module implements a tick FSM that will be used to
	 * control the actions of the control unit
	 */

	input rst;
	input clk;
	input enable;
	output reg [3:0] tick;
	
	 parameter A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000;
	 
	 always @(posedge clk) begin
		if (rst) begin
			tick <= A;
		end
		
		else if (enable) begin
			case (tick)
				A: tick <= B;
				B: tick <= C;
				C: tick <= D;
				D: tick <= A;
				default: tick <= A;
			endcase
		end
	 end
endmodule

module multiplexer(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, Bus);
	/* 
	 * This module takes 10 inputs and places the correct input onto the bus.
	 */
	input [15:0] R0;
	input [15:0] R1;
	input [15:0] R2;
	input [15:0] R3;
	input [15:0] R4;
	input [15:0] R5;
	input [15:0] R6;
	input [15:0] R7;
	input [15:0] G;
	input [3:0] sel;
	input [15:0] SignExtDin;
	
	output reg [15:0] Bus;
	
	always @(*) begin
		case(sel)
			// Only need 10 cases since 10 inputs
			4'b0000: Bus <= R0;
			4'b0001: Bus <= R1;
			4'b0010: Bus <= R2;
			4'b0011: Bus <= R3;
			4'b0100: Bus <= R4;
			4'b0101: Bus <= R5;
			4'b0110: Bus <= R6;
			4'b0111: Bus <= R7;
			4'b1000: Bus <= G;
			4'b1001: Bus <= SignExtDin;
			default: Bus <= 16'd0;
		endcase
	end
endmodule

module ALU (input_a, input_b, alu_op, result);
	 
	// This module computes arithmetic result from input_a and input_b based on alu_op


    input [15:0] input_a;
    input [15:0] input_b;
    input [2:0] alu_op;
    output reg [15:0] result;

	always @(*) begin
		case(alu_op)
			
			3'b000: result = input_a * input_b;
			3'b001: result = input_a + input_b;
			3'b010: result = input_a - input_b;
			3'b011: begin
				if(input_a[15]) 
					result = $signed(input_b) <<< (-input_a);
				else
					result = $signed(input_b) >>> input_a;
				end
			
			default: result = 16'b0000;
			
			
		endcase
	end
	
endmodule



module register_n(data_in, r_in, clk, Q, rst);
	// This module implements registers that will be used in the processor.
	
	// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals

	parameter N = 16;
	
	input wire [N-1:0] data_in;
	input wire r_in;
	input wire clk;
	input wire rst;
	output reg [N-1:0] Q;
	
	// waits for clock tick to begin
	always @(posedge clk) begin
		// clears register if rst requested
		if(rst)
			Q <= {N{1'b0}};
		else if (r_in)
			Q <= data_in;
	end
	
endmodule

