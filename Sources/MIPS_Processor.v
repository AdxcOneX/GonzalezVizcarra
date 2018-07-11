/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		bne
*		beq
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	12/06/2016
******************************************************************/

module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 512,
	parameter DATA_WIDTH=32
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/

assign  PortOut = 0;

//******************************************************************/
//******************************************************************/

wire [31:0] w_MuxJump_PC;
wire [31:0] w_PC_ROM;
wire [31:0] w_Add_ShiftA_Add;
wire [31:0] w_ROM_Out;
wire [31:0] w_ShiftA_MuxJump;
wire [5:0]  w_ALU_Op;
wire			w_Jump;
wire			w_Branch;
wire			w_MemRead;
wire			w_MemtoReg;
wire			w_MemWrite;
wire			w_ALUSrc;
wire			w_RegWrite;
wire			w_RegDst;
wire [5:0]  w_WriteReg;
wire [31:0] w_WriteData;
wire [31:0] w_A;
wire [31:0] w_Reg_MuxALU;
wire [31:0] w_Sign;
wire [31:0] w_ShiftB;
wire [31:0] w_B;
wire [31:0] w_Add_MuxBranch;
wire			w_zero;
wire			w_PCSrc;
wire [3:0]	w_ALUControl;
wire [31:0] w_ALUResult;
wire [31:0]	w_Mux_Mux;
wire [31:0] w_RAM_Mux;
wire			w_JAL;
wire [4:0]  w_JAL_In;
wire [31:0] w_MuxJR;
wire			w_JR;

//Pipeline
wire [31:0] w_Ins_Out;
wire [31:0] w_Add_4;
wire [5:0]  w_ALU_Op_Out;
wire			w_Jump_Out;
wire			w_Branch_Out;
wire			w_MemRead_Out;
wire			w_MemtoReg_Out;
wire			w_MemWrite_Out;
wire			w_ALUSrc_Out;
wire			w_RegWrite_Out;
wire			w_RegDst_Out;
wire			w_JAL_Out;
wire [31:0] w_Add_4_Out;
wire [31:0] w_ReadData1;
wire [31:0] w_ReadData2;
wire [31:0] w_Sign_Out;
wire [4:0]  w_Ex_Ins_A;
wire [4:0]  w_Ex_Ins_B;
wire [4:0]  w_Ex_Ins_C;
wire [31:0] w_MuxJump;
wire [4:0]  w_shamt;
wire			w_Branch_Out2;
wire			w_MemRead_Out2;
wire			w_MemtoReg_Out2;
wire			w_MemWrite_Out2;
wire			w_RegWrite_Out2;
wire [31:0] w_Adder;
wire [31:0] w_PC_ROM_Out;
wire [31:0] w_PC_ROM_Out2;
wire			w_Zero_Out;
wire [31:0] w_ALUResult_Out;
wire [5:0]  w_Mux_WriteReg;
wire			w_MemtoReg_Out3;
wire			w_RegWrite_Out3;
wire [31:0] w_RAM_WB;
wire [31:0] w_ALUResult_WB;
wire [5:0]  w_WriteReg_Out;
wire [31:0] w_ReadData2_Out;
wire			w_Hazard_PCWrite;
wire [31:0] w_NewPC;
wire			w_IFID_enable;
wire			w_HazardMux;
wire [14:0] w_Control;
wire [1:0]  w_Mux3to1A;
wire [1:0]  w_Mux3to1B;
wire [31:0] w_A_OUT;
wire [31:0] w_B_OUT;



//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/

PC_Register
ProgramCounter
(
	//Input
	.clk(clk),
	.reset(reset),
	.Hazard_flag(w_Hazard_PCWrite),
	.NewPC(/*w_NewPC*/w_MuxJR),
	//Output
	.PCValue(w_PC_ROM)
);

Adder32bits
Add_PC
(
	//Input
	.Data0(w_PC_ROM),
	.Data1(4),
	//Output
	.Result(w_Add_4)
);

ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROM
(
	//Input
	.Address(w_PC_ROM),
	//Output
	.Instruction(w_ROM_Out)
);

