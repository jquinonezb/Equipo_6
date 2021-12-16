module Zero_Extend
(
	input [15:0] Zero_Ext_i,
	output wire [31:0] Zero_Ext_o
);

assign	Zero_Ext_o = { {16{1'b0}}, Zero_Ext_i};
endmodule 
