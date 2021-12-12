module Register
#( 
	parameter WIDTH = 32
)
(
	input [WIDTH-1:0] Rd,
	input clk, reset,
	input enable,
	output [WIDTH-1:0] Q1 
);

FF Reg_N (.D(Rd), .reset(reset), .clk(clk), .Q(Q1), .enable(enable));
endmodule 