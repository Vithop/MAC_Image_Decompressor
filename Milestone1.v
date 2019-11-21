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
	   output 	logic 			SRAM_we_n

);

Milestone1_state_type M1_state;

//address base values const
parameter intit_Y_address = 18'd0,
		intit_U_address = 18'd38400,
		intit_V_address = 18'd57600,
		init_RGB_address = 18'd146944;

// For Multiplier
logic [31:0] result_a;
logic [31:0] result_b;
logic [31:0] result_c;
logic [63:0] temp_a;
logic [63:0] temp_b;
logic [63:0] temp_c;

// logic result_a <= 32'd0;
// logic result_b <= 32'd0;
// logic result_c <= 32'd0;
// logic temp_a <= 63'd0;
// logic temp_b <= 63'd0;
// logic temp_c <= 63'd0;

longint Op1;
longint Op2;

longint Op3;
longint Op4;

longint Op5;
longint Op6;

//For Calculating YUV_countvalues
logic [16:0] RGB_count; // Pixel Position
logic [15:0] Y_count;
logic [15:0] UV_count;

logic [7:0] U_odd;
logic [31:0] U_prime;
logic [7:0] U_buffer [5:0];	// U/V_buffer[5] is (RGB_count+5)/2

logic [7:0] V_odd;
logic [31:0] V_prime;
logic [7:0] V_buffer [5:0];

logic [7:0] Y_buffer [1:0];

logic read_UV_flag;
logic LP_flag;

//RGB Values
logic [7:0] R_even;
logic [7:0] R_odd;
logic [31:0] R_temp;
logic [7:0] G_even;
logic [7:0] G_odd;
logic [31:0] G_temp;
logic [7:0] B_even;
logic [7:0] B_odd;
logic [31:0] B_temp;

assign temp_a = (Op1 * Op2);
assign temp_b = (Op3 * Op4);
assign temp_c = (Op5 * Op6);
assign result_a = {temp_a[31:0]};
assign result_b = {temp_b[31:0]};
assign result_c = {temp_c[31:0]};

//Debuging values from SRAM READ
logic [7:0] Read_byte1;
logic [7:0] Read_byte2;
assign Read_byte1 = SRAM_read_data[7:0];
assign Read_byte2 = SRAM_read_data[15:8];

always_comb begin
	if(M1_state == S_M1_CALC_V_PRIME || M1_state == S_M1_LI_CALC_V || M1_state == S_M1_LO_WRITE_BR)begin
		Op1 = V_buffer[5] + V_buffer[0];
		Op2 = 31'd21;
		Op3 = V_buffer[4] + V_buffer[1];
		Op4 = 31'd52;
		Op5 = V_buffer[3] + V_buffer[2];
		Op6 = 31'd159;
		// V_prime = (result_a - result_b + result_c + 32'd128) >>> 8;
	end else if (M1_state == S_M1_CALC_U_PRIME || M1_state == S_M1_LI_CALC_U || M1_state == S_M1_LO_WRITE_GB) begin
		Op1 = U_buffer[5] + U_buffer[0];
		Op2 = 31'd21;
		Op3 = U_buffer[4] + U_buffer[1];
		Op4 = 31'd52;
		Op5 = U_buffer[3] + U_buffer[2];
		Op6 = 31'd159;	
		// U_prime = (result_a - result_b + result_c + 32'd128) >>> 8;
	end else if (M1_state == S_M1_CALC_FIRST_RB || M1_state == S_M1_LO_CALC_FIRST_RB) begin
		Op1 = Y_buffer[1] - 31'd16;
		Op2 = 31'd76284;
		Op3 = U_buffer[2] - 31'd128;
		Op4 = 31'd132251;
		Op5 = V_buffer[2] - 31'd128;
		Op6 = 31'd104595;
		// R_temp = (result_a + result_c);
		// B_temp = (result_a + result_b);

		// R_even = (R_temp[31] == 1'd1)
		// 			? 8'd0
		// 			: |R_temp[30:24] ? 8'd255 : R_temp >>> 16;

		// B_even = (B_temp[31] == 1'd1)
		// 			? 8'd0
		// 			: |B_temp[30:24] ? 8'd255 : B_temp >>> 16;
	end else if (M1_state == S_M1_CALC_SECOND_RB || M1_state == S_M1_LO_CALC_SECOND_RB) begin
		Op1 = Y_buffer[0] - 31'd16;
		Op2 = 31'd76284;
		Op3 = U_prime - 31'd128;
		Op4 = 31'd132251;
		Op5 = V_prime - 31'd128;
		Op6 = 31'd104595;
		// R_temp = (result_a + result_c);
		// B_temp = (result_a + result_b);

		// R_odd = (R_temp[31] == 1'd1)
		// 			? 8'd0
		// 			: |R_temp[30:24] ? 8'd255 : R_temp >>> 16;

		// B_odd = (B_temp[31] == 1'd1)
		// 			? 8'd0
		// 			: |B_temp[30:24] ? 8'd255 : B_temp >>> 16;
	end else if (M1_state == S_M1_CALC_FIRST_G || M1_state == S_M1_LO_CALC_FIRST_G) begin
		Op1 = Y_buffer[1] - 31'd16;
		Op2 = 31'd76284;
		Op3 = U_buffer[2] - 31'd128;
		Op4 = 31'd25624;
		Op5 = V_buffer[2] - 31'd128;
		Op6 = 31'd53281;
		// G_temp  = (result_a - result_b - result_c);
		// G_even = (G_temp[31] == 1'd1)
		// 			? 8'd0
		// 			: |G_temp[30:24] ? 8'd255 : G_temp >>> 16;
	end else if (M1_state == S_M1_CALC_SECOND_G || M1_state == S_M1_LO_CALC_SECOND_G) begin
		Op1 = Y_buffer[0] - 31'd16;
		Op2 = 31'd76284;
		Op3 = U_prime - 31'd128;
		Op4 = 31'd25624;
		Op5 = V_prime - 31'd128;
		Op6 = 31'd53281;
		// G_temp  = (result_a - result_b - result_c);
		// G_odd = (G_temp[31] == 1'd1)
		// 			? 8'd0
		// 			: |G_temp[30:24] ? 8'd255 : G_temp >>> 16;
	end else begin
		Op1 = 31'd0;
		Op2 = 31'd0;
		Op3 = 31'd0;
		Op4 = 31'd0;
		Op5 = 31'd0;
		Op6 = 31'd0;
	end

