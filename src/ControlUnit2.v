module ControlUnit2
#(
	parameter WIDTH = 32,
	parameter 	IF = 4'b0000,	// INSTRUCTION FETCH
			ID = 4'b0001,	// INSTRUCTION DECODE
			EX = 4'b0010,	// EXECUTION
			MA = 4'b0011,	// MEMORY ACCESS (opcional)
			WB = 4'b0100, 	// WRITE BACK
			BEQ = 4'b0101,	// STATE TO BEQ
			JMP = 4'b0110, 	// STATE TO JUMP
			JAL = 4'b0111	// STATE TO JAL
)
(
	input 		clk, rst,
	input [5:0] Op, Funct,
	
	output reg			IorD,
					Mem_Write,
					IR_Write,
					PC_Write,
					Reg_Write,
					PC_Src,
					Branch,
					ALU_SrcA,
					Mem_Reg,
					PC_J,
	output reg [2:0] 	ALU_Control,
	output reg [1:0] 	ALU_SrcB,
				Reg_Dst, Zero_Ext
				
);

	reg [2:0] y_C, Y_N;// y_C represents curretn state, Y_N represents next state
					
	always @(y_C or Op or Funct)
	begin: state_table
		Y_N = 4'b0000;
		PC_Write 	= 1'b0;
		Mem_Write 	= 1'b0;
		IorD 		= 1'b0;
		IR_Write 	= 1'b0;
		PC_Src 		= 1'b0;
		Branch 		= 1'b0;
		ALU_Control 	= 3'b000;
		ALU_SrcB 	= 2'b00;
		ALU_SrcA 	= 1'b0;
		Reg_Write 	= 1'b0;
		Mem_Reg 	= 1'b0; 
		Reg_Dst 	= 2'b00;
		PC_J 		= 1'b0;
		Zero_Ext 	= 2'b00;
		
		case(y_C)
			IF: begin
				PC_Write 	= 1'b1;
				Mem_Write 	= 1'b0;
				IorD 		= 1'b0;
				IR_Write 	= 1'b1;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				ALU_Control 	= 3'b001;
				ALU_SrcB 	= 2'b01;
				ALU_SrcA 	= 1'b0;
				Reg_Write 	= 1'b0;
				Mem_Reg 	= 1'b0; 
				Reg_Dst 	= 2'b00;
				PC_J 		= 1'b1;
				Zero_Ext 	= 2'b00;
				Y_N = ID;
			end
			
			ID: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 		= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				ALU_Control 	= 3'b001;
				ALU_SrcB 	= 2'b11;
				ALU_SrcA 	= 1'b0;
				Reg_Write 	= 1'b0;
				Mem_Reg 	= 1'b0;
				Reg_Dst 	= 2'b00;
				PC_J 		= 1'b1;
				Zero_Ext 	= 2'b00;
				
				if (Op == 6'h04) 
				begin // BEQ
				Y_N = BEQ;
				end
				
				else if(Op == 6'h02 | Op == 6'h03)
				begin // JMP
				Y_N = JMP;
				end
				
				else
				begin
				Y_N = EX;
				end
			end
			
			BEQ: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 		= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b1;
				Branch 		= 1'b1;
				ALU_Control 	= 3'b100;
				ALU_SrcB 	= 2'b00;
				ALU_SrcA 	= 1'b1;
				Reg_Write 	= 1'b0;
				Mem_Reg 	= 1'b0;
				Reg_Dst 	= 2'b00;
				PC_J 		= 1'b1;
				Y_N = IF;
			end

			JMP: begin
				PC_Write 	= 1'b1;
				Mem_Write 	= 1'b0;
				IorD 		= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b1;
				Branch 		= 1'b0;
				ALU_Control 	= 3'b000;
				ALU_SrcB 	= 2'b11;
				ALU_SrcA 	= 1'b0;
				Reg_Write 	= 1'b0;
				Mem_Reg 	= 1'b0;
				Reg_Dst 	= 2'b00;
				PC_J 		= 1'b0;
				
				if (Op == 6'h03)
				begin
				Y_N = JAL;
				end

				else
				begin
				Y_N = IF;
				end
			end

			JAL: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 		= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				ALU_Control 	= 3'b111;
				ALU_SrcB 	= 2'b11;
				ALU_SrcA 	= 1'b0;
				Reg_Write 	= 1'b0; //1
				Mem_Reg 	= 1'b0;
				Reg_Dst 	= 2'b10;
				PC_J 		= 1'b0;
				Zero_Ext 	= 2'b00;
				
				Y_N = WB;
			end
			EX: begin
				PC_Write 	= 1'b0;
				Mem_Write 	= 1'b0;
				IorD 		= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				Reg_Write 	= 1'b0;
				PC_J 		= 1'b1;
				Y_N = WB;
				
				
				if(Op == 6'h0 && Funct == 6'h20)
				begin	// ADD
					ALU_Control 	= 3'b001;
					ALU_SrcB 	= 2'b00;
					ALU_SrcA 	= 1'b1;
					Mem_Reg 	= 1'b0;
					Reg_Dst 	= 2'b01;
					Zero_Ext 	= 2'b00;
					Y_N = WB;
				end
				
				else if (Op == 6'h08 || Op == 6'h09)
				begin //ADDI & ADDIU
					ALU_Control 	= 3'b001;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Mem_Reg 	= 1'b0;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b00;
					Y_N = WB;
				end	
				
				else if (Op == 6'h0d)
				begin //ORI
					ALU_Control 	= 3'b011;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Mem_Reg 	= 1'b0;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b01;
					Y_N = WB;
				end
				
				else if (Op == 6'h0f)
				begin //LUI
					ALU_Control 	= 3'b001;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Mem_Reg 	= 1'b0;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b10;
					Y_N = WB;
				end
				
				else if (Op == 6'h0c)
				begin //ANDI
					ALU_Control 	= 3'b010;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Mem_Reg 	= 1'b0;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b01;
					Y_N = WB;
				end
				
				if (Op == 6'h0 && Funct == 6'h08) 
				begin // JR
					ALU_Control 	= 3'b011;
					ALU_SrcB 	= 2'b00;
					ALU_SrcA 	= 1'b1;
					Mem_Reg 	= 1'b0;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b01;
					Y_N = WB;
				end
				
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
				IorD 		= 1'b0;
				IR_Write 	= 1'b0;
				PC_Src 		= 1'b0;
				Branch 		= 1'b0;
				Reg_Write 	= 1'b1;
				Mem_Reg 	= 1'b0;
				PC_J 		= 1'b1;
				
				
				if(Op == 6'h0 && Funct == 6'h20) 
				begin // add
					ALU_Control 	= 3'b001;
					ALU_SrcB 	= 2'b00;
					ALU_SrcA 	= 1'b1;
					Reg_Dst		= 2'b01;
					Zero_Ext 	= 2'b00;
					Y_N = IF;
				end
				
				else if(Op == 6'h8 || Op == 6'h09) 
				begin // addi & addiu
					ALU_Control 	= 3'b001;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Reg_Dst		= 2'b00;
					Zero_Ext 	= 2'b00;
					Y_N = IF;
				end
				
				else if (Op == 6'h0d)
				begin //ORI
					ALU_Control 	= 3'b011;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b01;
					Y_N = IF;
				end
				
				else if (Op == 6'h0f)
				begin //LUI
					ALU_Control 	= 3'b001;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b10;
					Y_N = IF;
				end
				
				else if (Op == 6'h0c)
				begin //ANDI
					ALU_Control 	= 3'b010;
					ALU_SrcB 	= 2'b10;
					ALU_SrcA 	= 1'b1;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b01;
					Y_N = IF;
				end
				
				if (Op == 6'h0 && Funct == 6'h08) 
				begin // JR
					ALU_Control 	= 3'b010;
					ALU_SrcB 	= 2'b00;
					ALU_SrcA 	= 1'b1;
					Reg_Dst 	= 2'b00;
					Zero_Ext 	= 2'b01;
					Y_N = IF;
				end
			
				if (Op == 6'h03)
				begin // JAL
					ALU_Control 	= 3'b111;
					ALU_SrcB 	= 2'b11;
					ALU_SrcA 	= 1'b0;
					Reg_Dst 	= 2'b10;
					Zero_Ext 	= 2'b00;
					Y_N = IF;
				end
				
			end
			
			default: Y_N = 4'b0000;
		endcase
	end 
	
	always@(posedge clk or negedge rst)
	begin: state_FFs
		if(rst == 0)
			y_C <= IF;
		else 
			y_C <= Y_N;
	end // state_FFs


endmodule
