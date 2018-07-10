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
	parameter MEMORY_DEPTH = 64 //cambiamos el tamaño del programa para que pueda caber

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
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire MemRead_wire;
wire MemWrite_wire;
wire MemtoReg_wire;
wire Jump_wire;
wire JR_Selector_wire;
wire Branch_selector_wire;
wire [31:0] ReadDataMemory_wire;
wire Zero_wire;
wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [4:0] WriteRegister_Aux_wire;
wire [31:0] shift_Instruction_wire;
wire [31:0] MUX_PC_wire;
wire [31:0] Jump_PC_wire;
wire [31:0] PC_wire;
wire [31:0] PC_aux_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] PC_Branch_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;
wire [31:0] WriteData_wire;
wire [31:0] WriteData_aux_wire;

integer ALUStatus;
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
/*Intento No1 de pipeline
Iniciamos los registros de pipeline
Instanciamos las conexiones que entran a los registros PL
*/
/////////////////////////
//Registro IF/ID
/////////////////////////
	//PC
wire [31:0] IF_ID_PC_Output_wire;
	//ROM/InstructionMem
wire [31:0] IF_ID_Inst_Output_wire;
/////////////////////////
//Registro ID/EXE
/////////////////////////
	//PC
wire [31:0] ID_EX_PC_Output_wire;
	//
wire [31:0] ID_EX_Inst_Output_wire;
	//RegisterFile
wire [31:0] ID_EX_ReadData1_Output_wire;
wire [31:0] ID_EX_ReadData2_Output_wire;
	//SignExtend
wire [31:0] ID_EX_InmmediateExtend_Output_wire;
	//
wire [4:0]  ID_EX_WriteRegister_Output_wire;
	/////////////////////////
	//Control
	wire ID_EX_ALUSrc_wire;
	wire ID_EX_BranchNE_wire;
	wire ID_EX_BranchEQ_wire;
	wire ID_EX_Jump_wire;
	wire ID_EX_MemRead_wire;
	wire ID_EX_MemWrite_wire;
	wire ID_EX_RegWrite_wire;
	wire ID_EX_MemtoReg_wire;
	wire [2:0] ID_EX_ALUOp_wire;
///////////////////////////
//Retro para WriteReg
wire [4:0] ID_EXE_Instruction_20_16_wire;		//se necesitara un mux mas adelante
wire [4:0] ID_EXE_Instruction_15_11_wire;
/////////////////////////
//Registro EXE/MEM
/////////////////////////
	//PC
wire [31:0] EX_MEM_PC_4_Output_wire;
	//adder
wire [31:0] EX_MEM_PC_Output_wire;
	//ALU
wire [31:0] EX_MEM_AluResult_Output_wire;
wire EX_MEM_Zero_Output_wire;
	//RegFile
wire [31:0] EX_MEM_ReadData1_Output_wire;
wire [31:0] EX_MEM_ReadData2_Output_wire;
//
wire [31:0] EX_MEM_Inst_Output_wire;
//
	/////////////////////////
	//Control
	wire EX_MEM_Jump_wire;
	wire EX_MEM_MemRead_wire;
	wire EX_MEM_MemWrite_wire;
	wire EX_MEM_RegWrite_wire;
	wire EX_MEM_MemtoReg_wire;
	wire EXE_MEM_BranchEQ_NE_wire;
///////////////////////////
//Retro para WriteReg
wire [4:0] EX_MEM_WriteRegister_Output_wire;
/////////////////////////
//Registro MEM/WriteBack
/////////////////////////
	//PC
wire [31:0] MEM_WB_PC_4_Output_wire;
	//ALU
wire [31:0] MEM_WB_AluResult_Output_wire;
	//RAM
wire [31:0] MEM_WB_ReadData_Output_wire;
	/////////////////////////
	//Control
	wire MEM_WB_RegWrite_wire;
	wire MEM_WB_MemtoReg_wire;
///////////////////////////
//Retro para WriteReg
wire [4:0]  MEM_WB_WriteRegister_Output_wire;

