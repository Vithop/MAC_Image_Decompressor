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
		init_PreIDCT_address = 18'd76800;


logic [8:0] read_address, write_address;
logic [7:0] write_data_b [1:0];
logic write_enable_b [1:0];
logic [7:0] read_data_a [1:0];
logic [7:0] read_data_b [1:0];
// Instantiate RAM0
dual_port_RAM0 dual_port_RAM_inst0 (
	.address_a ( read_address ),
	.address_b ( write_address ),
	.clock ( CLOCK_I ),
	.data_a ( 8'h00 ),
	.data_b ( write_data_b[0] ),
	.wren_a ( 1'b0 ),
	.wren_b ( write_enable_b[0] ),
	.q_a ( read_data_a[0] ),
	.q_b ( read_data_b[0] )
	);


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
		
	end
	else if (Enable) begin
		case(M2_state)
		S_M2_IDLE: begin
			
		end
		default: M2_state <= S_M2_IDLE;
	end
end


