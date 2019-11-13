`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

module Milestone1 (
	   input  	logic	      	Clock,
	   input  	logic	      	Resetn,
	   input  	logic	      	Enable,
	 
	   input  	logic	[17:0]	SRAM_base_address,
	   output 	logic	[17:0]	SRAM_address,
	   input  	logic	[15:0]	SRAM_read_data,
	   output 	logic	[15:0]	SRAM_write_data,
	   output 	logic 			SRAM_we_n,

);

Milestone1_state_type M1_state;
// For Multiplier
logic [31:0] result_a;
logic [31:0] in_b;	
logic [31:0] in_c;
logic [31:0] result_d;
logic [31:0] in_e;
logic [31:0] in_f;
logic [31:0] result_g;
logic [31:0] in_h;
logic [31:0] in_i;

//For Calculating YUV values
logic [16:0] J; // Pixel Position
logic [15:0] Y;
logic [15:0] U;
logic [15:0] V;

logic [15:0] U_prime;
logic [15:0] U_buffer [5:0]
logic [15:0] V_prime;
logic [15:0] V_buffer [5:0]
logic read_UV;

//RGB Values
logic [7:0] R;
logic [7:0] G;
logic [7:0] B;
logic [7:0] B_buffer;
always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		// reset
		SRAM_we_n <= 1'b1;
		SRAM_write_data <= 16'd0;
		SRAM_address <= 18'd0;
		read_UV = 1'b1;
		J <= 16'd0;
	end	else begin
		case(M1_state)
			S_M1_IDLE:begin
				if (Enable == 1'b1) begin
					M1_state <= nextstate;
				end
				
			end
			S_M1_CALC_V_PRIME:begin
				M1_state <= S_M1_CALC_U_PRIME;
			end
			S_M1_CALC_U_PRIME:begin
				M1_state <= S_M1_CALC_FIRST_RB;
			end
			S_M1_CALC_FIRST_RB:begin
				SRAM_we_n <= 0;
				M1_state <= S_M1_CALC_FIRST_G;
			end
			S_M1_CALC_FIRST_G:begin
				M1_state <= S_M1_CALC_SECOND_RB;
			end
			S_M1_CALC_SECOND_RB:begin
				M1_state <= S_M1_CALC_SECOND_G;
			end
			S_M1_CALC_SECOND_G:begin
				M1_state <= ;
			end
			default: M1_state <= S_M1_IDLE;
		endcase
	end
end
multiplier multiplier_unit(
	.a(result_a),
	.b(in_b;),
	.c(in_c),
	.d(result_d),
	.e(in_e),
	.f(in_f),
	.g(result_g),
	.h(in_h),
	.i(in_i)
);