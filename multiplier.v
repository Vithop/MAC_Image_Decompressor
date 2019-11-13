
`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

module multiplier (	
	output logic [31:0] a
	input logic [31:0] b,
	input logic [31:0] c,
	
	output logic [31:0] d,
	input logic [31:0] e,
	input logic [31:0] f,

	output logic [31:0] g,
	input logic [31:0] h,
	input logic [31:0] i,
);
logic [63:0] aTemp;
logic [63:0] dTemp;
logic [63:0] gTemp;
assign aTemp = b * c;
assign a = [31:0]aTemp;
assign dTemp = e * f;
assign d = [31:0]dTemp;
assign gTemp = h * i;
assign g = [31:0]gTemp;

	
endmodule
