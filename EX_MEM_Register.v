module EX_MEM_Register
#(
	parameter N=32
)
(

	input clk,
	input reset,
	
	input flush,
	
	input EX_MEM_BranchNE_Input,
	input EX_MEM_BranchEQ_Input,
	input EX_MEM_Jump_Input,
	input EX_MEM_MemRead_Input,
	input EX_MEM_MemWrite_Input,
	
	input EX_MEM_RegWrite_Input,
	input EX_MEM_MemtoReg_Input,
	
	output reg EX_MEM_BranchNE_Output,
	output reg EX_MEM_BranchEQ_Output,
	output reg EX_MEM_Jump_Output,
	output reg EX_MEM_MemRead_Output,
	output reg EX_MEM_MemWrite_Output,
	
	output reg EX_MEM_RegWrite_Output,
	output reg EX_MEM_MemtoReg_Output,
	
	input [N-1:0] EX_MEM_PC_Input,
	input 		  EX_MEM_Zero_Input,
	input [N-1:0] EX_MEM_AluResult_Input,
	input [N-1:0] EX_MEM_ReadData2_Input,
	input [4:0]   EX_MEM_WriteRegister_Input,
	input [N-1:0] EX_MEM_ReadData1_Input,
	input [N-1:0] EX_MEM_PC_4_Input,
	input [N-1:0] EX_MEM_Inst_Input,


	
	output reg [N-1:0] EX_MEM_PC_Output,
	output reg EX_MEM_Zero_Output,
	output reg [N-1:0] EX_MEM_AluResult_Output,
	output reg [N-1:0] EX_MEM_ReadData2_Output,
	output reg [4:0]   EX_MEM_WriteRegister_Output,
	output reg [N-1:0] EX_MEM_ReadData1_Output,
   output reg [N-1:0] EX_MEM_PC_4_Output,
	output reg [N-1:0] EX_MEM_Inst_Output

);

always@(negedge reset or negedge clk) begin
	if(reset==0) begin
		EX_MEM_PC_Output <= 0;
		EX_MEM_Zero_Output <= 0;
		EX_MEM_AluResult_Output <= 0;
		EX_MEM_ReadData2_Output <= 0;
		EX_MEM_WriteRegister_Output <= 0;
		EX_MEM_ReadData1_Output <= 0;
		EX_MEM_PC_4_Output <= 0;
	   EX_MEM_Inst_Output <= 0;
		
		EX_MEM_BranchNE_Output <= 0;
		EX_MEM_BranchEQ_Output <= 0;
		EX_MEM_Jump_Output <= 0;
		EX_MEM_MemRead_Output <= 0;
		EX_MEM_MemWrite_Output <= 0;
	
		EX_MEM_RegWrite_Output <= 0;
		EX_MEM_MemtoReg_Output <= 0;
	end
	else	begin
	
		if (flush) begin
			EX_MEM_PC_Output <= 0;
			EX_MEM_Zero_Output <= 0;
			EX_MEM_AluResult_Output <= 0;
			EX_MEM_ReadData2_Output <= 0;
			EX_MEM_WriteRegister_Output <= 0;
			EX_MEM_ReadData1_Output <= 0;
			EX_MEM_PC_4_Output <= 0;
			EX_MEM_Inst_Output <= 0;
			
			EX_MEM_BranchNE_Output <= 0;
			EX_MEM_BranchEQ_Output <= 0;
			EX_MEM_Jump_Output <= 0;
			EX_MEM_MemRead_Output <= 0;
			EX_MEM_MemWrite_Output <= 0;
		
			EX_MEM_RegWrite_Output <= 0;
			EX_MEM_MemtoReg_Output <= 0;
		end
		else begin
			EX_MEM_PC_Output <= EX_MEM_PC_Input;
			EX_MEM_Zero_Output <= EX_MEM_Zero_Input;
			EX_MEM_AluResult_Output <= EX_MEM_AluResult_Input;
			EX_MEM_ReadData2_Output <= EX_MEM_ReadData2_Input;
			EX_MEM_WriteRegister_Output <= EX_MEM_WriteRegister_Input;
			EX_MEM_ReadData1_Output <= EX_MEM_ReadData1_Input;
			EX_MEM_PC_4_Output <= EX_MEM_PC_4_Input;
			EX_MEM_Inst_Output <= EX_MEM_Inst_Input;
			
			EX_MEM_BranchNE_Output <= EX_MEM_BranchNE_Input;
			EX_MEM_BranchEQ_Output <= EX_MEM_BranchEQ_Input;
			EX_MEM_Jump_Output <= EX_MEM_Jump_Input;
			EX_MEM_MemRead_Output <= EX_MEM_MemRead_Input;
			EX_MEM_MemWrite_Output <= EX_MEM_MemWrite_Input;
		
			EX_MEM_RegWrite_Output <= EX_MEM_RegWrite_Input;
			EX_MEM_MemtoReg_Output <= EX_MEM_MemtoReg_Input;
		end

	end
end

endmodule