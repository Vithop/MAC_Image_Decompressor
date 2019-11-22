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


logic [8:0] DP_address_a, DP_address_b;
logic [7:0] write_data_b [1:0];
logic write_enable_a;
logic write_enable_b;
logic [7:0] read_data_a [1:0];
logic [7:0] read_data_b [1:0];
// Instantiate RAM0
dual_port_RAM0 dual_port_RAM_inst0 (
	.address_a ( DP_address_a ),
	.address_b ( DP_address_b ),
	.clock ( CLOCK_I ),
	.data_a ( 8'h00 ),
	.data_b ( 8'h00 ),
	.wren_a ( write_enable_a ),
	.wren_b ( write_enable_b ),
	.q_a ( read_data_a[0] ),
	.q_b ( read_data_b[0] )
);
// logic [8:0] DP_address2_a, DP_address2_b;
// logic [7:0] write_data_b [1:0];
// logic write_enable_a;
// logic write_enable_b;
// logic [7:0] read_data_a [1:0];
// logic [7:0] read_data_b [1:0];
// dual_port_RAM1 dual_port_RAM_inst1 (
// 	.address_a ( read_address1 ),
// 	.address_b ( write_address1 ),
// 	.clock ( CLOCK_I ),
// 	.data_a ( 8'h00 ),
// 	.data_b ( write_data_1[0] ),
// 	.wren_a ( 1'b0 ),
// 	.wren_b ( write_enable_1[0] ),
// 	.q_a ( read_data_1_a[0] ),
// 	.q_b ( read_data_1_b[0] )
// 	);

logic [2:0] i;
logic [2:0] j;
logic [17:0] block_index;
logic [17:0] row_address;

// General Matrix A that will represent S' or T
logic [15:0] matrix_A_row [7:0];
logic [7:0] matrix_A_val_1;
logic [7:0] matrix_A_val_2;
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
	if(M == )begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M == ) begin
		Op1 = ;
		Op2 = ;
		Op3 = ;
		Op4 = ;
	end else if (M == ) begin
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
		i <= 3'd0;
		j <= 3'd0;
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
					i <= 3'd1;
					j <= 3'd1;
					M2_state <= S_M2_LI_READ_BLOCK1_1;
				end
			end 
			S_M2_LI_READ_BLOCK1_1:begin
				 SRAM_address <= block_index + i + row_address;
				 i <= i + 3'd1;
				 M2_state <= S_M2_LI_READ_BLOCK1_2
			end
			S_M2_LI_READ_BLOCK1_2:begin
				 SRAM_address <= block_index + i + row_address;
				 i <= i + 3'd1;
				 M2_state <= S_M2_READ_BLOCK_ROW;
			end
			S_M2_READ_BLOCK_ROW:begin
				 SRAM_address <= block_index + i + row_address;
			 	i <= i + 3'd1;
				 if (i < 3'd6) begin
				 	M2_state <= S_M2_READ_BLOCK_ROW;
					matrix_A_row[7] <= SRAM_read_data[]
				 end else begin
				 	M2_state <= S_M2_LI_NEXT_ROW;
				 end
			end
			S_M2_NEXT_ROW:begin
				if (SRAM_address == 17'd230399) begin
 					M2_state <= S_M2_LO_READ_BLOCK0;
				end else begin
					SRAM_address <= block_index + i + row_address;
				 	M2_state <= S_M2_READ_BLOCK_ROW;			 	
				end
				if (i == 3'd7) begin
				 	i <= 3'd0;
				end else begin
					i <= i + 3'd1;
				end
				if (j < 3'd7) begin
				 	j <= j + 3'd1;
				 	row_address <= row_address + 17'd320
				 end else begin
				 	j <= 3'd0;
					row_address <= 17'd0;
				 	if(((block_index + 17'd8)%17'd320) == 0)begin
				 		block_index <= block_index + 17'd2248;
				 	end else begin
				 		block_index <= block_index + 17'd8;				 		
				 	end
				 end
			end
			S_M2_LO_READ_BLOCK0:begin
				M2_state <= S_M2_LO_READ_BLOCK1;
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


