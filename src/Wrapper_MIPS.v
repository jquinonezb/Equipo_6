module Wrapper_MIPS
(
	input MAX10_CLK1_50,
	input [9:9] SW,
	output [7:0] LEDR
);

wire clk, clk_hz;

PLL	PLL_inst (.inclk0( MAX10_CLK1_50 ), .c0(clk));

cont_1s_RCO Clock(.mclk(clk), .reset(SW), .RCO(clk_hz));

Data_Path MIPS(.clk(clk_hz), .reset(SW), .GPIO_o(LEDR));


endmodule 