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
	
	input wire bus; // TODO: not sure how many bits the bus is
	
	// TODO: implement logic
	
	always @(*) begin
		case(sel)
			// Only need 10 cases since 10 inputs
			4'b0000:
			4'b0001:
			4'b0010:
			4'b0011:
			4'b0100:
			4'b0101:
			4'b0110:
			4'b0111:
			4'b1000:
			4'b1001:
			default:
		endcase
	end

endmodule

module ALU (input_a, input_b, alu_op, result);
	/* 
	 * This module implements the arithmetic logic unit of the processor.
	 */
	// TODO: declare inputs and outputs


	// TODO: Implement ALU Logic:
endmodule



module register_n(data_in, r_in, clk, Q, rst);


	// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals

	parameter N = 16;

	/* 
	 * This module implements registers that will be used in the processor.
	 */
	// TODO: Declare inputs, outputs, and parameter:
	
	// TODO: Implement register logic:
endmodule

