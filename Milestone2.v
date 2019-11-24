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

Milestone2_state_type M2_FS_state;
Milestone2_state_type M2_WS_state;
Milestone2_state_type M2_C_state;

//address base values const
parameter intit_Y_address = 18'd0,
		intit_U_address = 18'd38400,
		intit_V_address = 18'd57600,
		init_PreIDCT_address = 18'd76800,
		init_T_address = 6'd64,
		init_S_address = 6'd00;


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


logic [6:0] DP_address0_a, DP_address0_b;
logic [31:0] write_data0_a;
logic [31:0] write_data0_b;
logic write_enable0_a;
logic write_enable0_b;
logic [31:0] read_data0_a;
logic [31:0] read_data0_b;
// Instantiate RAM0
dual_port_RAM0 dual_port_RAM_inst0 (
	.address_a ( DP_address0_a ),
	.address_b ( DP_address0_b ),
	.clock ( CLOCK_A_i ),
	.data_a ( write_data0_a ),
	.data_b ( write_data0_b ),
	.wren_a ( write_enable0_a ),
	.wren_b ( write_enable0_b ),
	.q_a ( read_data0_a ),
	.q_b ( read_data0_b )
);

logic [6:0] DP_address1_a, DP_address1_b;
logic [31:0] write_data1_a;
logic [31:0] write_data1_b;
logic write_enable1_a;
logic write_enable1_b;
logic [31:0] read_data1_a;
logic [31:0] read_data1_b;
dual_port_RAM1 dual_port_RAM_inst1 (
	.address_a ( DP_address1_a ),
	.address_b ( DP_address1_b ),
	.clock ( CLOCK_A_i ),
	.data_a ( write_data1_a ),
	.data_b ( write_data1_b ),
	.wren_a ( write_enable1_a ),
	.wren_b ( write_enable1_b ),
	.q_a ( read_data1_a ),
	.q_b ( read_data1_b )
	);

logic [17:0] next_row_preIDCT;
logic [17:0] next_row_postIDCT;
logic [3:0] preIDCT_i;
logic [3:0] preIDCT_j;
logic [17:0] block_index;
logic [17:0] row_address;
logic [6:0] FS_DP_address;
logic FS_DP_write_enable;
logic [17:0] FS_SRAM_address;
logic FS_done;


//Signals for Calculations
logic [6:0] CSCT_A0_read_address;
	// logic [6:0] read_address_A1;
logic [31:0] CSCT_A0_read_data;
	// logic [31:0] read_data_A1;
logic CSCT_A0_w_en;
	// logic write_enable_A1;

logic [6:0] CSCT_B_write_address;
logic [31:0] CSCT_B_write_data;
logic CSCT_B_w_en;

logic CS_done;
logic CT_done;

// General Matrix A that will represent S' or T
logic [3:0] A_i;
logic [3:0] A_j;
logic [15:0] matrix_A_row [7:0];
logic [7:0] matrix_A_val_0;
logic [7:0] matrix_A_val_1;
logic [6:0] last_read_address;
// logic [7:0] matrix_A_val_2;

// B will be the result matrix
logic [3:0] B_i;
logic [3:0] B_j;
logic [31:0] temp_B_val_0;
logic [31:0] temp_B_val_1;


// Writing to SRAM Logic
logic [17:0] YUV_block_address;
logic [2:0] YUV_i;
logic [2:0] YUV_j;
logic [17:0] YUV_row_address;
logic Reading_Y_flag;
logic[17:0] WS_SRAM_address;
logic[15:0] WS_SRAM_write_data;
// For Multiplier
logic [31:0] result_a;
logic [31:0] result_b;

longint Op1;
longint Op2;

longint Op3;
longint Op4;

