`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID: 36164003 - Hovan
Please enter your student ID: 36167762 - Philo

*/
module components_tb;
	// Sign Extender
	reg signed [8:0] sign_ext_in;
	wire signed [15:0] sign_ext_out;
	reg signed [15:0] sign_ext_expected;
	sign_extend sign_extend(.in(sign_ext_in), .ext(sign_ext_out));
	
	// Tick FSM
	reg tick_clk;
	reg tick_enable;
	reg tick_rst;
	wire [3:0] tick_out;
	reg [3:0] tick_expected;
	tick_FSM tick_FSM(.rst(tick_rst), .clk(tick_clk), .enable(tick_enable), .tick(tick_out));
	
	// ALU
	reg [15:0] alu_input_a;
	reg [15:0] alu_input_b;
	reg [2:0] alu_op;
	wire [15:0] alu_out;
	reg [15:0] alu_expected;
	ALU ALU(.input_a(alu_input_a), .input_b(alu_input_b), .alu_op(alu_op), .result(alu_out));
	
	// Multiplexer
	reg [15:0] SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G;
	reg [3:0] sel;
	wire [15:0] mult_out;
	reg [15:0] mult_expected;
	multiplexer multiplexer(.SignExtDin(SignExtDin), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7), .G(G), .sel(sel), .Bus(mult_out));
	
	// Registers
	reg r_in;
	reg reg_clk;
	reg reg_rst;
	
	reg [15:0] reg_data_in16;
	wire [15:0] reg_out16;
	reg [15:0] reg_expected16;
	
	reg [31:0] reg_data_in32;
	wire [31:0] reg_out32;
	reg [31:0] reg_expected32;
	
	register_n #(.N(16)) register_n16(.data_in(reg_data_in16), .r_in(r_in), .clk(reg_clk), .rst(reg_rst), .Q(reg_out16)); // Try 16 bit (square)
	register_n #(.N(32)) register_n32(.data_in(reg_data_in32), .r_in(r_in), .clk(reg_clk), .rst(reg_rst), .Q(reg_out32)); // Try 32 bit (not square)
	
	integer errors, count;
	
	initial begin
		errors = 32'd0;
		count = 32'd0;
		tick_clk = 0;
		reg_clk = 0;
		
		tick_rst = 1;
		reg_rst = 1;

		r_in = 1;
	end
	
	always begin // 1 cycle every 10ms (5ms to go up, 5ms to go down)
		#5
		tick_clk <= ~tick_clk;
		reg_clk <= ~reg_clk;
	end
	
	// Sign extender testcases
	always begin
		#1			
		if (count < 3) begin
			case (count)
				0: begin 
					sign_ext_in <= {9{1'b0}};
					sign_ext_expected <= {16{1'b0}};
				end
				1: begin
					sign_ext_in <= {9{1'b1}};
					sign_ext_expected <= {16{1'b1}};
				end
				2: begin
					sign_ext_in <= 9'b101010101;
					sign_ext_expected <= 16'b1111111101010101;
				end
			endcase
		end
		
		#9
	end
	
	// Tick FSM testcases
	always begin
		always begin
			#1
			if (count < 5) begin
				case (count)
					0: begin 
						tick_rst <= 1;
						tick_enable <= 0;
						tick_expected <= 4'b0001;
					end
					
					1: begin
						tick_rst <= 0;
						tick_enable <= 1;
						tick_expected <= 4'b0010;
					end	
					
					2: begin
						tick_expected <= 4'b0100;
					end
					
					3: begin
						tick_expected <= 4'b1000;
					end
					
					4: begin
						tick_expected <= 4'b0001;
					end
				endcase
			end
			
			#9
		end
	end
	
	// ALU testcases
	always begin
		
	end
	
	// Multiplexer testcases
	always begin
		
	end
	
	// Register testcases
	always begin
		
	end
	
	// Check sign extender
	always begin
		#9
		if (count < 3) begin
			if (sign_ext_out != sign_ext_expected) begin
				$display("Sign extender error: Input: %d, Output: %d, Expected: %d", sign_ext_in, sign_ext_out, sign_ext_expected);
				errors = errors + 1;
			end
		end
		
		#1
	end
	
	// Check tick fsm
	
	// Checj alu
	
	// Check multiplexer
	
	// Check registers
	
	
	always begin // Need to increent count, having it in each would screw it up
		#10
		count = count + 1;
	end
	
endmodule