module Wrapper_MIPS
(
	input MAX10_CLK1_50,
	input [9:0] SW,
	output [9:0] LEDR
);

wire clk, clk_hz;

PLL	PLL_inst (.inclk0( MAX10_CLK1_50 ), .c0(clk));

cont_1s_RCO Clock(.mclk(clk), .reset(SW[9]), .RCO(clk_hz));

Data_Path MIPS(.clk(clk_hz), .reset(SW[9]), .GPIO_i(SW[7:0]), .clk_signal(LEDR[9]), .GPIO_o(LEDR[7:0]));
endmodule
 