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

longint Op1;
longint Op2;

longint Op3;
longint Op4;

longint Op5;
longint Op6;

//For Calculating YUUV_countvalues
logic [16:0] RGB_count; // Pixel Position
logic [15:0] Y_count;
logic [15:0] UV_count;

logic [7:0] U_odd;
logic [31:0] U_prime;
logic [7:0] U_buffer [5:0]	// U/V_buffer[5] is (RGB_count+5)/2

logic [7:0] V_odd;
logic [31:0] V_prime;
logic [7:0] V_buffer [5:0]

logic [7:0] Y [1:0]

logic read_UV_flag;

//RGB Values
logic [7:0] R_even;
logic [7:0] R_odd;
logic [7:0] G_even;
logic [7:0] G_odd;
logic [7:0] B_even;
logic [7:0] B_odd;
logic [7:0] B_buffer;

assign result_a = [31:0](Op1 * Op2) ;
assign result_b = [31:0](Op3 * Op4) ;
assign result_c = [31:0](Op5 * Op6) ;

always_comb begin
	if(M1_state == S_M1_LI_CALC_V || M1_state == S_M1_CALC_V_PRIME)begin
		Op1 = V_buffer[5] + V_buffer[0];
		Op2 = 31'd21;
		Op3 = V_buffer[4] + V_buffer[1];
		Op4 = 31'd52;
		Op5 = V_buffer[3] + V_buffer[2];
		Op6 = 31'd159;
		//V_prime = $signed(result_a - result_b + result_c + 31'd128)>>>8;
	end else if (M1_state == S_M1_LI_CALC_U || M1_state == S_M1_CALC_U_PRIME) begin
		Op1 = U_buffer[5] + U_buffer[0];
		Op2 = 31'd21;
		Op3 = U_buffer[4] + U_buffer[1];
		Op4 = 31'd52;
		Op5 = U_buffer[3] + U_buffer[2];
		Op6 = 31'd159;
		//U_prime = $signed(result_a - result_b + result_c + 31'd128)>>>8;
	end else if (M1_state == S_M1_CALC_FIRST_RB) begin
		Op1 = Y[1] - 31'd1;
		Op2 = 31'd76284;
		Op3 = U_buffer[2] - 31'd128
		Op4 = 31'd132251;
		Op5 = V_buffer[2] - 31'd128;
		Op6 = 31'd104595;
	end else if (M1_state == S_M1_CALC_SECOND_RB) begin
		Op1 = Y[0] - 31'd16;
		Op2 = 31'd76284;
		Op3 = U_prime - 31'd128
		Op4 = 31'd132251;
		Op5 = V_prime - 31'd128;
		Op6 = 31'd104595;
	end else if (M1_state == S_M1_CALC_FIRST_G) begin
		Op1 = Y[1] - 31'd1;
		Op2 = 31'd76284;
		Op3 = U_buffer[2] - 31'd128
		Op4 = 31'd25624;
		Op5 = V_buffer[2] - 31'd128;
		Op6 = 31'd53281;
	end else if (M1_state == S_M1_CALC_SECOND_G) begin
		Op1 = Y[0] - 31'd16;
		Op2 = 31'd76284;
		Op3 = U_prime - 31'd128
		Op4 = 31'd25624;
		Op5 = V_prime - 31'd128;
		Op6 = 31'd53281;
	end else begin
		Op1 = 0;
		Op2 = 0;
		Op3 = 0;
		Op4 = 0;
		Op5 = 0;
		Op6 = 0;
	end
	// if (M1_state == S_M1_CALC_FIRST_RB) begin
	// 	R_even = result_a + result_b;
	// 	B_even = result_a + result_c;
	// end else if (M1_state == S_M1_CALC_SECOND_RB) 
	// 	R_odd = result_a + result_b;
	// 	B_odd = result_a + result_c;
	// end else if (M1_state == S_M1_CALC_FIRST_G) begin
	// 	G_odd  = result_a - result_b - result_c;
		
	// end
end

