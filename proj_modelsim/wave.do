onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /TB_Datapath/clk_tb
add wave -noupdate -radix binary /TB_Datapath/reset_tb
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Op
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Funct
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/IorD
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Mem_Write
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/IR_Write
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/PC_Write
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/PC_Src
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Branch
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/ALU_SrcA
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Reg_Write
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Mem_Reg
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Reg_Dst
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/ALU_Control
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/ALU_SrcB
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/y_C
add wave -noupdate -expand -group Control_Unit -color Yellow /TB_Datapath/DUT/FSM/Y_N
add wave -noupdate -expand -group GPIO -color {Green Yellow} -radix hexadecimal -childformat {{{/TB_Datapath/GPIO_o_tb[7]} -radix hexadecimal} {{/TB_Datapath/GPIO_o_tb[6]} -radix hexadecimal} {{/TB_Datapath/GPIO_o_tb[5]} -radix hexadecimal} {{/TB_Datapath/GPIO_o_tb[4]} -radix hexadecimal} {{/TB_Datapath/GPIO_o_tb[3]} -radix hexadecimal} {{/TB_Datapath/GPIO_o_tb[2]} -radix hexadecimal} {{/TB_Datapath/GPIO_o_tb[1]} -radix hexadecimal} {{/TB_Datapath/GPIO_o_tb[0]} -radix hexadecimal}} -subitemconfig {{/TB_Datapath/GPIO_o_tb[7]} {-color {Green Yellow} -height 15 -radix hexadecimal} {/TB_Datapath/GPIO_o_tb[6]} {-color {Green Yellow} -height 15 -radix hexadecimal} {/TB_Datapath/GPIO_o_tb[5]} {-color {Green Yellow} -height 15 -radix hexadecimal} {/TB_Datapath/GPIO_o_tb[4]} {-color {Green Yellow} -height 15 -radix hexadecimal} {/TB_Datapath/GPIO_o_tb[3]} {-color {Green Yellow} -height 15 -radix hexadecimal} {/TB_Datapath/GPIO_o_tb[2]} {-color {Green Yellow} -height 15 -radix hexadecimal} {/TB_Datapath/GPIO_o_tb[1]} {-color {Green Yellow} -height 15 -radix hexadecimal} {/TB_Datapath/GPIO_o_tb[0]} {-color {Green Yellow} -height 15 -radix hexadecimal}} /TB_Datapath/GPIO_o_tb
add wave -noupdate -expand -group {Program Counter} -color Coral /TB_Datapath/DUT/PC/enable
add wave -noupdate -expand -group {Program Counter} -color Coral -radix hexadecimal /TB_Datapath/DUT/PC/Q
add wave -noupdate -expand -group {Instruction Register} -color {Sky Blue} /TB_Datapath/DUT/Inst_Reg/enable
add wave -noupdate -expand -group {Instruction Register} -color {Sky Blue} -radix hexadecimal /TB_Datapath/DUT/Inst_Reg/Q1
add wave -noupdate -group Reg_Dst -color {Orange Red} -radix hexadecimal /TB_Datapath/DUT/MUX_IR/data_o
add wave -noupdate -group Reg_Dst -color {Orange Red} /TB_Datapath/DUT/MUX_IR/selector
add wave -noupdate -group Mem_Reg -color {Spring Green} /TB_Datapath/DUT/MUX_DATA/selector
add wave -noupdate -group Mem_Reg -color {Spring Green} -radix hexadecimal /TB_Datapath/DUT/MUX_DATA/data_o
add wave -noupdate -expand -group {Register File} -color Cyan /TB_Datapath/DUT/RF/Reg_Write_i
add wave -noupdate -expand -group {Register File} -color Cyan -radix hexadecimal /TB_Datapath/DUT/RF/Write_Register_i
add wave -noupdate -expand -group {Register File} -color Cyan -radix hexadecimal /TB_Datapath/DUT/RF/Write_Data_i
add wave -noupdate -expand -group {Register File} -color Cyan -radix hexadecimal /TB_Datapath/DUT/RF/Read_Data_1_i
add wave -noupdate -expand -group {Register File} -color Cyan -radix hexadecimal /TB_Datapath/DUT/RF/Read_Data_2_i
add wave -noupdate -expand -group Src_A -color Aquamarine /TB_Datapath/DUT/Source_A/selector
add wave -noupdate -expand -group Src_A -color Aquamarine -radix hexadecimal /TB_Datapath/DUT/Source_A/data_o
add wave -noupdate -expand -group Src_B -color {Medium Violet Red} /TB_Datapath/DUT/Source_B/selector
add wave -noupdate -expand -group Src_B -color {Medium Violet Red} -radix hexadecimal /TB_Datapath/DUT/Source_B/data_o
add wave -noupdate -expand -group ALU -radix hexadecimal /TB_Datapath/DUT/Alu_mod/select
add wave -noupdate -expand -group ALU -radix hexadecimal /TB_Datapath/DUT/Alu_mod/y
add wave -noupdate -expand -group ALU /TB_Datapath/DUT/Alu_mod/zero
add wave -noupdate -expand -group Sign_Extended -color White -radix hexadecimal /TB_Datapath/DUT/SE/Sign_Ext_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 110
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {26 ps}
