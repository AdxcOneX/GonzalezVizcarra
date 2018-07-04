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
wire BranchEQ_NE_wire;
wire MemRead_wire;
wire MemtoReg_wire;
wire MemWrite_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire PCSrc_wire;
wire RegWrite_wire;
wire Jump_wire;
wire JumpR_wire;
wire JumpJal_wire;
wire Zero_wire;
wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [4:0] MUX_Ra_WriteRegister_wire;
wire [31:0] MUX_PC_wire;
wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] ReadData_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;
wire [31:0] MUX_ReadData_ALUResult_wire;
wire [31:0] PC_Shift2_wire;
wire [31:0] ShiftLeft2_SignExt_wire;
wire [31:0] Shift_J_wire;
wire [31:0] MUX_to_PC_wire;
wire [31:0] MUX_to_MUX_wire;
wire [31:0] MUX_ForRetJumpAndJump;
wire [31:0] MUX_Jal_ReadData_ALUResult_wire;
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
wire [31:0] IF_ID_PC_4_wire;
	//ROM/InstructionMem
wire [31:0] IF_ID_Inst_wire;
/////////////////////////
//Registro ID/EXE
/////////////////////////
	//PC
wire [31:0] ID_EXE_PC_4_wire;
	//RegisterFile
wire [31:0] ID_EXE_ReadData1_wire;
wire [31:0] ID_EXE_ReadData2_wire;
	//SignExtend
wire [31:0] ID_EXE_InmmediateExtend_wire;
	/////////////////////////
	//Control
	wire ID_EXE_RegWrite_wire;
	wire ID_EXE_MemWrite_wire;
	wire ID_EXE_MemtoReg_wire;
	wire ID_EXE_BranchEQ_NE_wire;
	wire ID_EXE_RegDst_wire;
	wire ID_EXE_ALUOp_wire;
	wire ID_EXE_ALUSrc_wire;
	wire ID_EXE_MemRead_wire;
///////////////////////////
//Retro para WriteReg
wire [4:0]  ID_EXE_Instruction_20_16_wire;		//se necesitara un mux mas adelante
wire [4:0]  ID_EXE_Instruction_15_11_wire;
/////////////////////////
//Registro EXE/MEM
/////////////////////////
	//adder
wire [31:0] EXE_MEM_SL2_PC_4_wire;
	//ALU
wire [31:0] EXE_MEM_ALURes_wire;
wire EX_MEM_Zero_wire;
	//RegFile
wire [31:0] EXE_MEM_ReadData2_wire;
	/////////////////////////
	//Control
	wire EXE_MEM_RegWrite_wire;
	wire EXE_MEM_MemtoReg_wire;
	wire EXE_MEM_MemWrite_wire;
	wire EXE_MEM_BranchEQ_NE_wire;
	wire EXE_MEM_MemRead_wire;
///////////////////////////
//Retro para WriteReg
wire [4:0] EXE_MEM_WriteRegister_wire;
/////////////////////////
//Registro MEM/WriteBack
/////////////////////////
	//ALU
wire [31:0] MEM_WB_ALURes_wire;
	//RAM
wire [31:0] MEM_WB_ReadData_wire;
	/////////////////////////
	//Control
	wire MEM_WB_RegWrite_wire;
	wire MEM_WB_MemtoReg_wire;