ShiftLeft2Cat
ShiftA
(
	//Input
	//.DataInput(w_ROM_Out[25:0]),
	.DataInput(w_Ins_Out),
	//.Concatenate(w_Add_ShiftA_Add[31:28]),
	//Output
	.DataOutput(w_ShiftA_MuxJump)
);

Control
ControlUnit
(
	//Input
	.OP(w_Ins_Out[31:26]),
	//Output
	.ALUOp(w_ALU_Op),
	.Jump(w_Jump),
	.Branch(w_Branch),
	.MemRead(w_MemRead),
	.MemtoReg(w_MemtoReg),
	.MemWrite(w_MemWrite),
	.ALUSrc(w_ALUSrc),
	.RegWrite(w_RegWrite),
	.RegDst(w_RegDst),
	.Jal(w_JAL)
);

Multiplexer2to1
MuxReg
(
	//Input
	.Selector(w_RegDst_Out),
	.Data0(w_Ex_Ins_A),	//PIPE Change
	.Data1(w_Ex_Ins_B),	//PIPE Change
	//Output
	.OUT(w_JAL_In)
);

RegisterFile
RegisterFile
(
	//Input
	.clk(clk),
	.reset(reset),
	.RegWrite(w_RegWrite_Out3),
	.ReadRegister1(w_Ins_Out[25:21]),
	.ReadRegister2(w_Ins_Out[20:16]),
	.WriteRegister(w_WriteReg_Out),
	.WriteData(w_WriteData),
	//Output
	.ReadData1(w_ReadData1),
	.ReadData2(w_ReadData2)
);

SignExtend
SignExtend
(
	//Input
	.DataInput(w_Ins_Out[15:0]),
	//Output
	.SignExtendOutput(w_Sign)
);

ShiftLeft2
ShiftB
(
	//Input
	.DataInput(w_Sign_Out),
	//Output
	.DataOutput(w_ShiftB)
);

Multiplexer2to1
MuxALU
(
	//Input
	.Selector(w_ALUSrc_Out),
	.Data0(w_B),
	.Data1(w_Sign_Out),
	//Output
	.OUT(w_B_OUT)
);

Adder32bits
Add
(
	//Input
	.Data0(w_Add_ShiftA_Add),
	.Data1(w_ShiftB),
	//Output
	.Result(w_Adder)
);

ANDGate
AND
(
	//Input
	.A(w_Branch_Out2),
	.B(w_zero_Out),
	//Output
	.C(w_PCSrc)
);

ALU
ALU
(
	//Input
	.A(w_A_OUT),
	.B(w_B_OUT),
	.C(w_PC_ROM_Out2),		//PCValue, used for JAL
	.ALUOperation(w_ALUControl),
	.shamt(w_shamt),	//PIPE Change
	//Output
	//.ovf(),
	.Zero(w_zero),
	.ALUResult(w_ALUResult)
);

ALUControl
ALUControl
(
	//Input
	.ALUFunction(w_Sign_Out[5:0]),	//PIPE Change
	.ALUOp(w_ALU_Op_Out),
	//Output
	.ALUOperation(w_ALUControl),
	.JrFlag(w_JR)
);

Multiplexer2to1
MuxBranch
(
	//Input
	.Data0(w_Add_4),
	.Data1(w_Add_MuxBranch),
	.Selector(w_PCSrc),
	//Output
	.OUT(w_Mux_Mux)
);

Multiplexer2to1
MuxJump
(
	//Input
	.Selector(w_Jump_Out),
	.Data0(w_Mux_Mux),
	.Data1(w_MuxJump),
	//Output
	.OUT(w_MuxJump_PC)
);

DataMemory 
#(	
   .DATA_WIDTH(DATA_WIDTH),
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
RAM
(
	//Input
	.clk(clk),
	.MemWrite(w_MemWrite_Out), // Changed to receive the flag earlier, it may rollback
	.Address(w_ALUResult_Out),
	//.WriteData(w_Reg_MuxALU), //oRIGINAL
	.WriteData(w_WriteData),
	.MemRead(w_MemRead_Out2),
	//Output
	.ReadData(w_RAM_WB)
);