assign next_row_preIDCT = (Reading_Y_flag) ? 18'd320 : 18'd160;
assign next_row_postIDCT = (Reading_Y_flag) ? 18'd160 : 18'd80;
assign Reading_Y_flag <= (block_index >= 18'd153600) ? 1'b0 : 1'b1;

assign temp_a = (Op1 * Op2);
assign temp_b = (Op3 * Op4);

assign result_a = {temp_a[31:0]};
assign result_b = {temp_b[31:0]};

assign matrix_A_val_0 = read_data0_a;
assign matrix_A_val_1 = read_data0_b;


always comb begin
	if(FS_done == 1'd1) begin

		SRAM_we_n <= 1'b0;
		SRAM_write_data <= WS_SRAM_write_data;
		SRAM_address <= WS_SRAM_address;

		DP_address0_a <= CSCT_A0_read_address;
		DP_address0_b <= ;// this is for vithu
		DP_address1_a <= CSCT_B_write_address;
		DP_address1_b <= 7'd0;// nobody

		CSCT_A0_read_data <= read_data0_a;
		// read_data_A1 <= read_data0_b;
		write_data0_a <= 32'd0;
		write_data1_a <= CSCT_B_write_data;

		write_enable0_a <= CSCT_A0_w_en;
		write_enable0_b <= ;// for vithu
		write_enable1_a <= CSCT_B_w_en;
		write_enable1_b <= 1'd0;// nobody

	end else begin 
		SRAM_we_n <= 1'b1;	
		SRAM_write_data <= 16'd0;
		SRAM_address <= FS_SRAM_address;

		DP_address0_a <= CSCT_B_write_address;
		DP_address0_b <= FS_DP_address; // this is for vithu
		DP_address1_a <= CSCT_A0_read_address;
		DP_address1_b <= ;// nobody

		CSCT_A0_read_data <= read_data1_a;
		// read_data0_a1 <= read_data1_b;
		write_data0_a <= CSCT_B_write_data;
		write_data1_a <= 32'd0;

		write_enable0_a <= CSCT_B_w_en;
		write_enable0_b <= FS_DP_write_enable; // this is for vithu
		write_enable1_a <= CSCT_A0_w_en;
		write_enable1_b <= //nobody
	end 
end

always comb begin
	if(M2_state == S_M2_CT_LI_read || S_M2_CT_LI_CALC_B_ROW)begin
		Op1 = matrix_A_row[7];
		Op2 = matrix_C_val0;
		Op3 = matrix_A_row[6];
		Op4 = matrix_C_val1;
	end else begin
		Op1 = 31'd0;
		Op2 = 31'd0;
		Op3 = 31'd0;
		Op4 = 31'd0;
	end
end


always @(posedge Clock or negedge Resetn) begin
	if(~Resetn) begin
		// reset
		FS_SRAM_address <= 16'd0;

		block_index <= init_PreIDCT_address;
		A_i <= 4'd0;
		A_j <= 4'd0;

		FS_DP_address <= 7'd0;
		write_data0_b <= 32'd0;
		FS_DP_write_enable <= 1'b0;
		FS_done <= 1'b0;
		M2_FS_state <= S_M2_IDLE;
	end else begin
		case(M2_FS_state)
			S_M2_FS_IDLE:begin
				if (Enable == 1'b1) begin
					preIDCT_i <= 4'd0;
					preIDCT_j <= 4'd0;
					FS_DP_write_enable <= 1'd0;
					FS_DP_address <=  6'd0;
					FS_done <= 1'b0;
					M2_state <= S_M2_FS_LI_READ_BLOCK_1;
				end 
				
			end
			S_M2_FS_LI_READ_BLOCK_1:begin
				FS_SRAM_address <= block_index + preIDCT_i + row_address;
				preIDCT_i <= preIDCT_i + 4'd1;
				M2_state <= S_M2_LI_READ_BLOCK_2
			end
			S_M2_FS_LI_READ_BLOCK_2:begin
				FS_SRAM_address <= block_index + preIDCT_i + row_address;
				preIDCT_i <= preIDCT_i + 4'd1;
				FS_DP_write_enable <= 1'b1;
 				write_data0_b <= SRAM_read_data;
				M2_state <= S_M2_READ_BLOCK_ROW;
			end
			S_M2_FS_READ_BLOCK_ROW:begin
				FS_SRAM_address <= block_index + preIDCT_i + row_address;
				FS_DP_address <= FS_DP_address + 1;
				write_data0_b <= SRAM_read_data;
				if (preIDCT_i < 4'd6) begin
				 	M2_state <= S_M2_READ_BLOCK_ROW;
				end else begin
				 	M2_state <= S_M2_LI_NEXT_ROW;
				end
			end
			S_M2_FS_NEXT_ROW:begin
				FS_DP_address <= FS_DP_address + 1;
				write_data0_b <= SRAM_read_data;
				preIDCT_i <= (preIDCT_i == 4'd7)? 4'd0: preIDCT_i + 4'd1;
				if (preIDCT_j < 4'd7) begin
				 	preIDCT_j <= preIDCT_j + 4'd1;
				 	row_address <= row_address + next_row_preIDCT
					M2_state <= S_M2_FS_READ_BLOCK_ROW; 
					FS_SRAM_address <= block_index + preIDCT_i + row_address;				 	
				end else begin
				 	preIDCT_j <= 4'd0;
					row_address <= 17'd0;
					M2_state <= S_M2_LO_READ_BLOCK1; 
				end
			end
			S_M2_FS_LO_READ_BLOCK0:begin
				M2_state <= S_M2_FS_LO_READ_BLOCK0;
				FS_DP_address <= FS_DP_address + 1;
				write_data0_b <= FS_SRAM_read_a;
			end
			S_M2_FS_LO_READ_BLOCK1:begin
				M2_state <= S_M2_FS_LO_READ_BLOCK2;
				FS_DP_address <= FS_DP_address + 1;
				write_data0_b <= SRAM_read_data;
			end
			S_M2_FS_LO_READ_BLOCK2:begin
				M2_state <= S_M2_FS_WAIT;
				FS_DP_address <= FS_DP_address + 1;
				write_data0_b <= SRAM_read_data;
				block_index <= (((block_index + 18'd8)%18'd320) == 0)? FS_SRAM_address + 18'd1:block_index + 18'd8;
				FS_done <= 1'b1;
			end
			S_M2_FS_WAIT:begin
				if (SRAM_address == 18'd230399) begin
					M2_FS_state <= S_M2_FS_IDLE;
				end else if (CT_done) begin
					preIDCT_i <= 4'd0;
					preIDCT_j <= 4'd0;
					FS_DP_write_enable <= 1'd0;
					FS_DP_address <=  6'd0;
					M2_state <= S_M2_FS_LI_READ_BLOCK_1;
					FS_done <= 1'b0;
				end else begin
					M2_FS_state <= S_M2_FS_WAIT;
				end
			end
			default: M2_FS_state <= S_M2_FS_IDLE;
		endcase
	end
end

always @(posedge Clock or negedge Resetn) begin
	if(~Resetn) begin
		// reset
		WS_SRAM_write_data <= 16'd0;
		WS_SRAM_address <= 16'd0;

		WS_DP_address <= 7'd0;
		WS_DP_write_enable <= 1'b0;

		YUV_block_address <= 17'd0;
		YUV_row_address <= 17'd0;
		YUV_buff <= 8'd0

		M2_WS_state <= S_M2_WS_WAIT;
	end else begin
		case(M2_WS_state)
			S_M2_WS_WAIT:begin
				M2_WS_state <= (CS_done)? S_M2_WS_START_READ: S_M2_WS_WAIT;
			end
			S_M2_WS_START_READ:begin
				WS_DP_address <= 7'd0;
				WS_DP_write_enable <= 1'b0;
				YUV_buff <= 8'd0
				YUV_row_address <= 17'd0;
				SRAM_we_n <= 1'd0;
				M2_WS_state <= S_M2_WS_LI_READ_S0;
			end
			S_M2_WS_LI_READ_S0:begin
				WS_DP_address <= WS_DP_address + 7'd1;
				M2_WS_state <= S_M2_WS_LI_READ_S1;
			end
			S_M2_WS_LI_READ_S1:begin
				WS_DP_address <= WS_DP_address + 7'd1;
				YUV_buff <= read_data1_a[7:0];
				M2_state <= (YUV_i < 3'd2)? S_M2_WS_WRITE_S_ROW : S_M2_WS_WRITE_S_NEXT_ROW;
			end
			S_M2_WS_WRITE_S_ROW:begin
				WS_DP_address <= WS_DP_address + 7'd1;
				WS_SRAM_address <= YUV_block_address + YUV_i + YUV_row_address
				WS_SRAM_write_data <= {YUV_buff, read_data1_b[7:0]};
				YUV_i = YUV_i + 3'd1;
				M2_state <= S_M2_WS_LI_READ_S1;
			end
			S_M2_WS_WRITE_S_NEXT_ROW: begin
				WS_DP_address <= WS_DP_address + 7'd1;
				WS_SRAM_address <= YUV_block_address + YUV_i + YUV_row_address
				WS_SRAM_write_data <= {read_data1_a[7:0], read_data1_b[7:0]};
				YUV_i <= (YUV_i == 3'd3)?3'd0: YUV_i + 3'd1;
				if (YUV_j < 3'd3) begin
					YUV_row_address <= YUV_row_address + next_row_postIDCT;
					YUV_j <= YUV_j + 3'd1;
					M2_state <= S_M2_WS_WRITE_S_ROW;
				end else begin
					M2_state <= S_M2_WS_WRITE_S_LO_0
				end
			end
			S_M2_WS_WRITE_S_LO_0:begin
				WS_SRAM_address <= YUV_block_address + YUV_i + YUV_row_address
				YUV_buff <= read_data1_a[7:0];
				M2_state <= S_M2_WS_WRITE_S_LO_1;
			end
			S_M2_WS_WRITE_S_LO_1:begin
				WS_SRAM_address <= YUV_block_address + YUV_i + YUV_row_address
				WS_SRAM_write_data <= {YUV_buff, read_data1_b[7:0]};
				YUV_i = YUV_i + 3'd1;
				YUV_block_address <= (((YUV_block_address+17'd4) % 17'd160) == 0)? SRAM_address+17'd1: YUV_block_address + 17'd4;
				M2_WS_state <= S_M2_WS_WAIT;
			end 
			default: M2_WS_state <= S_M2_WS_WAIT;
		endcase
	end
end

always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		// reset
		A_i <= 4'd0;
		A_j <= 4'd0;

		// SRAM_we_n <= 1'b1;
		// SRAM_write_data <= 16'd0;
		// SRAM_address <= 16'd0;
		// DP_address0_a <= 7'd0;
		// DP_address0_b <= 7'd0;
		// write_data0_a <= 32'd0;
		// write_data0_b <= 32'd0;
		// write_enable0_a <= 1'b0;
		// write_enable0_b <= 1'b0;

		// DP_address1_a <= 7'd0;
		// DP_address1_b <= 7'd0;
		// write_data1_a <= 32'd0;
		// write_data1_b <= 32'd0;
		// write_enable1_a <= 1'b0;
		// write_enable1_b <= 1'b0;

		CSCT_A0_read_address <= 7'd0;
		read_address_A1 <= 7'd1;
		
		
		write_enable0_a0 <= 1'b0;
		write_enable0_a1 <= 1'b0;

		CSCT_B_write_address <= 7'b0;
		write_data0_b <= 32'd0;
		write_enable0_b <= 1'b0;

		M2_state <= S_M2_IDLE;
	end	else begin
		case(M2_C_state)
			S_M2_CT_LI_init: begin
				write_enable0_a <= 1'd0;
				write_enable0_b <= 1'd0;
				DP_address0_a <=  6'd0;
				DP_address0_b <=  6'd1;
				A_i <= 4'd0;
				A_j <= 4'd0;
				B_i <= 4'd0;
				B_j <= 4'd0;
				Ic0 <= 3'd0;
				Jc0 <= 3'd0;
				Ic1 <= 3'd0;
				Jc1 <= 3'd1;
				M2_state <= S_M2_CT_LI_READ_DELAY_1;
			end
			S_M2_CT_LI_READ_DELAY_1: begin
				DP_address0_a <= DP_address0_a + 6'd2;
				DP_address0_b <= DP_address0_b + 6'd2;
				M2_state <= S_M2_CT_LI_READ_DELAY_2;
			end
			S_M2_CT_LI_READ_DELAY_2: begin
				DP_address0_a <= DP_address0_a + 6'd2;
				DP_address0_b <= DP_address0_b + 6'd2;
				M2_state <= S_M2_CT_LI_CALC;
			end
			S_M2_CT_LI_CALC: begin
				Jc0 <= Jc0 + 3'd2;
				Jc1 <= Jc1 + 3'd2;
				matrix_A_row[5] <= matrix_A_val[7];
				matrix_A_row[4] <= matrix_A_val[6];
				matrix_A_row[3] <= matrix_A_val[5];
				matrix_A_row[2] <= matrix_A_val[4];
				matrix_A_row[1] <= matrix_A_val[3];
				matrix_A_row[0] <= matrix_A_val[2];

				A_i <= A_i + 4'd2;
				temp_B_val_0 <= temp_B_val_0 + result_a + result_b;


				if (A_i < 4'd6) begin
					if (A_i > 4'd2) begin
						DP_address0_a <= DP_address0_a + 6'd2;
						DP_address0_b <= DP_address0_b + 6'd2;
					end 
					matrix_A_row[7] <= matrix_A_val_1
					matrix_A_row[6] <= matrix_A_val_0;
					M2_state <= S_M2_CT_LI_CALC;
				end else begin
					matrix_A_row[7] <= matrix_A_val[1];
					matrix_A_row[6] <= matrix_A_val[0];
					DP_address0_a <= init_T_address;
					last_read_address <= DP_address0_a
					A_i <= 3'd0;
					M2_state <= S_M2_CT_LI_CALC_B_ROW;
				end
			end
			S_M2_CT_LI_CALC_B_ROW: begin
				Jc0 <= Jc0 + 3'd2;
				Jc1 <= Jc1 + 3'd2;
				matrix_A_row[7] <= matrix_A_val[1];
				matrix_A_row[6] <= matrix_A_val[0];
				matrix_A_row[5] <= matrix_A_val[7];
				matrix_A_row[4] <= matrix_A_val[6];
				matrix_A_row[3] <= matrix_A_val[5];
				matrix_A_row[2] <= matrix_A_val[4];
				matrix_A_row[1] <= matrix_A_val[3];
				matrix_A_row[0] <= matrix_A_val[2];
				
				if(B_j < 4'd7 && A_i < 4'd6) begin
					if(A_i > 4'd0) begin
						A_i <= A_i + 4'd2;
						temp_B_val_0 <= temp_B_val_0 + result_a + result_b;
						write_enable0_a <= 1'b0;
					end else begin
						if(B_j == 4'd7 && A_i > 4'd2) begin
							DP_address0_a <= DP_address0_a + 6'd2;
							DP_address0_b <= DP_address0_b + 6'd2;
						end
					// Use Second DPRAM for writing calculation results to
						write_enable1_a <= 1'b1;
						DP_address1_a <= B_j == 4'd0 ? DP_address0_a : DP_address0_a + 6'd8 + B_i;;
						write_data1_a <= temp_B_val_0;
						temp_B_val_0 <= result_a + result_b;
						// B_i <= 3'd0;
						B_j <= B_j + 4'd1;
						Ic0 <= Ic0 + 3'd1;
						Jc0 <= 3'd0;
						Ic1 <= Ic1 + 3'd1;
						Jc1 <= 3'd1;
					end
					M2_state <= S_M2_CT_LI_CALC_B_ROW;
				end else begin
					write_enable0_a <= 1'b0;
					DP_address0_a <= last_read_address + 6'd2;
					DP_address0_b <= last_read_address + 6'd2;
					B_i <= B_i + 3'd1;
					A_j <= A_j + 3'd1;
					M2_state <= S_M2_CT_LI_READ_DELAY_1;
				end
			end
			default: M2_state <= S_M2_IDLE;
		endcase
	end
end


