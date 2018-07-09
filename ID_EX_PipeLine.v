module ID_EX_Register
#(
	parameter N = 32
)
(
	input clk,
	input reset,
	
	input flush,
		
	input ID_EX_ALUSrc_Input,
	input[2:0] ID_EX_ALUOp_Input,
	
	input ID_EX_BranchEQ_NE_Input,
	input ID_EX_Jump_Input,
	input ID_EX_MemRead_Input,
	input ID_EX_MemWrite_Input,
	
	input ID_EX_RegWrite_Input,
	input ID_EX_MemtoReg_Input,
	
	
	output reg ID_EX_ALUSrc_Output,
	output reg [2:0] ID_EX_ALUOp_Output,
	
	output reg ID_EX_BranchNE_Output,
	output reg ID_EX_BranchEQ_Output,
	output reg ID_EX_Jump_Output,
	output reg ID_EX_MemRead_Output,
	output reg ID_EX_MemWrite_Output,
	
	output reg ID_EX_RegWrite_Output,
	output reg ID_EX_MemtoReg_Output,
	
	input [N-1:0] ID_EX_PC_Input,
	input [N-1:0] ID_EX_Inst_Input,
	input [N-1:0] ID_EX_InmmediateExtend_Input,
	input [N-1:0] ID_EX_ReadData1_Input,
	input [N-1:0] ID_EX_ReadData2_Input,
	input [4:0]   ID_EX_WriteRegister_Input,

	
	output reg [N-1:0] ID_EX_PC_Output,
	output reg [N-1:0] ID_EX_Inst_Output,
	output reg [N-1:0] ID_EX_InmmediateExtend_Output,
	output reg [N-1:0] ID_EX_ReadData1_Output,
	output reg [N-1:0] ID_EX_ReadData2_Output,
	output reg [4:0]   ID_EX_WriteRegister_Output


);

always@(negedge reset or negedge clk) begin
	if(reset==0) begin
		ID_EX_PC_Output <= 0;
		ID_EX_Inst_Output <= 0;
		ID_EX_InmmediateExtend_Output <= 0;
		ID_EX_ReadData1_Output <= 0;
		ID_EX_ReadData2_Output <= 0;
		ID_EX_WriteRegister_Output <= 0;
		
		ID_EX_ALUSrc_Output <= 0;
		ID_EX_ALUOp_Output <= 0;
		
		ID_EX_BranchNE_Output <= 0;
		ID_EX_BranchEQ_Output <= 0;
		ID_EX_Jump_Output <= 0;
		ID_EX_MemRead_Output <= 0;
		ID_EX_MemWrite_Output <= 0;
	
		ID_EX_RegWrite_Output <= 0;
		ID_EX_MemtoReg_Output <= 0;
	end
	else	begin
		if (flush) begin
			ID_EX_PC_Output <= 0;
			ID_EX_Inst_Output <= 0;
			ID_EX_InmmediateExtend_Output <= 0;
			ID_EX_ReadData1_Output <= 0;
			ID_EX_ReadData2_Output <= 0;
			ID_EX_WriteRegister_Output <= 0;
			
			ID_EX_ALUSrc_Output <= 0;
			ID_EX_ALUOp_Output <= 0;
			
			ID_EX_BranchNE_Output <= 0;
			ID_EX_BranchEQ_Output <= 0;
			ID_EX_Jump_Output <= 0;
			ID_EX_MemRead_Output <= 0;
			ID_EX_MemWrite_Output <= 0;
		
			ID_EX_RegWrite_Output <= 0;
			ID_EX_MemtoReg_Output <= 0;
		end
		else begin
			ID_EX_PC_Output <= ID_EX_PC_Input;
			ID_EX_Inst_Output <= ID_EX_Inst_Input;
			ID_EX_InmmediateExtend_Output <= ID_EX_InmmediateExtend_Input;
			ID_EX_ReadData1_Output <= ID_EX_ReadData1_Input;
			ID_EX_ReadData2_Output <= ID_EX_ReadData2_Input;
			ID_EX_WriteRegister_Output <= ID_EX_WriteRegister_Input;
			
			ID_EX_ALUSrc_Output <= ID_EX_ALUSrc_Input;
			ID_EX_ALUOp_Output <= ID_EX_ALUOp_Input;
		
			ID_EX_BranchNE_Output <= ID_EX_BranchNE_Input;
			ID_EX_BranchEQ_Output <= ID_EX_BranchEQ_Input;
			ID_EX_Jump_Output <= ID_EX_Jump_Input;
			ID_EX_MemRead_Output <= ID_EX_MemRead_Input;
			ID_EX_MemWrite_Output <= ID_EX_MemWrite_Input;
		
			ID_EX_RegWrite_Output <= ID_EX_RegWrite_Input;
			ID_EX_MemtoReg_Output <= ID_EX_MemtoReg_Input;
		end
	end
	
	
end

endmodule