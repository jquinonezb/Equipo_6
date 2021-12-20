module Data_Path
(
	// INPUTS
	input clk,
	input reset,
	input [7:0] GPIO_i,
	// OUTPUTS
	output [7:0] GPIO_o,
	output clk_signal
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
				PC_ALU,
				Jump_o,
				Sign_Extend_o,
				Zero_Extend_o,
				Mux_SZ_Ext_o;
				
wire [4:0]	Mux2_o;

wire		enable_PC, 
		Selector_Addr, 
		enable_MemSys, 
		enable_RegIns, 
		Branch,
		enable_RF,  
		Selector_ALU_Src_A, 
		Selector_PC_Source,
		Selector_RF_WD, 
		PC_Write,
		AND_o,
		Selector_Jump,
		Zero;
		
wire [1:0] 	Selector_ALU_Src_B,
				Selector_RF_WR,
				Selector_Zero;
				
wire [2:0] 	Selector_ALU_Op;

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
MUX4_1	#(.WIDTH(5))	MUX_IR(.data_1(Ins_Reg_o[20:16]), .data_2(Ins_Reg_o[15:11]), .data_3(5'b11111), .data_4(5'b00000), .selector(Selector_RF_WR), .data_o(Mux2_o));

//MUX WRITE_DATA -> REG_FILE
MUX2_1		MUX_DATA(.data_1(Data_Reg_o), .data_2(Reg_ALU_o), .selector(Selector_RF_WD), .data_o(Mux_RF_WD));

// REGISTER A AND B FOR THE OUTPUT OF REGISTER FILE
Register_W_en 	Read_Data_A(.D(Data1_o), .clk(clk), .reset(reset), .Q(Reg_A_o));
Register_W_en 	Read_Data_B(.D(Data2_o), .clk(clk), .reset(reset), .Q(Reg_B_o));

//MUX2_1 TO CHOOSE INPUT DATA A TO ALU
MUX2_1		Source_A(.data_1(Reg_A_o), .data_2(PC_o), .selector(Selector_ALU_Src_A), .data_o(Src_A));

//MUX4_1 TO CHOOSE INPUT DATA B TO ALU
MUX4_1	#(.WIDTH(32)) Source_B(.data_1(Reg_B_o), .data_2(32'b0000_0000_0000_0000_0000_0000_0000_0100), .data_3(Mux_SZ_Ext_o), .data_4({ Mux_SZ_Ext_o[29:0], 2'b0}), .selector(Selector_ALU_Src_B), .data_o(Src_B));

//ALU
ALU		Alu_mod(.data_a(Src_A), .data_b(Src_B), .select(Selector_ALU_Op), .y(ALU_o), .zero(Zero));

//REGISTER ALU OUT
Register_W_en 	Read_ALU_Output(.D(ALU_o), .clk(clk), .reset(reset), .Q(Reg_ALU_o));

//MUX TO DECIDE PROGRAMM COUNTER SOURCE
MUX2_1		PC_Source(.data_1(Reg_ALU_o), .data_2(ALU_o), .selector(Selector_PC_Source), .data_o(PC_ALU));

//MUX TO DECIDE IF JUMP OR INSTRUCTION TYPE I,R
MUX2_1		PC_J(.data_1(PC_ALU), .data_2({ PC_o[31:28], Ins_Reg_o[25:0], {2{1'b0}} }), .selector(Selector_Jump), .data_o(PC_source_o));

//SIGN_EXTEND
Sign_Extend		SE(.Sign_Ext_i(Ins_Reg_o[15:0]), .Sign_Ext_o(Sign_Extend_o));

//ZERO EXTEND
Zero_extend 		ZE_EXT(.GPIO_i(Ins_Reg_o[15:0]), .Zero_Ext(Zero_Extend_o)); // GPIO_i

//MUX TO DECIDE IF GPIO OR SIGN EXTEND 
MUX4_1		GPIO_SIGN(.data_1(Sign_Extend_o), .data_2(Zero_Extend_o), .data_3( { Ins_Reg_o[15:0], {16{1'b0}} }), .data_4({32{1'b0}}), .selector(Selector_Zero), .data_o(Mux_SZ_Ext_o));

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
					.PC_J(Selector_Jump),
					.ALU_Control(Selector_ALU_Op),
					.ALU_SrcB(Selector_ALU_Src_B),
					.Zero_Ext(Selector_Zero)
);

and Comp1 (AND_o, Branch, Zero);
or Comp2 (enable_PC, PC_Write, AND_o);


//Datapath Output to GPIO

assign GPIO_o = ALU_o[7:0];
endmodule 