end

always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		// reset
		SRAM_we_n <= 1'b1;
		SRAM_write_data <= 16'd0;
		SRAM_address <= 16'd0;
		read_UV_flag = 1'b1;

		RGB_count <= 16'd0;
		Y_count <= 16'd0;
		UV_count <= 16'd0;
		LP_flag <= 1'b0;
		M1_state <= S_M1_IDLE;
	end	else begin
		case(M1_state)
			S_M1_IDLE:begin
				if (Enable == 1'b1) begin
					M1_state <= S_M1_LI_FIRST_READ_V;
					SRAM_address <= intit_V_address;
					RGB_count <= 16'd0;
					Y_count <= 16'd0;
					UV_count <= 16'd0;
				end
			end
			//****START OF LEAD IN CYCLES
			S_M1_LI_FIRST_READ_V:begin
				SRAM_address = intit_U_address + UV_count;
				UV_count <= UV_count + 16'd1;
				SRAM_we_n <= 1'b1;
				M1_state <= S_M1_LI_FIRST_READ_U;

			end
			S_M1_LI_FIRST_READ_U:begin
				SRAM_address = intit_Y_address + Y_count;
				Y_count <= Y_count + 16'd1;
				M1_state <= S_M1_LI_FIRST_READ_Y;
			end
			S_M1_LI_FIRST_READ_Y:begin
				V_buffer[5] <= SRAM_read_data[7:0];
				V_buffer[4] <= SRAM_read_data[15:8];
				V_buffer[3] <= SRAM_read_data[15:8];
				V_buffer[2] <= SRAM_read_data[15:8];
				V_buffer[1] <= SRAM_read_data[15:8];
				V_buffer[0] <= SRAM_read_data[15:8];
				
				SRAM_address = intit_V_address + UV_count;
				M1_state <= S_M1_LI_V1;
			end
			S_M1_LI_V1:begin
				U_buffer[5] <= SRAM_read_data[7:0];
				U_buffer[4] <= SRAM_read_data[15:8];
				U_buffer[3] <= SRAM_read_data[15:8];
				U_buffer[2] <= SRAM_read_data[15:8];
				U_buffer[1] <= SRAM_read_data[15:8];
				U_buffer[0] <= SRAM_read_data[15:8];
				
				SRAM_address = intit_U_address + UV_count;
				UV_count <= UV_count + 16'd1;

				M1_state <= S_M1_LI_U1;
			end
			S_M1_LI_U1:begin
				Y_buffer <= {SRAM_read_data[15:8], SRAM_read_data[7:0]};
				M1_state <= S_M1_LI_Y1;
			end
			S_M1_LI_Y1:begin
				V_buffer <= {SRAM_read_data[7:0], SRAM_read_data[15:8], V_buffer[5:2]};
				M1_state <= S_M1_LI_CALC_V;
			end
			S_M1_LI_CALC_V:begin
				V_prime <= (result_a - result_b + result_c + 32'd128) >>> 8;
				U_buffer <= {SRAM_read_data[7:0], SRAM_read_data[15:8], U_buffer[5:2]};
				M1_state <= S_M1_LI_CALC_U;
			end
			S_M1_LI_CALC_U:begin
				U_prime <= (result_a - result_b + result_c + 32'd128) >>> 8;
				M1_state <= S_M1_CALC_FIRST_RB;
			end
			//****START OF REPEATING CYCLES
			S_M1_CALC_FIRST_RB:begin
				R_temp <= (result_a + result_c);
				B_temp <= (result_a + result_b);
				R_even = (R_temp[31] == 1'd1)
					? 8'd0
					: |R_temp[30:24] ? 8'd255 : R_temp >>> 16;

				B_even = (B_temp[31] == 1'd1)
					? 8'd0
					: |B_temp[30:24] ? 8'd255 : B_temp >>> 16;

				SRAM_we_n <= 1'b1;
				M1_state <= S_M1_CALC_FIRST_G;

				if(read_UV_flag == 1'b1) begin
					SRAM_address = intit_V_address + UV_count;
				end else begin
					Y_count <= Y_count + 1'd1;
					SRAM_address = intit_Y_address + Y_count;
				end
			end
			S_M1_CALC_FIRST_G:begin
				G_temp  <= (result_a - result_b - result_c);
				G_even <= (G_temp[31] == 1'd1)
							? 8'd0
							: |G_temp[30:24] ? 8'd255 : G_temp >>> 16;

				M1_state <= S_M1_CALC_SECOND_RB;

				if(read_UV_flag == 1'b1) begin
					UV_count <= UV_count + 1'd1;
					SRAM_address = intit_U_address + UV_count;
				end
			end
			S_M1_CALC_SECOND_RB:begin
				R_temp <= (result_a + result_c);
				B_temp <= (result_a + result_b);

				R_odd <= (R_temp[31] == 1'd1)
							? 8'd0
							: |R_temp[30:24] ? 8'd255 : R_temp >>> 16;

				B_odd <= (B_temp[31] == 1'd1)
							? 8'd0
							: |B_temp[30:24] ? 8'd255 : B_temp >>> 16;

				M1_state <= S_M1_CALC_SECOND_G;
				if(read_UV_flag == 1'b1) begin
					Y_count <= Y_count + 1'd1;
					SRAM_we_n <= 1'b1;
					SRAM_address = intit_Y_address + Y_count;
				end else begin
					SRAM_write_data <= {R_even, G_even};
					SRAM_we_n <= 1'b0;
					SRAM_address <= init_RGB_address + RGB_count;
					RGB_count <= RGB_count + 1'd1;
				end
			end
			S_M1_CALC_SECOND_G:begin

				G_temp  <= (result_a - result_b - result_c);
				G_odd <= (G_temp[31] == 1'd1)
							? 8'd0
							: |G_temp[30:24] ? 8'd255 : G_temp >>> 16;

				SRAM_we_n <= 1'b0;
				SRAM_address <= init_RGB_address + RGB_count;
				RGB_count <= RGB_count + 1'd1;
				M1_state <= S_M1_CALC_V_PRIME;

				if(read_UV_flag == 1'b1) begin
					V_odd <= {SRAM_read_data[7:0]};
					V_buffer <= {SRAM_read_data[15:8], V_buffer[5:1]};

					SRAM_write_data <= {R_even, G_even};
				end else begin
					V_buffer <= {V_odd, V_buffer[5:1]};
					SRAM_write_data <= {B_even, R_odd};
					Y_buffer <= {SRAM_read_data[15:8], SRAM_read_data[7:0]};
				end

			end
			S_M1_CALC_V_PRIME:begin
				V_prime <= (result_a - result_b + result_c + 32'd128) >>> 8;
				//SRAM_we_n <= 1'b1;
				SRAM_address <= init_RGB_address + RGB_count;
				RGB_count <= RGB_count + 1'd1;
				
				M1_state <= S_M1_CALC_U_PRIME;

				if(read_UV_flag == 1'b1) begin
					SRAM_write_data <= {B_even, R_odd};
					U_odd <= {SRAM_read_data[7:0]};
					U_buffer <= {SRAM_read_data[15:8], U_buffer[5:1]};					
				end else begin
					U_buffer <= {U_odd, U_buffer[5:1]};
					SRAM_write_data <= {G_odd, B_odd};
					//V_buffer[5] <= V_odd;	
				end
			end
			S_M1_CALC_U_PRIME:begin
				U_prime <= (result_a - result_b + result_c + 32'd128) >>> 8;

				read_UV_flag <= ~read_UV_flag;
				
				if ((Y_count % 160) == 157) begin
					M1_state <= S_M1_LO_CALC_FIRST_RB;
				end else begin
					M1_state <= S_M1_CALC_FIRST_RB;
				end

				if(read_UV_flag == 1'b1) begin
					SRAM_address <= init_RGB_address + RGB_count;
					RGB_count <= RGB_count + 1'd1;
					SRAM_write_data <= {G_odd, B_odd};

					Y_buffer <= {SRAM_read_data[15:8], SRAM_read_data[7:0]};
				end else begin					
					SRAM_we_n <= 1'b1;
				end
			end
			S_M1_LO_CALC_FIRST_RB:begin
				SRAM_we_n <= 1'b1;
				if ((Y_count != 31'd38401)  && (LP_flag == 1'b0))begin
					SRAM_address = intit_Y_address + Y_count;
					Y_count <= Y_count + 16'd1;
				end
				R_temp <= (result_a + result_c);
				B_temp <= (result_a + result_b);
				R_even <= (R_temp[31] == 1'd1)
					? 8'd0
					: |R_temp[30:24] ? 8'd255 : R_temp >>> 16;

				B_even <= (B_temp[31] == 1'd1)
					? 8'd0
					: |B_temp[30:24] ? 8'd255 : B_temp >>> 16;
				M1_state <= S_M1_LO_CALC_FIRST_G;
			end
			S_M1_LO_CALC_FIRST_G:begin
				G_temp  <= (result_a - result_b - result_c);
				G_even <= (G_temp[31] == 1'd1)
							? 8'd0
							: |G_temp[30:24] ? 8'd255 : G_temp >>> 16;

				M1_state <= S_M1_LO_CALC_SECOND_RB;
			end
			S_M1_LO_CALC_SECOND_RB:begin

				R_temp <= (result_a + result_c);
				B_temp <= (result_a + result_b);

				R_odd <= (R_temp[31] == 1'd1)
							? 8'd0
							: |R_temp[30:24] ? 8'd255 : R_temp >>> 16;

				B_odd <= (B_temp[31] == 1'd1)
							? 8'd0
							: |B_temp[30:24] ? 8'd255 : B_temp >>> 16;

				SRAM_we_n <= 1'b0;
				SRAM_write_data <= {R_even, G_even};
				SRAM_address <= init_RGB_address + RGB_count;
				RGB_count <= RGB_count + 1'd1;

				M1_state <= S_M1_LO_CALC_SECOND_G;
			end
			S_M1_LO_CALC_SECOND_G:begin

				G_temp  <= (result_a - result_b - result_c);
				G_odd <= (G_temp[31] == 1'd1)
							? 8'd0
							: |G_temp[30:24] ? 8'd255 : G_temp >>> 16;

				SRAM_address <= init_RGB_address + RGB_count;
				RGB_count <= RGB_count + 1'd1;
				SRAM_write_data <= {B_even, R_odd};
				M1_state <= S_M1_LO_WRITE_BR;

				if ((Y_count != 31'd38401) && (LP_flag == 1'b0)) begin
					V_buffer <= {V_odd,V_buffer[5:1]};	
					Y_buffer <= {SRAM_read_data[15:8], SRAM_read_data[7:0]};
				end
				
			end
			S_M1_LO_WRITE_BR:begin
				V_prime <= (result_a - result_b + result_c + 32'd128) >>> 8;

				SRAM_address <= init_RGB_address + RGB_count;
				RGB_count <= RGB_count + 1'd1;
				SRAM_write_data <= {G_odd, B_odd};
				
				if ((Y_count != 31'd38401)  && (LP_flag == 1'b0)) begin
					U_buffer <= {U_odd,U_buffer[5:1]};
				end

				M1_state <= S_M1_LO_WRITE_GB;
			end
			S_M1_LO_WRITE_GB:begin
				U_prime <= (result_a - result_b + result_c + 32'd128) >>> 8;

				if (Y_count == 31'd38401) begin
					M1_state <= S_M1_IDLE;
				end else if(LP_flag == 1'b1)begin
					LP_flag <= 1'b0;
					SRAM_address <= intit_V_address + UV_count;
					M1_state <= S_M1_LI_FIRST_READ_V;
				end else if((Y_count % 160) == 0) begin
					LP_flag <= 1'b1;
					M1_state <= S_M1_LO_CALC_FIRST_RB;
				end else begin
					M1_state <= S_M1_LO_CALC_FIRST_RB;
				end	
				SRAM_we_n <= 1'b1;
			end
			default: M1_state <= S_M1_IDLE;
		endcase
	end
end

endmodule


