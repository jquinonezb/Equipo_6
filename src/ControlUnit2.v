module ControlUnit2
#(
	parameter WIDTH = 32,
	parameter 	IF = 3'b000,	// INSTRUCTION FETCH
					ID = 3'b001,	// INSTRUCTION DECODE
					EX = 3'b010,	// EXECUTION
					MA = 3'b011,	// MEMORY ACCESS (opcional)
					WB = 3'b100 	// WRITE BACK
)
(
	input 		clk, rst,
	input [5:0] Op, Funct,
	
	output reg	IorD,
					Mem_Write,
					IR_Write,
					PC_Write,
					PC_Src,
					Branch,
					ALU_SrcA,
					Reg_Write,
					Mem_Reg,
					Reg_Dst,
	output reg [2:0] ALU_Control,
	output reg [1:0] ALU_SrcB
				
);

	reg [2:0] y_C, Y_N;// y_C represents curretn state, Y_N represents next state
					
	always @(y_C or Op or Funct)
	begin: state_table
		Y_N = 3'b000;
		PC_Write 	= 1'b0;
		Mem_Write 	= 1'b0;
		IorD 			= 1'b0;
		IR_Write 	= 1'b0;
		PC_Src 		= 1'b0;
		Branch 		= 1'b0;
		ALU_Control 	= 3'b000;
		ALU_SrcB 		= 2'b00;
		ALU_SrcA 		= 1'b0;
		Reg_Write 	= 1'b0;
		Mem_Reg 		= 1'b0; 
		Reg_Dst 		= 1'b0;
		
		case(y_C)
			IF: begin
				PC_Write 	= 1'b1;
				Mem_Write 	= 1'b0;
				IorD 			= 1'b0;
				IR_Write 	= 1'b1;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				ALU_Control = 3'b001;
				ALU_SrcB 	= 2'b01;
				ALU_SrcA 	= 1'b0;
				Reg_Write 	= 1'b0;
				Mem_Reg 		= 1'b0; //
				Reg_Dst 		= 1'b0;
				Y_N = ID;
			end
			
			ID: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 			= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				ALU_Control = 3'b000;
				ALU_SrcB 	= 2'b00;
				ALU_SrcA 	= 1'b1;
				Reg_Write 	= 1'b0;
				Mem_Reg 		= 1'b1;
				Reg_Dst 		= 1'b0;
				Y_N = EX;
			end
			
			EX: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 			= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				Reg_Write 	= 1'b0;
				Y_N = WB;
				
				
				if(Op == 6'h0 && Funct == 6'h20)
				begin	// ADD
				ALU_Control 	= 3'b001;
				ALU_SrcB 		= 2'b00;
				ALU_SrcA 		= 1'b1;
				Mem_Reg 		= 1'b0;
				Reg_Dst 		= 1'b1;
				Y_N = WB;
				end
				
				else if (Op == 6'h08)
				begin //ADDI
				ALU_Control 	= 3'b001;
				ALU_SrcB 		= 2'b10;
				ALU_SrcA 		= 1'b1;
				Mem_Reg 		= 1'b0;
				Reg_Dst 		= 1'b0;
				Y_N = WB;
				end	
				
				/*else
				begin
					Y_N = MA;
				end*/
				
			end
			
			/*MA: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 			= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b1;
				Branch 		= 1'b0;
				ALU_Control = 3'b111;
				ALU_SrcB 	= 2'b10;
				ALU_SrcA 	= 1'b1;
				Reg_Write 	= 1'b0;
				Mem_Reg 		= 1'b1;
				Reg_Dst 		= 1'b1;
				Y_N = WB;
			end*/
			
			WB: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 			= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b1;
				Branch 		= 1'b0;
				Reg_Write 	= 1'b1;
				Mem_Reg 		= 1'b0;
				
				if(Op == 6'h0 && Funct == 6'h20) 
				begin // add
					ALU_Control 	= 3'b001;
					ALU_SrcB 		= 2'b00;
					ALU_SrcA 		= 1'b1;
					Reg_Dst	= 1'b1;
					Y_N = IF;
				end
				
				else if(Op == 6'h8) 
				begin // addi
					ALU_Control 	= 3'b001;
					ALU_SrcB 		= 2'b10;
					ALU_SrcA 		= 1'b1;
					Reg_Dst	= 1'b0;
					Y_N = IF;
				end
			
			end
			
			default: Y_N = 3'b000;
		endcase
	end // state_table
	
	always@(posedge clk or negedge rst)
	begin: state_FFs
		if(rst == 0)
			y_C <= IF;
		else 
			y_C <= Y_N;
	end // state_FFs


endmodule