//Se agregan los wires necesarios
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//AGREGAR MODULO EXTRA PIPEREG PARA LAS CONEXIONES
Control // cerebro del sistema
ControlUnit
(
	.OP(IF_ID_Inst_Output_wire[31:26]),
	.RegDst(RegDst_wire),
	.BranchEQ_NE(BranchEQ_NE_wire),
	.MemRead(MemRead_wire),
	.MemtoReg(MemtoReg_wire),
	.MemWrite(MemWrite_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.Jump(Jump_wire),
	.RegWrite(RegWrite_wire)
);

PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.NewPC(Jump_PC_wire),

	.PCValue(PC_wire)
);
/////////////////////////////////////////////////////
//SEGMENTO DE PIPELINE_REG
//Usamos estos para la entrada y datos
//N varia dependiendo de las entradas
//No podemos usar los registros del PC ya que estos se habilitan en los flancos de bajada
/////////////////////////
//Registro IF/ID
/////////////////////////
IF_ID_Register
#(
	.N(32)
)
IF_ID_PipeRegister
(
	.clk(clk),
	.reset(reset),
	//Input
	.IF_ID_PC_Input(PC_4_wire),
	.IF_ID_Inst_Input(Instruction_wire),	
	//Output
	.IF_ID_PC_Output(IF_ID_PC_Output_wire),
	.IF_ID_Inst_Output(IF_ID_Inst_Output_wire)
);
/////////////////////////
//Registro ID/EXE
/////////////////////////
ID_EX_Register
#(
	.N(32)
)
ID_EXE_PipeRegister
(
	.clk(clk),
	.reset(reset),
	//Input
		//Control
	.ID_EX_MemRead_Input(MemRead_Stall_wire),
	.ID_EX_MemWrite_Input(MemWrite_Stall_wire),
	.ID_EX_BranchNE_Input(BranchNE_Stall_wire),
	.ID_EX_BranchEQ_Input(BranchEQ_Stall_wire),
	.ID_EX_RegWrite_Input(RegWrite_Stall_wire),
	.ID_EX_MemtoReg_Input(MemtoReg_Stall_wire),
	.ID_EX_ALUSrc_Input(ALUSrc_Stall_wire),
	.ID_EX_ALUOp_Input(ALUOp_Stall_wire),
	.ID_EX_Jump_Input(Jump_Stall_wire),
		//Modulos
	.ID_EX_PC_Input(IF_ID_PC_Output_wire),
	.ID_EX_Inst_Input(IF_ID_Inst_Output_wire),
	.ID_EX_InmmediateExtend_Input(InmmediateExtend_wire),
	.ID_EX_ReadData1_Input(ReadData1_wire),
	.ID_EX_ReadData2_Input(ReadData2_wire),
	.ID_EX_WriteRegister_Input(WriteRegister_Aux_wire),

	//Output
		//Control
	.ID_EX_MemRead_Output(ID_EX_MemRead_wire),
	.ID_EX_MemWrite_Output(ID_EX_MemWrite_wire),
	.ID_EX_RegWrite_Output(ID_EX_RegWrite_wire),
	.ID_EX_MemtoReg_Output(ID_EX_MemtoReg_wire),
	.ID_EX_ALUSrc_Output(ID_EX_ALUSrc_wire),
	.ID_EX_ALUOp_Output(ID_EX_ALUOp_wire),
	.ID_EX_BranchNE_Output(ID_EX_BranchNE_wire),
	.ID_EX_BranchEQ_Output(ID_EX_BranchEQ_wire),
		//
	.ID_EX_PC_Output(ID_EX_PC_Output_wire),
	.ID_EX_Inst_Output(ID_EX_Inst_Output_wire),
	.ID_EX_InmmediateExtend_Output(ID_EX_InmmediateExtend_Output_wire),
	.ID_EX_ReadData1_Output(ID_EX_ReadData1_Output_wire),
	.ID_EX_ReadData2_Output(ID_EX_ReadData2_Output_wire),
	.ID_EX_WriteRegister_Output(ID_EX_WriteRegister_Output_wire)

);
/////////////////////////
//Registro EXE/MEM
/////////////////////////
EX_MEM_Register
#(
	.N(32)
)
EXE_MEM_PipeRegister
(
	.clk(clk),
	.reset(reset),
	//Input
		//Control
	.EX_MEM_BranchNE_Input(ID_EX_BranchNE_wire),
	.EX_MEM_BranchEQ_Input(ID_EX_BranchEQ_wire),
	.EX_MEM_Jump_Input(ID_EX_Jump_wire),
	.EX_MEM_MemRead_Input(ID_EX_MemRead_wire),
	.EX_MEM_MemWrite_Input(ID_EX_MemWrite_wire),
	.EX_MEM_RegWrite_Input(ID_EX_RegWrite_wire),
	.EX_MEM_MemtoReg_Input(ID_EX_MemtoReg_wire),
		//Modulos
	.EX_MEM_PC_4_Input(ID_EX_PC_Output_wire),
	.EX_MEM_PC_Input(PC_Branch_wire),
	.EX_MEM_Zero_Input(Zero_wire),
	.EX_MEM_AluResult_Input(ALUResult_wire),
	.EX_MEM_ReadData2_Input(B_ALU_Mux_Forward_wire),
	.EX_MEM_ReadData1_Input(ReadData1_wire),
	.EX_MEM_Inst_Input(ID_EX_Inst_Output_wire),
	.EX_MEM_WriteRegister_Input(ID_EX_WriteRegister_Output_wire),
	//Output
	.EX_MEM_BranchNE_Output(EX_MEM_BranchNE_wire),
	.EX_MEM_BranchEQ_Output(EX_MEM_BranchEQ_wire),
	.EX_MEM_Jump_Output(EX_MEM_Jump_wire),
	.EX_MEM_MemRead_Output(EX_MEM_MemRead_wire),
	.EX_MEM_MemWrite_Output(EX_MEM_MemWrite_wire),
	.EX_MEM_RegWrite_Output(EX_MEM_RegWrite_wire),
	.EX_MEM_MemtoReg_Output(EX_MEM_MemtoReg_wire),
		//Modulos
	.EX_MEM_PC_4_Output(EX_MEM_PC_4_Output_wire),
	.EX_MEM_PC_Output(EX_MEM_PC_Output_wire),
	.EX_MEM_Zero_Output(EX_MEM_Zero_Output_wire),
	.EX_MEM_AluResult_Output(EX_MEM_AluResult_Output_wire),
	.EX_MEM_ReadData2_Output(EX_MEM_ReadData2_Output_wire),
	.EX_MEM_ReadData1_Output(EX_MEM_ReadData1_Output_wire),
	.EX_MEM_Inst_Output(EX_MEM_Inst_Output_wire),
	.EX_MEM_WriteRegister_Output(EX_MEM_WriteRegister_Output_wire)

	);