Multiplexer2to1
MuxRAM
(
	//Input
	.Selector(w_MemtoReg_Out3),
	.Data0(w_ALUResult_WB),
	.Data1(w_RAM_Mux),
	//Output
	.OUT(w_WriteData)
);

Multiplexer2to1JAL
MuxJAL
(
	//Input
	.Selector(w_JAL_Out),
	.Data0(w_JAL_In),
	.Data1(31),
	//Output
	.OUT(w_Mux_WriteReg)
);
 
Multiplexer2to1
MuxJR
(
	//Input
	.Selector(w_JR),
	.Data0(w_MuxJump_PC),
	.Data1(w_ALUResult_Out),
	//Output
	.OUT(w_MuxJR)
);

//Pipeline

IF_ID
IF_ID
(
	//Input
	.clk(clk),
	.reset(reset),
	.enable(w_IFID_enable), //enable NOT
	
	.Instruction_In(w_ROM_Out),
	.PC_4_In(w_Add_4),
	.PC(w_PC_ROM),
	//Output
	.Instruction_Out(w_Ins_Out),
	.PC_4_Out(w_Add_4_Out),
	.PC_Out(w_PC_ROM_Out)
);

ID_EX
ID_EX
(
	//***Input
	.clk(clk),
	.reset(reset),
	.enable(1), //enable NOT
	
	//Control
	.RegDst(w_Control[1]),
	.Branch(w_Control[7]),
	.MemRead(w_Control[6]),
	.MemtoReg(w_Control[5]),
	.MemWrite(w_Control[4]),
	.ALUSrc(w_Control[3]),
	.RegWrite(w_Control[2]),
	.Jump(w_Control[8]),
	.Jal(w_Control[0]),
	.ALUOp(w_Control[14:9]),
	//Add 4
	.Add_4(w_Add_4_Out),
	//Register File
	.ReadData1(w_ReadData1),
	.ReadData2(w_ReadData2),
	//Sign Extend
	.SignExtendOutput(w_Sign),
	//Instruction
	.ID_Ins_C(w_Ins_Out[25:21]),
	.ID_Ins_A(w_Ins_Out[20:16]),
	.ID_Ins_B(w_Ins_Out[15:11]),
	//JumpAddress
	.JumpAddress(w_ShiftA_MuxJump),
	//shamt
	.shamt(w_Ins_Out[10:6]),
	//IF_ID
	.PC(w_PC_ROM_Out),
	
	//***Output
	//Control
	.RegDst_Out(w_RegDst_Out),
	.Branch_Out(w_Branch_Out),
	.MemRead_Out(w_MemRead_Out),
	.MemtoReg_Out(w_MemtoReg_Out),
	.MemWrite_Out(w_MemWrite_Out),
	.ALUSrc_Out(w_ALUSrc_Out),
	.RegWrite_Out(w_RegWrite_Out),
	.Jump_Out(w_Jump_Out),
	.Jal_Out(w_JAL_Out),
	.ALUOp_Out(w_ALU_Op_Out),
	//Add 4
	.Add_4_Out(w_Add_ShiftA_Add),
	//Register File
	.ReadData1_Out(w_A),
	.ReadData2_Out(w_ReadData2_Out),
	//Sign Extend
	.SignExtendOutput_Out(w_Sign_Out),
	//Instruction
	.EX_Ins_C(w_Ex_Ins_C),
	.EX_Ins_A(w_Ex_Ins_A),
	.EX_Ins_B(w_Ex_Ins_B),
	//JumpAddress
	.JumpAddress_Out(w_MuxJump),
	//shamt
	.shamt_Out(w_shamt),
	//IF_ID
	.PC_Out(w_PC_ROM_Out2)
);

