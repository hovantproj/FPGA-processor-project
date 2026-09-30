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
	reg [31:0] alu_inputs = {32{1'b0}}; // Upper 16 bits is A, lower 16 is B
	reg [2:0] alu_op;
	wire [15:0] alu_out;
	reg [15:0] alu_expected;
	ALU ALU(.input_a(alu_inputs[31:16]), .input_b(alu_inputs[15:0]), .alu_op(alu_op), .result(alu_out));
	
	// Multiplexer
	reg [3:0] sel;
	wire [15:0] mult_out;
	reg [15:0] mult_expected;
	multiplexer multiplexer(.SignExtDin(16'd9), .R0(16'd0), .R1(16'd1), .R2(16'd2), .R3(16'd3), .R4(16'd4), .R5(16'd5), .R6(16'd6), .R7(16'd7), .G(16'd8), .sel(sel), .Bus(mult_out));
	
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
	
	register_n #(.N(16)) register_n16(.data_in(reg_data_in16), .r_in(r_in), .clk(reg_clk), .rst(reg_rst), .Q(reg_out16)); // 16 bit register
	register_n #(.N(32)) register_n32(.data_in(reg_data_in32), .r_in(r_in), .clk(reg_clk), .rst(reg_rst), .Q(reg_out32)); // 32 bit register
	
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
	
	always begin // 1 cycle every 10ns (5ns to go up, 5ns to go down)
		tick_clk <= ~tick_clk;
		reg_clk <= ~reg_clk;
		#5;
	end
	
	// Sign extender testcases
	always begin
		#1			
		if (count < 3) begin
			case (count)
				0: begin
					sign_ext_in = {9{1'b0}};
					sign_ext_expected = {16{1'b0}};
				end
				1: begin
					sign_ext_in = {9{1'b1}};
					sign_ext_expected = {16{1'b1}};
				end
				2: begin
					sign_ext_in = 9'b101010101;
					sign_ext_expected = 16'b1111111101010101;
				end
			endcase

			#8
			
			if (sign_ext_out !== sign_ext_expected) begin
				$display("Sign extender error: Input: %d, Output: %d, Expected: %d", sign_ext_in, sign_ext_out, sign_ext_expected);
				errors = errors + 1;
			end
		end
		
		else begin
			#8; // So that its consistent 10ns (1 + 8 + 1)
		end
		
		#1;
	end
	
	// Tick FSM testcases
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
			
			#8
			
			if (tick_out !== tick_expected) begin
				$display("Tick FSM error: Output: %d, Expected state: %d", tick_out, tick_expected);
				errors = errors + 1;
			end
		end
		
		else begin
			#8;
		end
		
		#1;
	end
	
	// ALU testcases
	always begin
		#1
		if (count < 4) begin
			case (count)
			
				// MULTIPLICATION
				
				0: begin
					// normal multiplication
					alu_op = 3'b000;
					alu_inputs = {16'd6, 16'd10};
					alu_expected = 16'd60;
					
				end
				
				1: begin
					// zero multiplication
					alu_op = 3'b000;
					alu_inputs = {16'd32, 16'd0};
					alu_expected = 16'd0;
				
				end
				
				2: begin
					// negative multiplication
					alu_op = 3'b000;
					alu_inputs = {-16'd5, 16'd2};
					alu_expected = -16'd10;
				
				end
				
				3: begin
					// negative on negative multiplication
					alu_op = 3'b000;
					alu_inputs = {-16'd5, -16'd2};
					alu_expected = 16'd10;	
				
				end
				
				4: begin
					// overflow, truncates to 1
					alu_op = 3'b000;
					alu_inputs = {16'd32767, 16'd32767};
					alu_expected = 16'd1;			
				
				end
				
				// ADDITION
					
				5: begin
					// normal addition
					alu_op = 3'b001;
					alu_inputs = {16'd6, 16'd7};
					alu_expected = 16'd13;	
				
				end
				
				6: begin
					// zero + zero
					alu_op = 3'b001;
					alu_inputs = {16'd0, 16'd0};
					alu_expected = 16'd0;
				
				end

				7: begin 
					// neg + pos = 0
					alu_op = 3'b001;
					alu_inputs = {-16'd1, 16'd1};
					alu_expected = 16'd0;
				
				end
				
				8: begin
					// maximum value +1 =  min
					alu_op = 3'b001;
					alu_inputs = {16'd32767, 16'd1};
					alu_expected = 16'd32768;
				
				end
				
				9: begin
					// min value -1 = max
					alu_op = 3'b001;
					alu_inputs = {16'd32768, -16'd1};
					alu_expected = 16'd32767;	
				
				end
				
				10: begin
					// min + min = 0
					alu_op = 3'b001;
					alu_inputs = {16'd32768, 16'd32768};
					alu_expected = 16'd0;
				
				end
				
				// SUBTRACTION
				
				11: begin
					// normal subtraction
					alu_op = 3'b010;
					alu_inputs = {16'd17, 16'd10};
					alu_expected = 16'd7;
					
				end
				
				12: begin
					// net 0
					alu_op = 3'b010;
					alu_inputs = {16'd20, 16'd20};
					alu_expected = 16'd0;					
									
				end
				
				13: begin
					// 0 - number = - number
					alu_op = 3'b010;
					alu_inputs = {16'd0, 16'd200};
					alu_expected = -16'd200;

				end
				
				14: begin
					// 0 - min = min
					alu_op = 3'b010;
					alu_inputs = {16'd0, 16'd32768};
					alu_expected = -16'd32768;		
		
				end
				
				15: begin
					// minus minus = pos
					alu_op = 3'b010;
					alu_inputs = {16'd5, -16'd2};
					alu_expected = 16'd7;		
				
				end
				
				// SHIFTING
				
				16: begin
					// shifts by 0
					alu_op = 3'b011;
					alu_inputs = {16'd0, 16'd100};
					alu_expected = 16'd100;	
				
				end
				
				17: begin
					// shifts by 1
					alu_op = 3'b011;
					alu_inputs = {16'd1, -16'd16};
					alu_expected = -16'd8;	
				
				end
				
				
				18: begin
					// -1 shifts 4 = -1
					alu_op = 3'b011;
					alu_inputs = {16'd4, -16'd1};
					alu_expected = -16'd1;	
				
				end
				
				19: begin
					// 1 shifts -15 = min
					alu_op = 3'b011;
					alu_inputs = {-16'd15, 16'd1};
					alu_expected = -16'd32768;	
				
				end
				
				20: begin
					// shifts 4 by 3 to make 0
					alu_op = 3'b011;
					alu_inputs = {16'd3, 16'd4};
					alu_expected = 16'd0;	
				
				end
				
				21: begin
					//check irrelevant OPcodes
					alu_op = 3'b100;
					alu_inputs = {16'd3, 16'd4};
					alu_expected = 16'd0;	
				
				end
				
				22: begin
					//check irrelevant OPcodes
					alu_op = 3'b111;
					alu_inputs = {16'd3, 16'd4};
					alu_expected = 16'd0;	
		
				end
			endcase
			
			#8;
			
			if(alu_out !== alu_expected) begin
				$display("ALU error at test %0d: Op=%b, input_A=%0d, input_B=%0d    Output: %0d, Expected: %0d", count, alu_op, $signed(alu_inputs[31:16]), $signed(alu_inputs[15:0]), $signed(alu_inputs[15:0]), $signed(alu_out), $signed(alu_expected));
				
				errors = errors + 1;
			
			end
		end
		else begin
			#8;
		end
		
		#1;
	end
	
	// Multiplexer testcases
	always begin
		#1
		if (count == 11) begin
			if (count < 10) begin
				sel = count;
				mult_expected = count;
			end
			
			else if (count == 11) begin
				sel = 16'd11;
				mult_expected = 16'd0;
			end
			
			#8
			
			if (mult_out !== mult_expected) begin
				$display("Multiplexer error: Sel: %d, Output: %d, Expected: %d", sel, mult_out, mult_expected);
				errors = errors + 1;
			end
		end
		
		else begin
			#8;
		end
		
		#1;
	end
	
	// Register testcases
	always begin
		#1
		if (count < 6) begin
			case (count)
				0: begin
					reg_rst = 1;
					reg_data_in16 <= {16{1'b1}};
					reg_data_in32 <= {32{1'b1}};
					reg_expected16 <= {16{1'b0}};
					reg_expected32 <= {32{1'b0}};
				end
				
				1: begin
					reg_rst <= 0;
					r_in <= 1;
					reg_data_in16 <= {16{1'b1}};
					reg_data_in32 <= {32{1'b1}};
					reg_expected16 <= {16{1'b1}};
					reg_expected32 <= {32{1'b1}};
				end
				
				2: begin
					reg_data_in16 <= {16'd412};
					reg_data_in32 <= {32'd200000};
					reg_expected16 <= {32'd412};
					reg_expected32 <= {32'd200000};
				end
				
				3: begin
					reg_data_in16 <= {16'd32382732636}; // Arbitrary number too big for 16
					reg_data_in32 <= {32'd99123013812}; // Arbitrary number too big for 32
					reg_expected16 <= {16{1'b1}};
					reg_expected32 <= {32{1'b1}};
				end
			endcase
			
			if (reg_out16 !== reg_expected16) begin
				$display("16 bit register error: Inputs: %d, Output: %d, Expected state: %d", reg_data_in16, reg_out16, reg_expected16);
				errors = errors + 1;
			end
			
			else if (reg_out32 !== reg_expected32) begin
				$display("32 bit register error: Inputs: %d, Output: %d, Expected state: %d", reg_data_in32, reg_out32, reg_expected32);
				errors = errors + 1;
			end
			
			#8;
		end
		
		else begin
			#8;
		end
		
		#1;
	end
	
	
	always begin // Need to increment count, having it in each would screw it up
		#10
		count = count + 1;
	end
endmodule