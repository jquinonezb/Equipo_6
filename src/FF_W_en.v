module FF_W_en
 // Register with active-high clock & asynchronous load
 #(
	parameter WIDTH = 32
)
(
	//input/ output ports
	input			[WIDTH-1:0] D, 
	input 		clk,
	input			reset,
	output		[WIDTH-1:0] Q
);
   //variable to storage states
	reg [WIDTH-1:0] data;
	always @(posedge clk or negedge reset) 
	begin
      if (!reset)
         data <= 0;
      else
         data <= D;
   end 
	assign Q = data;	
endmodule 