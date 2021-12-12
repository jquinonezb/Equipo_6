module Memory_system
#
(
	parameter MEMORY_DEPTH 	= 64,
	parameter WIDTH 			= 32
)
(
	input write_enable_i, clock,
	input [WIDTH-1:0] Write_Data,
	input [WIDTH-1:0] Address_i,
	
	output [WIDTH-1:0] Instruction_o
);

	wire [WIDTH-1:0] ROM_o, RAM_o;
	wire selection;
	reg [WIDTH-1:0] data_1 = 32'h10000000;
	
	assign selection = (Address_i < data_1) ? 1'b1 : 1'b0;
	Data_Memory RAM(.clk(clock), .Write_Enable_i(write_enable_i), .Write_Data_i(Write_Data), .Address_i(Address_i), .Read_Data_o(RAM_o));
	Program_Memory ROM(.Address_i(Address_i), .Instruction_o(ROM_o));
	MUX2_1 M1(.data_1(ROM_o), .data_2(RAM_o), .selector(selection), .data_o(Instruction_o));
	
endmodule 