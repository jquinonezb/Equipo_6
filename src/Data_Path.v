module Data_Path
(
	//Inputs
	input clk,
	input reset,
	
	/********* SEÑALES DE CONTROL *********/
	/*********                    *********/
	/*input Selector_Addr, 
			enable_MemSys, 
			enable_RegIns, 
			Branch,
			enable_RF, 
			Selector_RF_WR, 
			Selector_ALU_Src_A, 
			Selector_PC_Source,
			Selector_RF_WD, 
			PC_Write,	
	input [1:0] Selector_ALU_Src_B,
	input [2:0] Selector_ALU_Op,*/
	
	//Output
	
	output [7:0] GPIO_o
);

wire [31:0]	PC_o, 
				Mux1_o, 
				Mem_o, 
				Ins_Reg_o,
				Data_Reg_o,
				Mux_RF_WD,
				Data1_o, 
				Data2_o,
				Reg_A_o,
				Reg_B_o,
				Src_A,
				Src_B,
				ALU_o,
				Reg_ALU_o,
				PC_source_o,
				Sign_Extend_o,
				Zero_Extend_o,
				Zero_or_Sign,
				PC_source_j;
				
wire [4:0]	Mux2_o;
/*wire 	AND_o,
		enable_PC,
		Zero;*/

wire	enable_PC, 
		Selector_Addr, 
		enable_MemSys, 
		enable_RegIns, 
		Branch,
		enable_RF, 
		Selector_RF_WR, 
		Selector_ALU_Src_A, 
		Selector_PC_Source,
		Selector_RF_WD, 
		PC_Write,
		AND_o,
		Zero,
		enable_j,
		en_zero_sign;
		
wire [1:0] Selector_ALU_Src_B;
wire [2:0] Selector_ALU_Op;

// PROGRAM COUNTER
Program_counter 	PC(.D(PC_source_o), .clk(clk), .reset(reset), .enable(enable_PC), .Q(PC_o));

//MUX TO CHOOSE WHICH DATA IS GOING TO BE GIVEN TO THE MEMORY SYSTEM
MUX2_1		Address_MUX(.data_1(ALU_o), .data_2(PC_o), .selector(Selector_Addr), .data_o(Mux1_o));

//MEMORY SYSTEM
Memory_system	Memories(.write_enable_i(enable_MemSys), .clock(clk), .Write_Data(Reg_B_o), .Address_i(Mux1_o), .Instruction_o(Mem_o)); 

//REGISTER CONTAINS THE INSTRUCTION OF THE MEMORY SYSTEM
Register 	Inst_Reg(.Rd(Mem_o), .clk(clk), .reset(reset), .enable(enable_RegIns), .Q1(Ins_Reg_o));

//DATA REGISTER
Register_W_en 	Data(.D(Mem_o), .clk(clk), .reset(reset), .Q(Data_Reg_o));

//REGISTER FILE
Register_File	RF(
	.clk(clk),
	.reset(reset),
	.Reg_Write_i(enable_RF), 	
	.Read_Register_1_i(Ins_Reg_o[25:21]),
	.Read_Register_2_i(Ins_Reg_o[20:16]),
	.Write_Register_i(Mux2_o),
	.Write_Data_i(Mux_RF_WD),
	.Read_Data_1_i(Data1_o),
	.Read_Data_2_i(Data2_o)
);

//MUX WRITE_REGISTER -> REG_FILE
MUX2_1	#(.WIDTH(5))	MUX_IR(.data_1(Ins_Reg_o[15:11]), .data_2(Ins_Reg_o[20:16]), .selector(Selector_RF_WR), .data_o(Mux2_o));

//MUX WRITE_DATA -> REG_FILE
MUX2_1		MUX_DATA(.data_1(Data_Reg_o), .data_2(Reg_ALU_o), .selector(Selector_RF_WD), .data_o(Mux_RF_WD));

// REGISTER A AND B FOR THE OUTPUT OF REGISTER FILE
Register_W_en 	Read_Data_A(.D(Data1_o), .clk(clk), .reset(reset), .Q(Reg_A_o));
Register_W_en 	Read_Data_B(.D(Data2_o), .clk(clk), .reset(reset), .Q(Reg_B_o));

//MUX2_1 TO CHOOSE INPUT DATA A TO ALU
MUX2_1		Source_A(.data_1(Reg_A_o), .data_2(PC_o), .selector(Selector_ALU_Src_A), .data_o(Src_A));

//MUX4_1 TO CHOOSE INPUT DATA B TO ALU
MUX4_1		Source_B(.data_1(Reg_B_o), .data_2(Zero_or_Sign), .dato_3(Sign_Extend_o << 2), .selector(Selector_ALU_Src_B), .data_o(Src_B));

//ALU
ALU		Alu_mod(.data_a(Src_A), .data_b(Src_B), .select(Selector_ALU_Op), .y(ALU_o), .zero(Zero));

//REGISTER ALU OUT
Register_W_en 	Read_ALU_Output(.D(ALU_o), .clk(clk), .reset(reset), .Q(Reg_ALU_o));

//MUX TO DECIDE PROGRAMM COUNTER SOURCE
MUX2_1		PC_Source(.data_1(Reg_ALU_o), .data_2(ALU_o), .selector(Selector_PC_Source), .data_o(PC_source_j));

//SIGN_EXTEND
Sign_Extend		SE(.Sign_Ext_i(Ins_Reg_o[15:0]), .Sign_Ext_o(Sign_Extend_o));

//ZERO_EXTEND
Zero_Extend		ZE(.Zero_Ext_i(Ins_Reg_o[15:0]), .Zero_Ext_o(Zero_Extend_o));

//Control Unit
ControlUnit2 FSM( 
					.clk(clk), 
					.rst(reset),
					.Op(Ins_Reg_o[31:26]), 
					.Funct(Ins_Reg_o[5:0]),
					.IorD(Selector_Addr),
					.Mem_Write(enable_MemSys),
					.IR_Write(enable_RegIns),
					.PC_Write(PC_Write),
					.PC_Src(Selector_PC_Source),
					.Branch(Branch),
					.ALU_SrcA(Selector_ALU_Src_A),
					.Reg_Write(enable_RF),
					.Mem_Reg(Selector_RF_WD),
					.Reg_Dst(Selector_RF_WR),
					.ALU_Control(Selector_ALU_Op),
					.ALU_SrcB(Selector_ALU_Src_B),
					.enable_j(enable_j),
					.en_zero_sign(en_zero_sign)
);

and Comp1 (AND_o, Branch, Zero);
or Comp2 (enable_PC, PC_Write, AND_o);

//Datapath Output to GPIO

//MUX PC ENABLE
MUX2_1		Jump(.data_1(PC_source_j), .data_2( { {4{1'b0}}, Ins_Reg_o[25:0], {2{1'b0}} } ), .selector(enable_j), .data_o(PC_source_o));

//MUX TO CHOOSE SIGN_EXT OR ZERO_EXT 
MUX2_1		Zero_Ext(.data_1(Zero_Extend_o), .data_2(Sign_Extend_o), .selector(en_zero_sign), .data_o(Zero_or_Sign));

assign GPIO_o = ALU_o[7:0];

endmodule 