/////////////////////////
//Registro MEM/WriteBack
/////////////////////////
MEM_WB_Register
#(
	.N(32)
)
MEM_WB_PipeRegister
(
	.clk(clk),
	.reset(reset),
	//Input
		//Control
	.MEM_WB_RegWrite_Input(EX_MEM_RegWrite_wire),
	.MEM_WB_MemtoReg_Input(EX_MEM_MemtoReg_wire),
		//Modulos
	.MEM_WB_PC_4_Input(EX_MEM_PC_4_Output_wire),
	.MEM_WB_ReadData_Input(ReadDataMemory_wire),
	.MEM_WB_AluResult_Input(EX_MEM_AluResult_Output_wire),
	.MEM_WB_WriteRegister_Input(WriteRegister_wire),

	//Output
		//Control
	.MEM_WB_RegWrite_Output(MEM_WB_RegWrite_wire),
	.MEM_WB_MemtoReg_Output(MEM_WB_MemtoReg_wire),
		//Modulos
	.MEM_WB_PC_4_Output(MEM_WB_PC_4_Output_wire),
	.MEM_WB_ReadData_Output(MEM_WB_ReadData_Output_wire),
	.MEM_WB_AluResult_Output(MEM_WB_AluResult_Output_wire),
	.MEM_WB_WriteRegister_Output(MEM_WB_WriteRegister_Output_wire)

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

ShiftLeft2 
Shift_Inst //shift a sumador branch
(
	.DataInput({6'b0,IF_ID_Inst_Output_wire[25:0]}), //Instruction_wire => IF_ID_Inst_Output_wire
	.DataOutput(shift_Instruction_wire)
);

assign PCSrc_wire = (EX_MEM_Zero_Output_wire & EX_MEM_BranchEQ_wire) | (!EX_MEM_Zero_Output_wire & EX_MEM_BranchNE_wire);

Adder32bits
PC_Adder_Branch
(
	.Data0(ID_EX_PC_Output_wire),
	.Data1(ID_EX_InmmediateExtend_Output_wire << 2),
	
	.Result(PC_Branch_wire)

);

Multiplexer2to1 //seleccionamos cual sera la siguiente instruccion 
#(
	.NBits(32)
)
Branch_OR_PC
(
	.Selector(PCSrc_wire),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(EX_MEM_PC_Output_wire),

	.MUX_Output(MUX_PC_wire)
);


Multiplexer2to1 //seleccionamos entre pc o jump
#(
	.NBits(32)
)
MUX_PCJump
(
	.Selector(Jump_wire),
	.MUX_Data0(MUX_PC_wire),
	.MUX_Data1({IF_ID_PC_Output_wire[31:28],shift_Instruction_wire[27:0]}),

	.MUX_Output(Jump_PC_wire)
);

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Multiplexer2to1 //seleccionamos en que registro debemos escribir
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(IF_ID_Inst_Output_wire[20:16]),
	.MUX_Data1(IF_ID_Inst_Output_wire[15:11]),
	
	.MUX_Output(WriteRegister_Aux_wire)

);

