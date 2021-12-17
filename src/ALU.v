module ALU  // ARITHMETIC UNIT

#(
	parameter WIDTH = 32
)
(
	input		[WIDTH-1: 0]	data_a, data_b,
	input		[2: 0]	select,
	output reg [WIDTH-1: 0] y,
	output reg zero
);		 


always @ (*)
begin
y = 32'b0;
case (select)
3'b001:	y = data_a + data_b;
3'b010:	y = data_a & data_b;
3'b011:	y = data_a | data_b;
3'b100: y = data_a ^ data_b;
3'b101:	y = data_a << 1;
3'b110:	y = data_a >> 1;			
3'b111:	y = data_a ~^ data_b;           
default:		y = 4'b0;
endcase
zero = (y == 32'h0) ? 1'b1 : 1'b0;
end

endmodule
