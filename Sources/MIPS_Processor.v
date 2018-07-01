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
	parameter MEMORY_DEPTH = 32//
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
wire BranchEQ_wire;
wire BranchNE_wire;
//
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
//
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire Zero_wire;
wire PCSrc_wire;

wire J_wire;//
wire Jr_wire;// JR Selector wire
wire Jal_wire;

wire MemRead_wire;//
wire MemWrite_wire;//
wire RegDst_wire;//
wire MemtoReg_wire;//

wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [4:0] WriteRegister_temp_wire;

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

wire [31:0] MUX_NewPC_wire;

wire [31:0] Shift_wire;//
wire [31:0] Shift_J_wire;//

wire [31:0] MUX_Branch_Jump_wire;//
wire [31:0] MUX_ALURes;

wire [31:0] MUX_Jal_ReadData_wire;
wire [31:0] MUX_Jr_wire;//
wire [31:0] MUX_ra;
wire [31:0] MUX_Jump_PC;//salida del jump a NewPC

wire [31:0] WriteData_wire;//
wire [31:0] WriteData_aux_wire;//
wire [31:0] MUX_WriteReg;

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.RegDst(RegDst_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	//
	.BranchEQ(BranchEQ_wire),
	.BranchNE(BranchNE_wire),
	//
	.MemRead(MemRead_wire),
	.MemWrite(MemWrite_wire),
	.MemtoReg(MemtoReg_wire),
	//
	.Jump(J_wire)
);
PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.NewPC(MUX_NewPC_wire),
	.PCValue(PC_wire)
);
ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
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
	.Data1(4),
	
	.Result(PC_4_wire)
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
	.DataInput({6'b00000,Instruction_wire[25:0]}),
	.DataOutput(Shift_J_wire)
);
//
Adder32bits
Adder_Branch
(
	.Data0(PC_4_wire),
	.Data1(Shift_wire << 2), //recorremos bits ya que ocacionaba problemas con PC
	.Result(PCtoBranch_wire)//
);
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_temp_wire)

);
//
Multiplexer2to1
#(
	.NBits(5)
)
Multiplexer_JType
(
	.Selector(J_wire),
	.MUX_Data0(WriteRegister_temp_wire),
	.MUX_Data1(31), //Para Jr
	
	.MUX_Output(MUX_WriteReg) //WriteRegister_wire
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
//truco sacado de Sn internet para remplazar compuerta and
assign PCSrc_wire = (Zero_wire & BranchEQ_wire) | (!Zero_wire & BranchNE_wire);
Multiplexer2to1
#(
	.NBits(32)
)
MultiplexerBranch
(
	.Selector(PCSrc_wire),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(PCtoBranch_wire),
	
	.MUX_Output(MUX_Branch_Jump_wire) //MUX_PC_wire
);
//
Multiplexer2to1
#(
	.NBits(32)
)
Multiplexer_J
(
	.Selector(J_wire),
	.MUX_Data0({PC_4_wire[31:28],Shift_J_wire[27:0]}), //cocatenacion de valores para el mux (cuidado con la sintaxis de la coc)
	.MUX_Data1(MUX_Branch_Jump_wire),
	
	.MUX_Output(MUX_Jump_PC) //Jump PC wire
);
//
Multiplexer2to1
#(
	.NBits(32)
)
Multiplexer_Jr
(
	.Selector(Jr_wire),
	.MUX_Data0(ReadData1_wire),
	.MUX_Data1(MUX_Jump_PC),
	
	.MUX_Output(MUX_NewPC_wire) //PC aux wire
);
//
Multiplexer2to1
#(
	.NBits(32)
)
Multiplexer_ALURes //seleccionamos que resultado debemos enviar para escribir
(
	.Selector(MemtoReg_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(ReadData_wire),

	.MUX_Output(MUX_ALURes)//WriteRegister_wire
);
//
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
//
Multiplexer2to1
#(
	.NBits(32)
)
Multiplexer_WriteData
(
	.Selector(J_wire),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(Mux_WriteData_wire),
	
	.MUX_Output(WriteData_wire)
);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(MUX_WriteReg),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(WriteData_wire),//
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire),
	.JR_aux(Jr_wire)
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
//mod DataMem
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
	//output
	.ReadData(ReadData_Mux_wire)
);

endmodule

