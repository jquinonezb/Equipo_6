module CP
(
	input [4:0] Write_Register_i,
	output [31:0] CP_o
);
wire A, B, C, D, E;
//Assigning the letters to each bit of Write_Register
assign A = Write_Register_i[4];
assign B = Write_Register_i[3];
assign C = Write_Register_i[2];
assign D = Write_Register_i[1];
assign E = Write_Register_i[0];
// Codifier to implement the 5 bit input to 32 outputs
assign CP_o[0] = 1'b0; //REG0
assign CP_o[1] = ~A & ~B & ~C & ~D & E;
assign CP_o[2] = ~A & ~B & ~C & D & ~E;
assign CP_o[3] = ~A & ~B & ~C & D & E;
assign CP_o[4] = ~A & ~B & C & ~D & ~E;
assign CP_o[5] = ~A & ~B & C & ~D & E; // REG6
assign CP_o[6] = ~A & ~B & C & D & ~E;
assign CP_o[7] = ~A & ~B & C & D & E;
assign CP_o[8] = ~A & B & ~C & ~D & ~E;
assign CP_o[9] = ~A & B & ~C & ~D & E;
assign CP_o[10] = ~A & B & ~C & D & ~E;
assign CP_o[11] = ~A & B & ~C & D & E;//REG12
assign CP_o[12] = ~A & B & C & ~D & ~E;
assign CP_o[13] = ~A & B & C & ~D & E;
assign CP_o[14] = ~A & B & C & D & ~E;
assign CP_o[15] = ~A & B & C & D & E;
assign CP_o[16] = A & ~B & ~C & ~D & ~E;
assign CP_o[17] = A & ~B & ~C & ~D & E;//REG18
assign CP_o[18] = A & ~B & ~C & D & ~E;
assign CP_o[19] = A & ~B & ~C & D & E;
assign CP_o[20] = A & ~B & C & ~D & ~E;
assign CP_o[21] = A & ~B & C & ~D & E;
assign CP_o[22] = A & ~B & C & D & ~E;
assign CP_o[23] = A & ~B & C & D & E;
assign CP_o[24] = A & B & ~C & ~D & ~E;
assign CP_o[25] = A & B & ~C & ~D & E;
assign CP_o[26] = A & B & ~C & D & ~E;
assign CP_o[27] = A & B & ~C & D & E;
assign CP_o[28] = A & B & C & ~D & ~E;
assign CP_o[29] = A & B & C & ~D & E;
assign CP_o[30] = A & B & C & D & ~E;
assign CP_o[31] = A & B & C & D & E; //REG32
endmodule 