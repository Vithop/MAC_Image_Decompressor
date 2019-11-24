/*
Made by Vithuran Sadagopan
*/

`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

module get_c_values (
	input logic [2:0] i,
	input logic [2:0] j,
	output int C_values
);
always_comb begin
	case(i)
		8'd0:begin
			case(j)
				8'd0 : 	C_values = 1448;
				8'd1 : 	C_values = 1448;
				8'd2 : 	C_values = 1448;
				8'd3 : 	C_values = 1448;
				8'd4 : 	C_values = 1448;
				8'd5 : 	C_values = 1448;
				8'd6 : 	C_values = 1448;
				8'd7 : 	C_values = 1448;
			endcase	
		end
		8'd1:begin
			case(j)
				8'd0 : 	C_values = 2008;
				8'd1 : 	C_values = 1702;
				8'd2:  C_values = 1137;
				8'd3:  C_values = 399;
				8'd4:  C_values = -399;
				8'd5:  C_values = -1137;
				8'd6:  C_values = -1702;
				8'd7:  C_values = -2008;
			endcase
		end
		8'd2:begin
			case(j)
				8'd0:  C_values = 1892;
				8'd1:  C_values = 783;
				8'd2:  C_values = -783;
				8'd3:  C_values = -1892;
				8'd4:  C_values = -1892;
				8'd5:  C_values = -783;
				8'd6:  C_values = 783;
				8'd7:  C_values = 1892;
			endcase			
		end
		8'd3:begin
			case(j)
				8'd0:  C_values = 1702;
				8'd1:  C_values = -399;
				8'd2:  C_values = -2008;
				8'd3:  C_values = -1137;
				8'd4:  C_values = 1137;
				8'd5:  C_values = 2008;
				8'd6:  C_values = 399;
				8'd7:  C_values = -1702;
			endcase
		end
		8'd4:begin
			case(j)
				8'd0:  C_values = 1448;
				8'd1:  C_values = -1448;
				8'd2:  C_values = -1448;
				8'd3:  C_values = 1448;
				8'd4:  C_values = 1448;
				8'd5:  C_values = -1448;
				8'd6:  C_values = -1448;
				8'd7:  C_values = 1448;
			endcase
		end
		8'd5:begin
			case(j)
				8'd0:  C_values = 1137;
				8'd1:  C_values = -2008;
				8'd2:  C_values = 399;
				8'd3:  C_values = 1702;
				8'd4:  C_values = -1702;
				8'd5:  C_values = -399;
				8'd6:  C_values = 2008;
				8'd7:  C_values = -1137;
			endcase
		end
		8'd6:begin
			case(j)
				8'd0:  C_values = 783;
				8'd1:  C_values = -1892;
				8'd2:  C_values = 1892;
				8'd3:  C_values = -783;
				8'd4:  C_values = -783;
				8'd5:  C_values = 1892;
				8'd6:  C_values = -1892;
				8'd7:  C_values = 783;
			endcase
		end
		8'd7:begin
			case(j)
				8'd0:  C_values = 399;
				8'd1:  C_values = -1137;
				8'd2:  C_values = 1702;
				8'd3:  C_values = -2008;
				8'd4:  C_values = 2008;
				8'd5:  C_values = -1702;
				8'd6:  C_values = 1137;
				8'd7:  C_values = -399;	
			endcase
		end
	endcase
end	

// always_comb begin
// 	case(address)
// 		8'd0 : 	C_T_values = 1448;
// 		8'd1 : 	C_T_values = 1448;
// 		8'd2 : 	C_T_values = 1448;
// 		8'd3 : 	C_T_values = 1448;
// 		8'd4 : 	C_T_values = 1448;
// 		8'd5 : 	C_T_values = 1448;
// 		8'd6 : 	C_T_values = 1448;
// 		8'd7 : 	C_T_values = 1448;
// 		8'd8 : 	C_T_values = 2008;
// 		8'd9 : 	C_T_values = 1702;
// 		8'd10:  C_T_values = 1137;
// 		8'd11:  C_T_values = 399;
// 		8'd12:  C_T_values = -399;
// 		8'd13:  C_T_values = -1137;
// 		8'd14:  C_T_values = -1702;
// 		8'd15:  C_T_values = -2008;
// 		8'd16:  C_T_values = 1892;
// 		8'd17:  C_T_values = 783;
// 		8'd18:  C_T_values = -783;
// 		8'd19:  C_T_values = -1892;
// 		8'd20:  C_T_values = -1892;
// 		8'd21:  C_T_values = -783;
// 		8'd22:  C_T_values = 783;
// 		8'd23:  C_T_values = 1892;
// 		8'd24:  C_T_values = 1702;
// 		8'd25:  C_T_values = -399;
// 		8'd26:  C_T_values = -2008;
// 		8'd27:  C_T_values = -1137;
// 		8'd28:  C_T_values = 1137;
// 		8'd29:  C_T_values = 2008;
// 		8'd30:  C_T_values = 399;
// 		8'd31:  C_T_values = -1702;
// 		8'd32:  C_T_values = 1448;
// 		8'd33:  C_T_values = -1448;
// 		8'd34:  C_T_values = -1448;
// 		8'd35:  C_T_values = 1448;
// 		8'd36:  C_T_values = 1448;
// 		8'd37:  C_T_values = -1448;
// 		8'd38:  C_T_values = -1448;
// 		8'd39:  C_T_values = 1448;
// 		8'd40:  C_T_values = 1137;
// 		8'd41:  C_T_values = -2008;
// 		8'd42:  C_T_values = 399;
// 		8'd43:  C_T_values = 1702;
// 		8'd44:  C_T_values = -1702;
// 		8'd45:  C_T_values = -399;
// 		8'd46:  C_T_values = 2008;
// 		8'd47:  C_T_values = -1137;
// 		8'd48:  C_T_values = 783;
// 		8'd49:  C_T_values = -1892;
// 		8'd50:  C_T_values = 1892;
// 		8'd51:  C_T_values = -783;
// 		8'd52:  C_T_values = -783;
// 		8'd53:  C_T_values = 1892;
// 		8'd54:  C_T_values = -1892;
// 		8'd55:  C_T_values = 783;
// 		8'd56:  C_T_values = 399;
// 		8'd57:  C_T_values = -1137;
// 		8'd58:  C_T_values = 1702;
// 		8'd59:  C_T_values = -2008;
// 		8'd60:  C_T_values = 2008;
// 		8'd61:  C_T_values = -1702;
// 		8'd62:  C_T_values = 1137;
// 		8'd63:  C_T_values = -399;	
// 	endcase
// end	
endmodule
