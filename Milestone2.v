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

Milestone2_FS_state_type M2_FS_state;
Milestone2_WS_state_type M2_WS_state;
Milestone2_CTCS_state_type M2_CTCS_state;

//address base values const
parameter intit_Y_address = 18'd0,
		intit_U_address = 18'd38400,
		intit_V_address = 18'd57600,
		init_PreIDCT_address = 18'd76800,
		init_T_address = 6'd64,
		init_S_address = 6'd00;


logic [2:0] Ic0, Jc0;
int matrix_C_val0;
get_c_values get_c_values_inst0(
	.i(Ic0),
	.j(Jc0),
	.C_values(matrix_C_val0)
	);
logic [2:0] Ic1, Jc1;
int matrix_C_val1;
get_c_values get_c_values_inst1(
	.i(Ic1),
	.j(Jc1),
	.C_values(matrix_C_val1)
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
	.clock ( Clock ),
	.data_a ( write_data0_a ),
	.data_b ( write_data0_b ),
	.wren_a ( write_enable0_a ),
	.wren_b ( write_enable0_b ),
	.q_a ( read_data0_a ),
	.q_b ( read_data0_b )
);

logic [6:0] DP_address1_a, DP_address1_b;
logic [31:0] write_data1_a;
//logic [31:0] write_data1_b; // not used
logic write_enable1_a;
logic write_enable1_b;
logic [31:0] read_data1_a;
logic [31:0] read_data1_b;
dual_port_RAM1 dual_port_RAM_inst1 (
	.address_a ( DP_address1_a ),
	.address_b ( DP_address1_b ),
	.clock ( Clock ),
	.data_a ( write_data1_a ),
	.data_b ( 31'b0 ),
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
logic [6:0] CTCS_A0_read_address;
logic [31:0] CTCS_A0_read_data;
logic CTCS_A0_w_en;

logic [6:0] CTCS_B_write_address;
logic [6:0] CTCS_B_write_init_address;
logic [31:0] CTCS_B_write_data;
logic CTCS_B_w_en;

logic CTCS_LeadINFLAG;
logic CS_done;
logic CT_done;
logic CS_start;
logic CT_start;

	// General Matrix A that will represent S' or T
logic [3:0] A_i;
logic [3:0] A_j;
logic [31:0] matrix_A_row [7:0];
logic [31:0] nxt_matrix_A_row [7:0];
logic [6:0] last_read_address;
// logic [7:0] matrix_A_val_2;

	// B will be the result matrix
logic [3:0] B_i;
logic [3:0] B_j;
logic [31:0] temp_B_val_0;
logic [31:0] temp_B_val_1;


// Writing to SRAM Logic
logic [17:0] YUV_block_index;
logic [2:0] YUV_i;
logic [2:0] YUV_j;
logic [7:0] YUV_buff;
logic [17:0] YUV_row_address;
logic Reading_Y_flag;

logic [6:0] WS_DP_address;
logic WS_DP_write_enable;

logic WS_SRAM_we_n;
logic[17:0] WS_SRAM_address;
logic[15:0] WS_SRAM_write_data;
// For Multiplier
logic [63:0] temp_a;
logic [63:0] temp_b;
logic [31:0] result_a;
logic [31:0] result_b;

longint Op1;
longint Op2;

longint Op3;
longint Op4;



assign next_row_preIDCT = (Reading_Y_flag) ? 18'd320 : 18'd160;
assign next_row_postIDCT = (Reading_Y_flag) ? 18'd160 : 18'd80;
assign Reading_Y_flag = (block_index >= 18'd153600) ? 1'b0 : 1'b1;


always_comb begin
	if(FS_done == 1'd1) begin

		SRAM_we_n = WS_SRAM_we_n;
		SRAM_write_data = WS_SRAM_write_data;
		SRAM_address = WS_SRAM_address;

		DP_address0_a = CTCS_A0_read_address;
		DP_address0_b = WS_DP_address;// this is for vithu
		DP_address1_a = CTCS_B_write_address;
		DP_address1_b = CS_start ? CTCS_A0_read_address : 7'd0;// nobody :(

		CTCS_A0_read_data = (CS_start) ? read_data1_b : read_data0_a;
		write_data0_a = 32'd0;
		write_data1_a = CTCS_B_write_data;
		CTCS_B_write_init_address <= 7'd0;

		write_enable0_a = (CS_start) ? 1'd0 : CTCS_A0_w_en;
		write_enable0_b = WS_DP_write_enable;// for vithu
		write_enable1_a = CTCS_B_w_en;
		write_enable1_b = (CS_start) ? CTCS_A0_w_en : 1'd0;
	end else begin 
		SRAM_we_n = 1'b1;	
		SRAM_write_data = 16'd0;
		SRAM_address = FS_SRAM_address;

		DP_address0_a = CTCS_B_write_address;
		DP_address0_b = (CT_start) ? CTCS_A0_read_address : FS_DP_address; // this is for vithu
		DP_address1_a = CTCS_A0_read_address;
		DP_address1_b = 7'd0;// nobody :(

		CTCS_A0_read_data = (CT_start) ? read_data0_b : read_data1_a;
		write_data0_a = CTCS_B_write_data;
		write_data1_a = 32'd0;
		CTCS_B_write_init_address <= 7'd64;

		write_enable0_a = CTCS_B_w_en;
		write_enable0_b = (CT_start) ? CTCS_A0_w_en : FS_DP_write_enable; // this is for vithu
		write_enable1_a = (CT_start) ? CTCS_A0_w_en : 1'd0;
		write_enable1_b = 1'b0; //nobody :(
	end 
end

assign temp_a = (Op1 * Op2);
assign temp_b = (Op3 * Op4);
assign result_a = {temp_a[31:0]};
assign result_b = {temp_b[31:0]};

always_comb begin
	if(M2_CTCS_state == S_M2_CTCS_CALC_B_ROW || M2_CTCS_state == S_M2_CTCS_CALC_B_NEXT_ROW)begin
		Op1 = matrix_A_row[0];
		Op2 = matrix_C_val0;
		Op3 = matrix_A_row[1];
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
		row_address <= 18'd0;

		FS_DP_address <= 7'd0;
		write_data0_b <= 32'd0;
		FS_DP_write_enable <= 1'b0;
		FS_done <= 1'b0;
		M2_FS_state <= S_M2_FS_IDLE;
	end else begin
		case(M2_FS_state)
			S_M2_FS_IDLE:begin
				if (Enable == 1'b1) begin
					FS_done <= 1'b0;
					preIDCT_i <= 4'd1;
					preIDCT_j <= 4'd0;
					row_address <= 18'd0;
					block_index <= init_PreIDCT_address;
					FS_DP_write_enable <= 1'd0;
					FS_DP_address <=  6'd0;
					FS_SRAM_address <= block_index;
					M2_FS_state <= S_M2_FS_LI_READ_BLOCK_1;
				end 
				
			end
			S_M2_FS_LI_READ_BLOCK_1:begin
				FS_SRAM_address <= block_index + preIDCT_i + row_address;
				preIDCT_i <= preIDCT_i + 4'd1;
				M2_FS_state <= S_M2_FS_LI_READ_BLOCK_2;
			end
			S_M2_FS_LI_READ_BLOCK_2:begin
				FS_SRAM_address <= block_index + preIDCT_i + row_address;
				preIDCT_i <= preIDCT_i + 4'd1;
				FS_DP_write_enable <= 1'b1;
 				write_data0_b <= SRAM_read_data;
				M2_FS_state <= S_M2_FS_READ_BLOCK_ROW;
			end
			S_M2_FS_READ_BLOCK_ROW:begin
				FS_SRAM_address <= block_index + preIDCT_i + row_address;
				preIDCT_i <= preIDCT_i + 4'd1;
				FS_DP_address <= FS_DP_address + 6'd1;
				write_data0_b <= SRAM_read_data;
				if (preIDCT_i < 4'd6) begin
				 	M2_FS_state <= S_M2_FS_READ_BLOCK_ROW;
				end else begin
				 	M2_FS_state <= S_M2_FS_NEXT_ROW;
				end
			end
			S_M2_FS_NEXT_ROW:begin
				FS_DP_address <= FS_DP_address + 6'd1;
				write_data0_b <= SRAM_read_data;
				preIDCT_i <= (preIDCT_i == 4'd7)? 4'd0: preIDCT_i + 4'd1;
				FS_SRAM_address <= block_index + preIDCT_i + row_address;				 	
				if (preIDCT_j < 4'd7) begin
				 	preIDCT_j <= preIDCT_j + 4'd1;
				 	row_address <= row_address + next_row_preIDCT;
					M2_FS_state <= S_M2_FS_READ_BLOCK_ROW; 
				end else begin
				 	preIDCT_j <= 4'd0;
					row_address <= 17'd0;
					M2_FS_state <= S_M2_FS_LO_READ_BLOCK0; 
				end
			end
			S_M2_FS_LO_READ_BLOCK0:begin
				M2_FS_state <= S_M2_FS_LO_READ_BLOCK1;
				FS_DP_address <= FS_DP_address + 6'd1;
				write_data0_b <= SRAM_read_data;
			end
			S_M2_FS_LO_READ_BLOCK1:begin
				M2_FS_state <= S_M2_FS_LO_READ_BLOCK2;
				FS_DP_address <= FS_DP_address + 6'd1;
				write_data0_b <= SRAM_read_data;
			end
			S_M2_FS_LO_READ_BLOCK2:begin
				M2_FS_state <= (SRAM_address == 18'd230399)? S_M2_FS_DONE: S_M2_FS_WAIT;
				FS_DP_address <= FS_DP_address + 6'd1;
				write_data0_b <= SRAM_read_data;
				block_index <= (((block_index + 18'd8)%next_row_preIDCT) == 0)? FS_SRAM_address + 18'd1:block_index + 18'd8;
				FS_done <= 1'b1;
			end
			S_M2_FS_WAIT:begin
				if (CT_done) begin
					FS_done <= 1'b0;
					preIDCT_i <= 4'd1;
					preIDCT_j <= 4'd0;
					row_address <= 18'd0;
					FS_DP_write_enable <= 1'd0;
					FS_DP_address <=  6'd0;
					FS_SRAM_address <= block_index + preIDCT_i + row_address;
					M2_FS_state <= S_M2_FS_LI_READ_BLOCK_1;
				end else begin
					M2_FS_state <= S_M2_FS_WAIT;
				end
			end
			S_M2_FS_DONE:begin
				M2_FS_state <= (SRAM_address == 18'd76799) && (SRAM_we_n ==  1'b0) ? S_M2_FS_IDLE:S_M2_FS_DONE ;
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
		WS_SRAM_we_n <= 1'b1;

		WS_DP_address <= 7'd64;
		WS_DP_write_enable <= 1'b0;

		YUV_block_index <= 17'd0;
		YUV_row_address <= 17'd0;
		YUV_buff <= 8'd0;

		M2_WS_state <= S_M2_WS_WAIT;
	end else begin
		case(M2_WS_state)
			S_M2_WS_WAIT:begin
				if (CS_done && FS_done) begin
					M2_WS_state <= S_M2_WS_START_READ;
					YUV_i <= 0;
					YUV_j <= 0;
					YUV_row_address <= 0;
					WS_DP_address <= 7'd64;
				end 
			end
			S_M2_WS_START_READ:begin
				WS_DP_address <= 7'd64;
				WS_DP_write_enable <= 1'b0;
				YUV_buff <= 8'd0;
				YUV_row_address <= 17'd0;
				M2_WS_state <= S_M2_WS_LI_READ_S0;
			end
			S_M2_WS_LI_READ_S0:begin
				WS_DP_address <= WS_DP_address + 7'd1;
				M2_WS_state <= S_M2_WS_LI_READ_S1;
			end
			S_M2_WS_LI_READ_S1:begin
				WS_SRAM_we_n <= 1'b1;
				YUV_buff <= read_data1_a[7:0];
				WS_DP_address <= WS_DP_address + 7'd1;
				M2_WS_state <= (YUV_i < 3'd3)? S_M2_WS_WRITE_S_ROW : S_M2_WS_WRITE_S_NEXT_ROW;
			end
			S_M2_WS_WRITE_S_ROW:begin
				YUV_i = YUV_i + 3'd1;
				WS_SRAM_we_n <= 1'b0;
				WS_SRAM_address <= YUV_block_index + YUV_i + YUV_row_address;
				WS_SRAM_write_data <= {YUV_buff, read_data1_b[7:0]};
				WS_DP_address <= WS_DP_address + 7'd1;
				M2_WS_state <= S_M2_WS_LI_READ_S1;                                             
			end
			S_M2_WS_WRITE_S_NEXT_ROW: begin
				WS_DP_address <= WS_DP_address + 7'd1;
				WS_SRAM_we_n <= 1'b0;
				WS_SRAM_address <= YUV_block_index + YUV_i + YUV_row_address;
				WS_SRAM_write_data <= {read_data1_a[7:0], read_data1_b[7:0]};
				YUV_i <= (YUV_i == 3'd3)?3'd0: YUV_i + 3'd1;
				if (YUV_j < 3'd3) begin
					YUV_row_address <= YUV_row_address + next_row_postIDCT;
					YUV_j <= YUV_j + 3'd1;
					M2_WS_state <= S_M2_WS_WRITE_S_ROW;
				end else begin
					M2_WS_state <= S_M2_WS_WRITE_S_LO_0;
				end
			end
			S_M2_WS_WRITE_S_LO_0:begin
				WS_SRAM_address <= YUV_block_index + YUV_i + YUV_row_address;
				YUV_buff <= read_data1_a[7:0];
				M2_WS_state <= S_M2_WS_WRITE_S_LO_1;
			end
			S_M2_WS_WRITE_S_LO_1:begin
				WS_SRAM_address <= YUV_block_index + YUV_i + YUV_row_address;
				WS_SRAM_write_data <= {YUV_buff, read_data1_b[7:0]};
				YUV_i = YUV_i + 3'd1;
				YUV_block_index <= (((YUV_block_index+17'd4) % 17'd160) == 0)? SRAM_address+17'd1: YUV_block_index + 17'd4;
				WS_SRAM_we_n <= 1'b1;
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
		B_i <= 4'd0;
		B_j <= 4'd0;
		Ic0 <= 3'd0;
		Jc0 <= 3'd0;
		Ic1 <= 3'd0;
		Jc1 <= 3'd1;
		temp_B_val_0 <= 32'd0;
		CTCS_A0_read_address <= 7'd0;
		CTCS_B_write_address <= 7'd0;
		
		CTCS_B_write_data <= 32'd0;

		CTCS_A0_w_en <= 1'b0;
		CTCS_B_w_en <= 1'b0;

		CT_start <= 1'd0;
		CT_done <= 1'd0;
		CS_start <= 1'd0;
		CS_done <= 1'd0;
		CTCS_LeadINFLAG <= 1'b1;
		M2_CTCS_state <= S_CTCS_wait;
	end	else begin
		case(M2_CTCS_state)
			S_CTCS_wait: begin
				M2_CTCS_state <= (FS_done) ? S_M2_CTCS_LI_READ_DELAY_1 : S_CTCS_wait;

				CTCS_A0_read_address <= 7'd0;
				CTCS_B_write_address <= 7'd0;
				CTCS_B_write_data <= 32'd0;
				CTCS_A0_w_en <= 1'b0;
				CTCS_B_w_en <= 1'b0;

				A_i <= 4'd0;
				A_j <= 4'd0;
				B_i <= 4'd0;
				B_j <= 4'd0;
				Ic0 <= 3'd0;
				Jc0 <= 3'd0;
				Ic1 <= 3'd0;
				Jc1 <= 3'd1;
				CT_start <= 1'b0;
			end
			S_M2_CTCS_LI_READ_DELAY_1: begin
				CTCS_A0_read_address <= CTCS_A0_read_address + 6'd1;
				M2_CTCS_state <= S_M2_CTCS_LI_READ_DELAY_2;
			end
			S_M2_CTCS_LI_READ_DELAY_2: begin
				CTCS_A0_read_address <= CTCS_A0_read_address + 6'd1;
				M2_CTCS_state <= S_M2_CTCS_LI_READ_buffer_row;
			end
			S_M2_CTCS_LI_READ_buffer_row: begin
				matrix_A_row[7] <= CTCS_A0_read_data;
				matrix_A_row[6] <= matrix_A_row[7];
				matrix_A_row[5] <= matrix_A_row[6];
				matrix_A_row[4] <= matrix_A_row[5];
				matrix_A_row[3] <= matrix_A_row[4];
				matrix_A_row[2] <= matrix_A_row[3];
				matrix_A_row[1] <= matrix_A_row[2];
				matrix_A_row[0] <= matrix_A_row[1];

				if(A_i < 4'd5) begin 
					CTCS_A0_read_address <= CTCS_A0_read_address + 6'd1;
				end
				A_i <= (A_i == 4'd7) ? 4'd0 : A_i + 4'd1;
				M2_CTCS_state <= (A_i < 4'd7)
					? S_M2_CTCS_LI_READ_buffer_row : S_M2_CTCS_CALC_B_ROW;
			end
			S_M2_CTCS_CALC_B_ROW: begin
				matrix_A_row[7] <= matrix_A_row[1];
				matrix_A_row[6] <= matrix_A_row[0];
				matrix_A_row[5] <= matrix_A_row[7];
				matrix_A_row[4] <= matrix_A_row[6];
				matrix_A_row[3] <= matrix_A_row[5];
				matrix_A_row[2] <= matrix_A_row[4];
				matrix_A_row[1] <= matrix_A_row[3];
				matrix_A_row[0] <= matrix_A_row[2];

				CTCS_B_w_en <= 1'd0;

				if(B_i == 4'd7) begin
					if (CTCS_LeadINFLAG) begin
						CS_start <= 1'b1;
						CTCS_LeadINFLAG <= 1'b1;
					end
					if (CT_done) begin
						CT_start <= 1'b0;
						CS_start <= 1'b1;
					end else begin
						CT_start <= 1'b1;
						CS_start <= 1'b0;
					end
				end

				// starting B_j 5 buffering the values for the next row calculations
				if((B_j == 4'd5 && A_i > 4'd0) || (B_j == 4'd6) || (B_j == 4'd7 && A_i < 4'd2)) begin
					CTCS_A0_read_address <= CTCS_A0_read_address + 6'd1;
				end
				if(B_j > 4'd5) begin
					nxt_matrix_A_row[7] <= CTCS_A0_read_data;
					nxt_matrix_A_row[6] <= nxt_matrix_A_row[7];
					nxt_matrix_A_row[5] <= nxt_matrix_A_row[6];
					nxt_matrix_A_row[4] <= nxt_matrix_A_row[5];
					nxt_matrix_A_row[3] <= nxt_matrix_A_row[4];
					nxt_matrix_A_row[2] <= nxt_matrix_A_row[3];
					nxt_matrix_A_row[1] <= nxt_matrix_A_row[2];
					nxt_matrix_A_row[0] <= nxt_matrix_A_row[1];
				end

				//calculations stuff
				if(A_i < 4'd6) begin
					A_i <= A_i + 4'd2;
					Jc0 <= Jc0 + 3'd2;
					Jc1 <= Jc1 + 3'd2;
					temp_B_val_0 <= temp_B_val_0 + result_a + result_b;
					M2_CTCS_state <= S_M2_CTCS_CALC_B_ROW;
				end else begin
					A_i <= 4'd0;
					Jc0 <= 3'd0;
					Jc1 <= 3'd1;
					temp_B_val_0 <= temp_B_val_0 + result_a + result_b;
					M2_CTCS_state <= S_M2_CTCS_CALC_B_NEXT_ROW;

					if(B_j == 4'd7) begin
						Ic0 <= 3'd0;
						Ic1 <= 3'd0;
					end else begin
						Ic0 <= Ic0 + 3'd1;
						Ic1 <= Ic1 + 3'd0;
					end
				end

			end
			S_M2_CTCS_CALC_B_NEXT_ROW: begin
				CTCS_B_w_en <= 1'd1;
				CTCS_B_write_data <= temp_B_val_0;
				
				A_i <= A_i + 4'd2;
				Jc0 <= Jc0 + 3'd2;
				Jc1 <= Jc1 + 3'd2;
				temp_B_val_0 <= result_a + result_b;
				M2_CTCS_state <= S_M2_CTCS_CALC_B_ROW;

				if(B_j == 4'd7 && B_i == 4'd7) begin
					if(FS_done) begin
						CT_done <= 1'd1;
						CS_start <= 1'd0;
						CS_done <= 1'd0;
					end else begin
						CS_done <= 1'd1;
						CT_start <= 1'd0;
						CT_done <= 1'd0;
					end
					B_i <= 4'd0;
					B_j <= 4'd0;
					CTCS_B_write_address <= CTCS_B_write_address;
				end else if(B_j == 4'd7) begin
					matrix_A_row <= nxt_matrix_A_row;
					B_i <= B_i + 4'd1;
					B_j <= 4'd0;
					CTCS_B_write_address <= CTCS_B_write_init_address + B_i;
				end else begin
					matrix_A_row[7] <= matrix_A_row[1];
					matrix_A_row[6] <= matrix_A_row[0];
					matrix_A_row[5] <= matrix_A_row[7];
					matrix_A_row[4] <= matrix_A_row[6];
					matrix_A_row[3] <= matrix_A_row[5];
					matrix_A_row[2] <= matrix_A_row[4];
					matrix_A_row[1] <= matrix_A_row[3];
					matrix_A_row[0] <= matrix_A_row[2];
					B_j <= B_j + 4'd1;
					CTCS_B_write_address <= CTCS_B_write_address + 7'd8 + B_i;
				end
			end
			default: M2_CTCS_state <= S_CTCS_wait;
		endcase
	end
end


endmodule