
`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif
//Multiplier and 
module MAC (	
	input logic [1:0]select,

	output logic [31:0] a
	input logic [31:0] b,
	input logic [31:0] c,
	
	output logic [31:0] d,
	input logic [31:0] e,
	input logic [31:0] f,

	output logic [31:0] g,
	input logic [31:0] h,
	input logic [31:0] i,

	output logic [31:0] prime
);
logic [31:0] aOp1;
logic [31:0] aOp2;
logic [63:0] aTemp;

logic [31:0] dOp1;
logic [31:0] dOp2;
logic [63:0] dTemp;

logic [31:0] gOp1;
logic [31:0] gOp2;
logic [63:0] gTemp;

assign a = [31:0]aTemp;
assign 
assign d = [31:0]dTemp;
assign 
assign g = [31:0]gTemp;

always_comb begin
	if (select == 2'd0) begin
		aOp1 = b + c;
		aOp2 = 31'd21;

		dOp1 = e + f;
		dOp2 = 31'd52;

		gOp1 = h + i;
		gOp2 = 31'd159;

		a = [31:0]aTemp - [31:0]dTemp + [31:0]gTemp;
		d = 0;
		g = 0;
	end else if (select == 2'd1) begin
		aOp1 = b - 16;
		aOp2 = 31'd76284;

		dOp1 = e - 128
		dOp2 = 31'd132251;

		gOp1 = h - 128;
		gOp2 = 31'd104595;

		a = [31:0]aTemp + [31:0]dTemp;
		d = 0;
		g = [31:0]aTemp + [31:0]gTemp;
	end else if (select == 2'd2)begin
		aOp1 = b - 16;
		aOp2 = 31'd76284;

		dOp1 = e - 16;
		dOp2 = 31'd25624;

		gOp1 = h - 16;
		gOp2 = 31'd53281;

		a = 0;
		d = [31:0]aTemp - [31:0]dTemp - [31:0]gTemp;
		g = 0;
	end else begin
		aOp1 = 0;
		aOp2 = 0;

		dOp1 = 0;
		dOp2 = 0;

		gOp1 = 0;
		gOp2 = 0;

		a = 0;
		d = 0;
		g = 0;
	end
	aTemp = aOp1 * aOp2;
	dTemp = dOp1 * dOp2;
	gTemp = gOp1 * gOp2;
end

	
endmodule
