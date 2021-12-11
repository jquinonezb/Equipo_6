module Register_W_en
#( 
	parameter WIDTH = 32
)
(
	input [WIDTH-1:0] D,
	input clk, reset,
	output [WIDTH-1:0] Q 
);

FF_W_en Reg (.D(D), .reset(reset), .clk(clk), .Q(Q));
endmodule 