always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		// reset
		SRAM_we_n <= 1'b0;
		SRAM_write_data <= 16'd0;
		SRAM_address <= 16'd0;
		read_UV_flag = 1'b1;
		RGB_count <= 16'd0;
		M1_state <= S_M1_IDLE;
	end	else begin
		case(M1_state)
			S_M1_IDLE:begin
				if (Enable == 1'b1) begin
					M1_state <= S_M1_LI_FIRST_READ_V;
					SRAM_address <= intit_V_address;
				end
				
			end
			//****START OF LEAD IN CYCLES
			S_M1_LI_FIRST_READ_V:begin
				SRAM_address = intit_U_address;
				SRAM_we_n <= 1'b0;
				M1_state <= S_M1_LI_FIRST_READ_U;

			end
			S_M1_LI_FIRST_READ_U:begin
				SRAM_address = intit_Y_address;
				M1_state <= S_M1_LI_FIRST_READ_Y;
			end
			S_M1_LI_FIRST_READ_Y:begin
				UV_count <= UV_count + 1'd1;
				SRAM_address = intit_V_address + V;

				M1_state <= S_M1_LI_V1;
			end
			S_M1_LI_V1:begin
				SRAM_address = intit_U_address + UV_count;

				V_buffer[5] <= [7:0]SRAM_read_data;
				V_buffer[4] <= [15:8]SRAM_read_data;
				V_buffer[3] <= V_buffer[4];
				V_buffer[2] <= V_buffer[4];
				V_buffer[1] <= V_buffer[4];
				V_buffer[0] <= V_buffer[4];
				M1_state <= S_M1_LI_U1;
			end
			S_M1_LI_U1:begin
				U_buffer[5] <= [7:0]SRAM_read_data;
				U_buffer[4] <= [15:8]SRAM_read_data;
				U_buffer[3] <= U_buffer[4];
				U_buffer[2] <= U_buffer[4];
				U_buffer[1] <= U_buffer[4];
				U_buffer[0] <= U_buffer[4];
				M1_state <= S_M1_LI_Y1;
			end
			S_M1_LI_Y1:begin
				Y <= SRAM_read_data;
				M1_state <= S_M1_LI_CALC_V;
			end
			S_M1_LI_CALC_V:begin
				V_buffer[0] <= V_buffer[2];
				V_buffer[1] <= V_buffer[3];
				V_buffer[3] <= V_buffer[5];
				V_buffer[4] <= [15:8]SRAM_read_data;
				V_buffer[2] <= V_buffer[4];
				V_buffer[5] <= [7:0]SRAM_read_data;
				M1_state <= S_M1_LI_CALC_U;
			end
			S_M1_LI_CALC_U:begin
				U_buffer[0] <= U_buffer[2];
				U_buffer[1] <= U_buffer[3];
				U_buffer[2] <= U_buffer[4];
				U_buffer[3] <= U_buffer[5];
				U_buffer[4] <= [15:8]SRAM_read_data;
				U_buffer[5] <= [7:0]SRAM_read_data;
				M1_state <= S_M1_CALC_FIRST_RB;
			end
			//****START OF REPEATING CYCLES
			S_M1_CALC_FIRST_RB:begin
				if(read_UV_flag == 1'b1) begin
					UV_count <= UV_count + 1'd1;
					SRAM_address = intit_V_address + UV_count;
				end else begin
					Y <= SRAM_read_data
				end

				U_prime <= (result_a + result_b + result_c) >>> 8;
				SRAM_we_n <= 1'b0;
				M1_state <= S_M1_CALC_FIRST_G;

			end
			S_M1_CALC_FIRST_G:begin
				if(read_UV_flag == 1'b1) begin
					SRAM_address = intit_U_address + UV_count;
				end
				R_even = (result_a + result_b) >>> 16;
				B_even = (result_a + result_c) >>> 16;

				M1_state <= S_M1_CALC_SECOND_RB;
			end
			S_M1_CALC_SECOND_RB:begin
				G_even  <= (result_a - result_b - result_c) >>> 16;
				M1_state <= S_M1_CALC_SECOND_G;

				if(read_UV_flag == 1'b1) begin
					Y_count <= Y_count + 1'd1;
					SRAM_we_n <= 1'b0;
					SRAM_address = intit_Y_address + Y_count;
				end else begin
					SRAM_write_data <= {R_even, G_even};
					SRAM_we_n <= 1'b1;
					SRAM_address <= init_RGB_address + RGB_count
					RGB_count <= RGB_count + 1'd1;
				end
			end
			S_M1_CALC_SECOND_G:begin
				R_odd = result_a + result_b;
				B_odd = result_a + result_c;
				SRAM_we_n <= 1'b1;
				SRAM_address <= init_RGB_address + RGB_count
				RGB_count <= RGB_count + 1'd1;
				M1_state <= S_M1_CALC_V_PRIME;

				if(read_UV_flag == 1'b1) begin
					SRAM_write_data <= {R_even, G_even};
				end else begin
					SRAM_write_data <= {B_even, R_odd};
				end

			end
			S_M1_CALC_V_PRIME:begin
				SRAM_we_n <= 1'b1;
				SRAM_address <= init_RGB_address + RGB_count
				RGB_count <= RGB_count + 1'd1;

				V_buffer[0] <= V_buffer[1];
				V_buffer[1] <= V_buffer[2];
				V_buffer[2] <= V_buffer[3];
				V_buffer[3] <= V_buffer[4];
				V_buffer[4] <= V_buffer[5]
				
				M1_state <= S_M1_CALC_U_PRIME;

				if(read_UV_flag == 1'b1) begin
					SRAM_write_data <= {B_even, R_odd};
					V_odd <= [7:0]SRAM_read_data;
					V_buffer[5] <= [15:8]SRAM_read_data;
				end else begin
					SRAM_write_data <= {G_odd, B_odd};
					V_buffer[5] <= V_odd;				
				end
			end
			S_M1_CALC_U_PRIME:begin
				U_buffer[0] <= U_buffer[1];
				U_buffer[1] <= U_buffer[2];
				U_buffer[2] <= U_buffer[3];
				U_buffer[3] <= U_buffer[4]
				U_buffer[4] <= U_buffer[5];

				read_UV_flag <= ~read_UV_flag;

				M1_state <= S_M1_CALC_FIRST_RB;

				if(read_UV_flag == 1'b1) begin
					SRAM_address <= init_RGB_address + RGB_count;
					RGB_count <= RGB_count + 1'd1;
					SRAM_we_n <= 1'b1;
					SRAM_write_data <= {G_odd, B_odd};
					U_odd <= [7:0]SRAM_read_data;
					U_buffer[5] <= [15:8]SRAM_read_data;
				end else begin
					U_buffer[5] <= U_odd;
					SRAM_we_n <= 1'b0;
				end
			end
			default: M1_state <= S_M1_IDLE;
		endcase
	end
end

endmodule


