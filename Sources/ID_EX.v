module ID_EX
(
	input clk,
	input reset,
	input enable,
	//Control
	input RegDst,
	input Branch,
	input MemRead,
	input MemtoReg,
	input MemWrite,
	input ALUSrc,
	input RegWrite,
	input Jump,
	input Jal,
	input [5:0]ALUOp,
	output reg RegDst_Out,
	output reg Branch_Out,
	output reg MemRead_Out,
	output reg MemtoReg_Out,
	output reg MemWrite_Out,
	output reg ALUSrc_Out,
	output reg RegWrite_Out,
	output reg Jump_Out,
	output reg Jal_Out,
	output reg [5:0]ALUOp_Out,
	//Add 4
	input [31:0]Add_4,
	output reg [31:0]Add_4_Out,
	//Register File
	input [31:0]ReadData1,
	input [31:0]ReadData2,
	output reg [31:0]ReadData1_Out,
	output reg [31:0]ReadData2_Out,
	//Sign Extend
	input [31:0]SignExtendOutput,
	output reg [31:0]SignExtendOutput_Out,
	//Instruction
	input [4:0]ID_Ins_A,
	input [4:0]ID_Ins_B,
	input [4:0]ID_Ins_C,
	output reg [4:0]EX_Ins_A,
	output reg [4:0]EX_Ins_B,
	output reg [4:0]EX_Ins_C,
	//Jump
	input [31:0]JumpAddress,
	output reg [31:0]JumpAddress_Out,
	//shamt
	input [4:0]shamt,
	output reg [4:0]shamt_Out,
	//PC
	input [31:0]PC,
	output reg [31:0]PC_Out
);

always@(negedge reset or posedge clk) begin
	if(reset==0)
		begin
			//Control
		RegDst_Out <=  0;
		Branch_Out <=  0;
		MemRead_Out <=  0;
		MemtoReg_Out <=  0;
		MemWrite_Out <=  0;
		ALUSrc_Out <=  0;
		RegWrite_Out <=  0;
		Jump_Out <=  0;
		Jal_Out <=  0;
		ALUOp_Out <=  0;
		//Add 4
		Add_4_Out <=  0;
		//Register File
		ReadData1_Out <=  0;
		ReadData2_Out <=  0;
		//Sign Extend
		SignExtendOutput_Out <=  0;
		//Instruction
		EX_Ins_A <=  0;
		EX_Ins_B <=  0;
		EX_Ins_C <=  0;
		//JumpAddress
		JumpAddress_Out <=  0;
		//shamt
		shamt_Out <=  0;
		//PC
		PC_Out <=  0;
		end
	else	
		if(enable==1)
			begin
			//Control
		RegDst_Out <= RegDst;
		Branch_Out <= Branch;
		MemRead_Out <= MemRead;
		MemtoReg_Out <= MemtoReg;
		MemWrite_Out <= MemWrite;
		ALUSrc_Out <= ALUSrc;
		RegWrite_Out <= RegWrite;
		Jump_Out <= Jump;
		Jal_Out <= Jal;
		ALUOp_Out <= ALUOp;
		//Add 4
		Add_4_Out <= Add_4;
		//Register File
		ReadData1_Out <= ReadData1;
		ReadData2_Out <= ReadData2;
		//Sign Extend
		SignExtendOutput_Out <= SignExtendOutput;
		//Instruction
		EX_Ins_A <= ID_Ins_A;
		EX_Ins_B <= ID_Ins_B;
		EX_Ins_C <= ID_Ins_C;
		//JumpAddress
		JumpAddress_Out <= JumpAddress;
		//shamt
		shamt_Out <= shamt;
		//PC
		PC_Out <= PC;
		end
end

endmodule