EX_MEM
EX_MEM
(
	//***Input
	.clk(clk),
	.reset(reset),
	.enable(1), //enable NOT
	//Control
	.Branch(w_Branch_Out),
	.MemRead(w_MemRead_Out),
	.MemtoReg(w_MemtoReg_Out),
	.MemWrite(w_MemWrite_Out),
	.RegWrite(w_RegWrite_Out),
	//Add
	.Add(w_Adder),
	//ALU
	.Zero(w_zero),
	.ALUResult(w_ALUResult),
	//ID_EX
	.ReadData2(w_ReadData2_Out),
	//Mux
	.Mux(w_Mux_WriteReg),
	
	//***Output
	//Control
	.Branch_Out(w_Branch_Out2),
	.MemRead_Out(w_MemRead_Out2),
	.MemtoReg_Out(w_MemtoReg_Out2),
	.MemWrite_Out(w_MemWrite_Out2),
	.RegWrite_Out(w_RegWrite_Out2),
	//Add
	.Add_Out(w_Add_MuxBranch),
	//ALU
	.Zero_Out(w_Zero_Out),
	.ALUResult_Out(w_ALUResult_Out),
	//ID_EX
	.ReadData2_Out(w_Reg_MuxALU),
	//Mux
	.Mux_Out(w_WriteReg)
);

MEM_WB
MEM_WB
(
	//***Input
	.clk(clk),
	.reset(reset),
	.enable(1), //enable NOT
	//Control
	.MemtoReg(w_MemtoReg_Out2),
	.RegWrite(w_RegWrite_Out2),
	//RAM
	.ReadData(w_RAM_WB),
	//EX_MEM
	.ALUResult(w_ALUResult_Out),
	.WriteRegister(w_WriteReg),
	
	//***Output
	//Control
	.MemtoReg_Out(w_MemtoReg_Out3),
	.RegWrite_Out(w_RegWrite_Out3),
	//RAM
	.ReadData_Out(w_RAM_Mux),
	//EX_MEM
	.ALUResult_Out(w_ALUResult_WB),
	.WriteRegister_Out(w_WriteReg_Out)
);

///***Hazard Detection Unit***///
HazardDetect
HazardDU
(
	//Input
		.IDEXMemRead({w_Branch_Out, w_MemRead_Out, w_MemWrite_Out}),
		.IDEXRt(w_Ex_Ins_A),
		.IFIDRs(w_Ins_Out[25:21]),
		.IFIDRt(w_Ins_Out[20:16]),			
		
	//Output
		.HazardMux(w_HazardMux), 
		.IFIDWrite(w_IFID_enable), //**modificar para la entrada del pipe
		.PCWrite(w_Hazard_PCWrite)  //va a controlar en pc
 
);
/*
Multiplexer2to1
MuxHazardPC
(
	//Input
	.Selector(w_Hazard_PCWrite),
	.Data0(w_MuxJR),
	.Data1(0),
	//Output
	.OUT(w_NewPC)
);
*/
Multiplexer2to1
MuxControlIDEX
(
	//Input
	.Selector(w_HazardMux),
	.Data0({17'b0, w_ALU_Op, w_Jump, w_Branch, w_MemRead, w_MemtoReg, w_MemWrite, w_ALUSrc, w_RegWrite, w_RegDst, w_JAL}),
	.Data1(0),
	//Output
	.OUT(w_Control)
);

///***Forward Unit***///
//////////////////ADD THE FORWARD UNIT////////////////
ForwardUnit
ForwardUnit
(
		//input
		 .IDEXRt(w_Ex_Ins_A),
		 .IDEXRs(w_Ex_Ins_C),
		 .EXMEMRd(w_WriteReg),
		 .EXMEM_RW({/*w_MemtoReg_Out2, */w_RegWrite_Out2}),
		 .MEMWBRd(w_WriteReg_Out),
		 .MEMWB_RW({/*w_MemtoReg_Out3, */w_RegWrite_Out3}), 
		 
		//Output
		 .ForwardA(w_Mux3to1A), 
		 .ForwardB(w_Mux3to1B) 
		
);

///***Mux 3 to 1***///
Multiplexer3to1
Mux3to1A
(
	//input
	.Selector(w_Mux3to1A),
	.Data0(w_A),
	.Data1(w_WriteData),		//This might be swapped with Data0
	.Data2(w_ALUResult_Out),
	//output
	.OUT(w_A_OUT)
);

Multiplexer3to1
Mux3to1B
(
	//input
	.Selector(w_Mux3to1B),
	.Data0(w_ReadData2_Out),
	.Data1(w_WriteData), 
	.Data2(w_ALUResult_Out),
	//output
	.OUT(w_B)
);


assign ALUResultOut = w_ALUResult_Out;

endmodule