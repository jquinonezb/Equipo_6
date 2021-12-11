module Sign_Extend
(
	input [15:0] Sign_Ext_i,
	output wire [31:0] Sign_Ext_o
);

/*reg data;
reg [31:0] data_out;

always @(*)
begin 
	data <= (Sign_Ext_i[15]) ? 1'b1 : 1'b0;
	data_out <= { {16{data}},Sign_Ext_i};
end*/
assign	Sign_Ext_o = { {16{Sign_Ext_i[15]}}, Sign_Ext_i};
endmodule 