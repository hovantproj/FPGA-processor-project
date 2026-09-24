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
	// TODO: Declare inputs and outputs
	
	// TODO: implement logic


endmodule

module ALU (input_a, input_b, alu_op, result);
	 
	// This module computes arithmetic result from input_a and input_b based on alu_op


    input [15:0] input_a,
    input [15:0] input_b,
    input [1:0] alu_op,
    output reg [15:0] result
);

	always @(*) begin
		case(alu_op)
			
			3'b000: result = input_a * input_b;
			3'b001: result = input_a + input_b;
			3'b010: result = input_a - input_b;
			3'b011: begin
				if(input_a[15]) begin
					result <= input_b <<< input_a;
				and else begin
					result = input_b >>> input_a;
				end
			end
			
			default: result = 16'h0000;
			
			
		endcase
	end
	
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