Multiplexer2to1 //vemos si vamos a hacer jal o ejecutaremos la siguiente instruccion
#(
	.NBits(32)
)
MUX_ForJalAndReadData_AlUResult
(
	.Selector(JumpJal_wire), //este cable sale de inst
	.MUX_Data0(MUX_ReadData_ALUResult_wire),
	.MUX_Data1(PC_4_wire),

	.MUX_Output(MUX_Jal_ReadData_ALUResult_wire)
);

Multiplexer2to1 //seleccionamos el registro en el que escribiremos
#(
	.NBits(5)
)
MUX_WriteRegister_Ra
(
	//Mux para Jr solucionado utilizando un wire del writeReg
	.Selector(EX_MEM_Jump_wire),
	.MUX_Data0(WriteData_aux_wire),
	.MUX_Data1(MEM_WB_PC_4_Output_wire), //31 para obtener Ra

	.MUX_Output(WriteData_wire)
);
//
Multiplexer2to1 //seleccionamos si vamos a leer de los registros o el valor de inmediato
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ID_EX_ALUSrc_wire),
	.MUX_Data0(B_ALU_Mux_Forward_wire),
	.MUX_Data1(ID_EX_InmmediateExtend_Output_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);
//
Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForALUResultAndReadData //seleccionamos que resultado debemos enviar para escribir
(
	.Selector(MEM_WB_MemtoReg_wire),
	.MUX_Data0(MEM_WB_AluResult_Output_wire),
	.MUX_Data1(MEM_WB_ReadData_Output_wire),

	.MUX_Output(WriteData_aux_wire)
);
//
Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJR
(
	.Selector(JR_Selector_wire),
	.MUX_Data0(Jump_PC_wire),
	.MUX_Data1(EX_MEM_ReadData1_Output_wire), //ReadData1_wire => EX_MEM_ReadData1_Output_wire
	
	.MUX_Output(PC_aux_wire)

);
//
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForJType
(
	.Selector(EX_MEM_Jump_wire), //
	.MUX_Data0(EX_MEM_WriteRegister_Output_wire), //
	.MUX_Data1(5'b11111), //31 para obtener ra
	
	.MUX_Output(WriteRegister_wire) //

);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(MEM_WB_RegWrite_wire),
	.WriteRegister(MEM_WB_WriteRegister_Output_wire),
	.ReadRegister1(IF_ID_Inst_Output_wire[25:21]),
	.ReadRegister2(IF_ID_Inst_Output_wire[20:16]),
	.WriteData(WriteData_aux_wire),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(IF_ID_Inst_Output_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ID_EX_ALUOp_wire),
	.ALUFunction(ID_EX_Inst_Output_wire[5:0]),
	.ALUOperation(ALUOperation_wire),
	.JR_Selector(JR_Selector_wire)
);

ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(A_ALU_Mux_Forward_wire),
	.B(ReadData2OrInmmediate_wire),
	.shamt(ID_EX_Inst_Output_wire[10:6]),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire)
);

//Added

DataMemory //nuestra RAM
#(	 
	 .DATA_WIDTH(32),
	 .MEMORY_DEPTH(1024)

)
DataMemory
(
	//In
	.clk(clk),
	.WriteData(EX_MEM_ReadData2_Output_wire),
	.Address(EX_MEM_AluResult_Output_wire),
	.MemRead(EX_MEM_MemWrite_wire),
	.MemWrite(EX_MEM_MemWrite_wire),
	//out
	.ReadData(ReadDataMemory_wire)
);

assign ALUResultOut = ALUResult_wire;


endmodule

