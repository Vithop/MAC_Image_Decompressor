`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

module Milestone1 (
	   input  	logic	      	Clock,
	   input  	logic	      	Resetn,
	   input  	logic	      	Enable,
	 
	   // input  	logic	[17:0]	SRAM_base_address,
	   output 	logic	[17:0]	SRAM_address,
	   input  	logic	[15:0]	SRAM_read_data,
	   output 	logic	[15:0]	SRAM_write_data,
	   output 	logic 			SRAM_we_n,

);

Milestone1_state_type M1_state;

//address base values const
parameter intit_Y_address = 18'd0,
		intit_U_address = 18'd38400,
		intit_V_address = 18'd57600
		init_RGB_address = 146944;

// For Multiplier
logic [31:0] result_a;
logic [31:0] result_b;
logic [31:0] result_c;

logic [31:0] Op1;
logic [31:0] Op2;

logic [31:0] Op3;
logic [31:0] Op4;

logic [31:0] Op5;
logic [31:0] Op6;

//For Calculating YUV values
logic [16:0] J; // Pixel Position
logic [15:0] Y;
logic [15:0] U;
logic [15:0] V;

logic [15:0] U_prime_even;
logic [15:0] U_prime_odd;
// U/V_buffer[5] is (j+5)/2
logic [15:0] U_buffer [5:0]
logic [15:0] V_prime_even;
logic [15:0] V_prime_odd;
logic [15:0] V_buffer [5:0]
logic read_UV_flag;
logic [15:0] Y_prime [1:0]

//RGB Values
logic [7:0] R;
logic [7:0] G;
logic [7:0] B;
logic [7:0] B_buffer;

assign result_a = [31:0](Op1 * Op2) ;
assign result_b = [31:0](Op3 * Op4) ;
assign result_c = [31:0](Op5 * Op6) ;


always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		// reset
		SRAM_we_n <= 1'b0;
		SRAM_write_data <= 16'd0;
		SRAM_address <= 16'd0;
		read_UV_flag = 1'b0;
		J <= 16'd0;
		M1_state <= S_M1_IDLE;
	end	else begin
		case(M1_state)
			S_M1_IDLE:begin
				if (Enable == 1'b1) begin
					M1_state <= S_M1_LI_FIRST_READ_V;
					SRAM_address <= intit_V_address;
				end
				
			end
			S_M1_LI_FIRST_READ_V:begin
				SRAM_address = intit_U_address;
				SRAM_we_n <= 1'b0;
				J <= 16'd0;
				M1_state <= S_M1_LI_FIRST_READ_U;

			end
			S_M1_LI_FIRST_READ_U:begin
				SRAM_address = intit_Y_address;
				J <= 16'd0;
				M1_state <= S_M1_LI_FIRST_READ_Y;
			end
			S_M1_LI_FIRST_READ_Y:begin
				V <= V + 1'd1;
				SRAM_address = intit_V_address + V;

				J <= 16'd0;
				M1_state <= S_M1_LI_V1;
			end
			S_M1_LI_V1:begin
				U <= U + 1'd1;
				SRAM_address = intit_U_address + U;

				V_prime_even <= [15:8]SRAM_read_data;
				V_buffer[5] <= [7:0]SRAM_read_data;
				V_buffer[4] <= V_prime_even;
				V_buffer[3] <= V_prime_even;
				V_buffer[2] <= V_prime_even;
				V_buffer[1] <= V_prime_even;
				V_buffer[0] <= V_prime_even;
				M1_state <= S_M1_LI_U1;
			end
			S_M1_LI_U1:begin
				U_prime_even <= [15:8]SRAM_read_data;
				U_buffer[5] <= [7:0]SRAM_read_data;
				U_buffer[4] <= U_prime_even;
				U_buffer[3] <= U_prime_even;
				U_buffer[2] <= U_prime_even;
				U_buffer[1] <= U_prime_even;
				U_buffer[0] <= U_prime_even;
				M1_state <= S_M1_LI_Y1;
			end
			S_M1_LI_Y1	:begin
				Y_prime <= SRAM_read_data;
				M1_state <= S_M1_LI_CALC_V;
			end
			S_M1_LI_CALC_V:begin
				V_buffer[5] <= [7:0]SRAM_read_data;
				V_buffer[4] <= [15:8]SRAM_read_data;
				V_buffer[3] <= V_buffer[5];
				V_buffer[2] <= V_buffer[4];
				V_buffer[1] <= V_buffer[3];
				V_buffer[0] <= V_buffer[2];
				// vithuran is a slow poke and so this
				//is a placehorder for a calculation
				M1_state <= S_M1_LI_CALC_U;
			end
			S_M1_LI_CALC_U:begin
				U_buffer[5] <= [7:0]SRAM_read_data;
				U_buffer[4] <= [15:8]SRAM_read_data;
				U_buffer[3] <= U_buffer[5];
				U_buffer[2] <= U_buffer[4];
				U_buffer[1] <= U_buffer[3];
				U_buffer[0] <= U_buffer[2];
				// vithuran is a slow poke and so this
				//is a placehorder for a calculation
				M1_state <= S_M1_CALC_FIRST_RB;
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

endmodule


