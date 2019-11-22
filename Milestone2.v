/*
Made by Vithuran Sadagopan
*/


`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

module Milestone2 (
	   input  	logic	      	Clock,
	   input  	logic	      	Resetn,
	   input  	logic	      	Enable,
	 
	   // input  	logic	[17:0]	SRAM_base_address,
	   output 	logic	[17:0]	SRAM_address,
	   input  	logic	[15:0]	SRAM_read_data,
	   output 	logic	[15:0]	SRAM_write_data,
	   output 	logic 			SRAM_we_n

);

Milestone2_state_type M2_state;

//address base values const
parameter intit_Y_address = 18'd0,
		intit_U_address = 18'd38400,
		intit_V_address = 18'd57600,
		next_row_preIDCT = 18'd320,
		next_row_postIDCT = 18'd160,
		init_PreIDCT_address = 18'd76800;

logic [2:0] Ic0, Jc0;
int matrix_c_val0;
get_c_values get_c_values_inst0(
	.i(Ic0),
	.j(Jc0),
	.C_values(matrix_c_val0),
	);
logic [2:0] Ic1, Jc1;
int matrix_c_val1;
get_c_values get_c_values_inst1(
	.i(Ic1),
	.j(Jc1),
	.C_values(matrix_c_val1),
	);


logic [6:0] DP_address_a, DP_address_b;
logic [31:0] write_data_a;
logic [31:0] write_data_b;
logic write_enable_a;
logic write_enable_b;
logic [31:0] read_data_a [1:0];
logic [31:0] read_data_b [1:0];
// Instantiate RAM0
dual_port_RAM0 dual_port_RAM_inst0 (
	.address_a ( DP_address_a ),
	.address_b ( DP_address_b ),
	.clock ( CLOCK_A_i ),
	.data_a ( write_data_a ),
	.data_b ( write_data_b ),
	.wren_a ( write_enable_a ),
	.wren_b ( write_enable_b ),
	.q_a ( read_data_a[0] ),
	.q_b ( read_data_b[0] )
);

logic [6:0] DP_address2_a, DP_address2_b;
logic [31:0] write_data2_a;
logic [31:0] write_data2_b;
logic write_enable2_a;
logic write_enable2_b;
logic [7:0] read_data2_a [1:0];
logic [7:0] read_data2_b [1:0];
dual_port_RAM1 dual_port_RAM_inst1 (
	.address_a ( DP_address2_a ),
	.address_b ( DP_address2_b ),
	.clock ( CLOCK_A_i ),
	.data_a ( write_data2_a ),
	.data_b ( write_data2_b ),
	.wren_a ( write_enable2_a ),
	.wren_b ( write_enable2_b ),
	.q_a ( read_data2_a ),
	.q_b ( read_data2_b )
	);

logic [2:0] A_i;
logic [2:0] A_j;
logic [17:0] block_index;
logic [17:0] row_address;

// General Matrix A that will represent S' or T
logic [15:0] matrix_A_row [7:0];
logic [7:0] matrix_A_val;
// logic [7:0] matrix_A_val_2;

// B will be the result matrix
logic [2:0] B_i;
logic [2:0] B_j;
logic [31:0] temp_B_val_0;
logic [31:0] temp_B_val_1;


// For Multiplier
logic [31:0] result_a;
logic [31:0] result_b;

longint Op1;
longint Op2;

longint Op3;
longint Op4;


assign temp_a = (Op1 * Op2);
assign temp_b = (Op3 * Op4);

assign result_a = {temp_a[31:0]};
assign result_b = {temp_b[31:0]};
always comb begin
	if(M2_state == S_M2_READ_BLOCK_ROW)begin
		Op1 = matrix_A_row[0];
		Op2 = matrix_C_val0;
		Op3 = matrix_A_row[0];
		Op4 = matrix_C_val1;
	end else if (M2_state == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M2_state == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M2_state == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M2_state == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M2_state == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else begin
		Op1 = 31'd0;
		Op2 = 31'd0;
		Op3 = 31'd0;
		Op4 = 31'd0;
	end
end


always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		// reset
		SRAM_we_n <= 1'b1;
		SRAM_write_data <= 16'd0;
		SRAM_address <= 16'd0;
		block_index <= init_PreIDCT_address;
		A_i <= 3'd0;
		A_j <= 3'd0;


		DP_address_a <= 7'd0;
		DP_address_b <= 7'd0;
		write_data_a <= 32'd0;
		write_data_b <= 32'd0;
		write_enable_a <= 1'b0;
		write_enable_b <= 1'b0;
		DP_address2_a <= 7'd0;
		DP_address2_b <= 7'd0;
		write_data2_a <= 32'd0;
		write_data2_b <= 32'd0;
		write_enable2_a <= 1'b0;
		write_enable2_b <= 1'b0;

		M2_state <= S_M2_IDLE;
	end
	else 
		case(M2_state)
			S_M2_IDLE: begin
				if (Enable == 1'b1) begin
					SRAM_we_n <= 1'b1;
					SRAM_write_data <= 16'd0;
					SRAM_address <= init_PreIDCT_address;
					block_index <= init_PreIDCT_address;
					row_address <= 17'd0;
					A_i <= 3'd1;
					A_j <= 3'd1;
					M2_state <= S_M2_LI_READ_BLOCK1_1;
				end
			end 
			S_M2_LI_READ_BLOCK1_1:begin
				 SRAM_address <= block_index + A_i + row_address;
				 A_i <= A_i + 3'd1;
				 M2_state <= S_M2_LI_READ_BLOCK1_2
			end
			S_M2_LI_READ_BLOCK1_2:begin
				 SRAM_address <= block_index + A_i + row_address;
				 A_i <= A_i + 3'd1;
				 M2_state <= S_M2_READ_BLOCK_ROW;
			end
			S_M2_READ_BLOCK_ROW:begin
				 SRAM_address <= block_index + A_i + row_address;
				 if (A_i < 3'd6) begin
				 	M2_state <= S_M2_READ_BLOCK_ROW;
				 end else begin
				 	M2_state <= S_M2_LI_NEXT_ROW;
				 end
			end
			S_M2_NEXT_ROW:begin
				if (SRAM_address == 17'd230399) begin
 					M2_state <= S_M2_LO_READ_BLOCK0;
				end else begin
					SRAM_address <= block_index + A_i + row_address;
				 	M2_state <= S_M2_READ_BLOCK_ROW;			 	
				end
				if (A_i == 3'd7) begin
				 	A_i <= 3'd0;
				end else begin
					A_i <= A_i + 3'd1;
				end
				if (A_j < 3'd7) begin
				 	A_j <= A_j + 3'd1;
				 	row_address <= row_address + 17'd320
				 end else begin
				 	A_j <= 3'd0;
					row_address <= 17'd0;
				 	if(((block_index + 17'd8)%17'd320) == 0)begin
				 		block_index <= block_index + 17'd2248;
				 	end else begin
				 		block_index <= block_index + 17'd8;				 		
				 	end
				 end
			end
			S_M2_CT_LI_READ_VAL1: begin
				SRAM_address <= block_index + A_i + row_address;
				 A_i <= A_i + 3'd1;
				 M2_state <= S_M2_LI_READ_BLOCK1_2
			end
			// A_i <= A_i + 3'd1;
			// 	matrix_A_row[0] <= matrix_A_val;
			// 	matrix_A_row[1] <= matrix_A_val[0];
			// 	matrix_A_row[2] <= matrix_A_val[1];
			// 	matrix_A_row[3] <= matrix_A_val[2];
			// 	matrix_A_row[4] <= matrix_A_val[3];
			// 	matrix_A_row[5] <= matrix_A_val[4];
			// 	matrix_A_row[6] <= matrix_A_val[5];
			// 	matrix_A_row[7] <= matrix_A_val[6];
				
			// 	temp_B_val_0 <= temp_B_val_0 + result_a;
			// 	temp_B_val_1 <= temp_B_val_1 + result_b;
			// S_M2_LO_READ_BLOCK0:begin
			// 	M2_state <= S_M2_LO_READ_BLOCK1;
			end
			S_M2_LO_READ_BLOCK1:begin
				M2_state <= S_M2_LO_READ_BLOCK2;
			end
			S_M2_LO_READ_BLOCK2:begin
				M2_state <= S_M2_IDLE;
			end
			default: M2_state <= S_M2_IDLE;
		endcase
end


