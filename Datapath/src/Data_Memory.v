module Data_Memory 
#(	
	parameter DATA_WIDTH = 32,
	parameter MEMORY_DEPTH = 64
)
(
	input clk, Write_Enable_i, 
	input [DATA_WIDTH-1:0] Write_Data_i,
	input [DATA_WIDTH-1:0]  Address_i,
	output [(DATA_WIDTH-1):0]  Read_Data_o
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
	reg [DATA_WIDTH-1:0] Var_i = 32'h10010000;

	always @ (posedge clk)
	begin
		// Write
		if (Write_Enable_i)
			ram[(Address_i - Var_i) >> 2 ] <= Write_Data_i;
	end

  	assign Read_Data_o = ram[(Address_i - Var_i) >> 2 ];

endmodule 