///////////////////////////
//Retro para WriteReg
wire [4:0] MEM_WB_WriteRegister_wire;

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
	.OP(Instruction_wire[31:26]),
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
	.NewPC(MUX_to_PC_wire),

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
PipeLine_Register
#(
	.N(64) //2 entradas
)
IF_ID_PipeRegister
(
	.clk(clk),
	.reset(reset),
	.enable(1), //dado que siempre se ejecuta usamos enable = 1
	//Input
	.Pipe_Input({PC_4_wire[31:0],Instruction_wire[31:0]}),
	//Output
	.Pipe_Output({ID_EXE_PC_4_wire[31:0],IF_ID_Inst_wire[31:0]})
);
/////////////////////////
//Registro ID/EXE
/////////////////////////
PipeLine_Regiter
#(
	.N(148) //128'b (32'b) + 10'b (Inst) + 6'b (control) + 3'b (output ALUOP)
)
ID_EXE_PipeRegister
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	//Input
	.Pipe_Input({ID_EXE_PC_4_wire[31:0],
					 ReadData1_wire[31:0],
					 ReadData2_wire[31:0],
					 InmmediateExtend_wire[31:0],
					 Instruction_wire[20:16],
					 Instruction_wire[15:11]}),
	//Output
	.Pipe_Output({ID_EXE_PC_4_wire[31:0],
					  ID_EXE_ReadData1_wire[31:0],
					  ID_EXE_ReadData2_wire[31:0],
					  ID_EXE_InmmediateExtend_wire[31:0],
					  ID_EXE_Instruction_20_16_wire[4:0],
					  ID_EXE_Instruction_15_11_wire[4:0],
					  ID_EXE_ALUSrc_wire,							/*aqui inician las señales de control*/
					  ID_EXE_ALUOp_wire,
					  ID_EXE_RegDst_wire,
					  ID_EXE_RegWrite_wire,
					  ID_EXE_MemWrite_wire,
					  ID_EXE_MemtoReg_wire,
					  ID_EXE_BranchEQ_NE_wire,
					  ID_EXE_MemRead_wire}) 
)
/////////////////////////
//Registro EXE/MEM
/////////////////////////
/* PipeLine_Regiter
#(
	.N() //
)
EXE_MEM_PipeRegister
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	//Input
	.Pipe_Input({ID_EXE_RegWrite_wire,
					 ID_EXE_MemWrite_wire,
					 ID_EXE_MemtoReg_wire,
					 ID_EXE_BranchEQ_NE_wire,
					 ID_EXE_MemRead_wire,
					 ID_EXE_RegDst_wire,
					 ID_EXE_ALUOp_wire,
					 ID_EXE_ALUSrc_wire, //Aqui terminan los pipe de control
					 Zero_wire, 
					 PC_Shift2_wire[31:0],
					 ALUResult_wire[31:0],
					 ID_EXE_ReadData2_wire[31:0],
					 WriteRegister_wire}) //Mux que iba para Write Reg
	//Output
	.Pipe_Output()
); */


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
Shift_Branch //shift a sumador branch
(
	.DataInput(InmmediateExtend_wire),

	.DataOutput(ShiftLeft2_SignExt_wire)
);

ShiftLeft2 //concatenamos la direccion de salto
Shift_Jump //shift a jump
(
	.DataInput({6'b00000,Instruction_wire[25:0]}),

	.DataOutput(Shift_J_wire)
);

assign PCSrc_wire = BranchEQ_NE_wire & Zero_wire;

Adder32bits
PC_Adder_Branch
(
	.Data0(PC_4_wire),
	.Data1(ShiftLeft2_SignExt_wire),
	
	.Result(PC_Shift2_wire)

);

Multiplexer2to1 //seleccionamos cual sera la siguiente instruccion 
#(
	.NBits(32)
)
PCShift_OR_PC
(
	.Selector(PCSrc_wire),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(PC_Shift2_wire),

	.MUX_Output(MUX_to_MUX_wire)
);


Multiplexer2to1 //seleccionamos entre pc o jump
#(
	.NBits(32)
)
MUX_PCJump
(
	.Selector(Jump_wire),
	.MUX_Data0(MUX_to_MUX_wire),
	.MUX_Data1({PC_4_wire[31:28],Shift_J_wire[27:0]}),

	.MUX_Output(MUX_ForRetJumpAndJump)
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
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_wire)

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
	.Selector(JumpJal_wire),
	.MUX_Data0(WriteRegister_wire),
	.MUX_Data1(5'b11111), //31 para obtener Ra

	.MUX_Output(MUX_Ra_WriteRegister_wire)
);
//
Multiplexer2to1 //seleccionamos si vamos a leer de los registros o el valor de inmediato
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
//
Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForALUResultAndReadData //seleccionamos que resultado debemos enviar para escribir
(
	.Selector(MemtoReg_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(ReadData_wire),

	.MUX_Output(MUX_ReadData_ALUResult_wire)
);
//
Multiplexer2to1
MUX_ForRJumpAndJump //seleccionamos a siguente instruccion del PC/jump
(
	.Selector(JumpR_wire),
	.MUX_Data0(MUX_ForRetJumpAndJump),
	.MUX_Data1(ReadData1_wire),

	.MUX_Output(MUX_to_PC_wire)
);


RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(MUX_Ra_WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(MUX_Jal_ReadData_ALUResult_wire),
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
	.ALUOperation(ALUOperation_wire)

);

ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1_wire),
	.B(ReadData2OrInmmediate_wire),
	.shamt(Instruction_wire[10:6]),
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
	.WriteData(ReadData2_wire),
	.Address({20'b0,ALUResult_wire[11:0]>>2}),
	.MemRead(MemRead_wire),
	.MemWrite(MemWrite_wire),
	//out
	.ReadData(ReadData_wire)
);

assign JumpR_wire = (ALUOperation_wire == 4'b1110) ? 1'b1 : 1'b0; //vamos a ver si la instruccion es JR

assign JumpJal_wire = ({Instruction_wire[31:26],Jump_wire} == 32'h7) ? 1'b1 : 1'b0; //vemos si es Jal (7 por que PC + 4)

assign ALUResultOut = ALUResult_wire;


endmodule

