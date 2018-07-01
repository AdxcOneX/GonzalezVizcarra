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
	parameter MEMORY_DEPTH = 32
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
// Data types to connect modules
wire BranchNE_wire;
wire BranchEQ_wire;
//
wire RegDst_wire;
wire MemtoReg_wire;
//
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
//
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire Zero_wire;
wire PCSrc;

wire J_wire;//
wire Jr_wire;//

wire MemRead_wire;//
wire MemWrite_wire;//

wire [3:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;

wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;
wire [31:0] BranchToPC_wire;

wire [31:0] Shift_wire;//
wire [31:0] Shift_Mux_wire;//

wire [31:0] MUX_Branch_Jump_wire;//

wire [31:0] Mux_WriteData_wire;
wire [31:0] MUX_NewPC_wire;
wire [31:0] MUX_Jr_wire;//

integer ALUStatus;

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.Funct(Instruction_wire[5:0]),
	.RegDst(RegDst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.MemWrite(MemWrite_wire),
	.MemRead(MemRead_wire),
	.MemtoReg(MemtoReg_wire),
	.J(J_wire),
	.Jr(Jr_wire)
);

PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.NewPC(MUX_PC_wire),
	.PCValue(PC_wire)
);
ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)//revisar
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4)	,
	
	.Result(PC_4_wire)
);
Adder32bits
Adder_Branch
(
	.Data0(PC_4_wire),
	.Data1(Shift_wire),
	.Result(PCtoBranch_wire)//Todos los cables ya estaban instanciados
);
//Instranciar sumador con mux respectivo de PCSrc
ANDGate
AndBEQ
(
	.A(Zero_wire),
	.B(BranchEQ_wire),
	.C(ZeroANDBrachEQ)
);
ANDGate
AndBNE
(
	.A(~Zero_wire), //Negar zero wire?
	.B(BranchNE_wire),
	.C(NotZeroANDBrachNE)
);
ORGate
OrBranch
(
	.A(ZeroANDBrachEQ),
	.B(NotZeroANDBrachNE),
	.C(PCSrc)
);
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//JAndBranch

Multiplexer2to1
#(
	.NBits(32)
)
MultiplexerBranch
(
	.Selector(PCSrc),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(PCtoBranch_wire),
	
	.MUX_Output(MUX_Branch_Jump_wire)
);
Multiplexer2to1
#(
	.NBits(32)
)
MultiplexerJump
(
	.Selector(J_wire),
	.MUX_Data0({PC_4_wire[31:28],Shift_Mux_wire[27:0]}),
	.MUX_Data1(MUX_Branch_Jump_wire),
	
	.MUX_Output(Jump_PC_wire) //MUX_Jr_wire
);
/*
Multiplexer2to1
#(
	.NBits(32)
)
Multiplexer_Jr
(
	.Selector(Jr_wire),
	.MUX_Data0(MUX_Jr_wire),
	.MUX_Data1(ReadData1_wire),
	
	.MUX_Output(MUX_PC_wire)
);
*/
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_wire)

);



RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(Mux_WriteData_wire),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);
//
ShiftLeft2
Shift_Branch
(
	.DataInput(InmmediateExtend_wire),
	.DataOutput(Shift_wire)
);
ShiftLeft2
Shift_Jump
(
	.DataInput(Instruction_wire[25:0]),
	.DataOutput(Shift_Mux_wire)
);
//
Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ALUSrc_wire),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);
ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire)

);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1_wire),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire),
	.shamt(Instruction_wire[10:6])
);

assign ALUResultOut = ALUResult_wire;
//
DataMemory
#(
	.DATA_WIDTH(32),
	.MEMORY_DEPTH(512)
)
Data_Memory
(
	.clk(clk),
	.WriteData(ReadData2_wire),
	.Address(ALUResult_wire),//{20'b0,ALUResult_wire[11:0]>>2}
	.MemWrite(MemWrite_wire),
	.MemRead(MemRead_wire),
	.ReadData(ReadData_Mux_wire)
);
Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadAndResult
(
	.Selector(MemtoReg_wire),
	.MUX_Data0(ALUResultOut),
	.MUX_Data1(ReadData_Mux_wire),
	
	.MUX_Output(Mux_WriteData_wire)
);

endmodule

