module MEM_WB_Register
#(
	parameter N = 32
)
(
	input clk,
	input reset,
	
	input MEM_WB_RegWrite_Input,
	input MEM_WB_MemtoReg_Input,
	input MEM_WB_MemRead_Input,
	
	output reg MEM_WB_RegWrite_Output,
	output reg MEM_WB_MemtoReg_Output,
	output reg MEM_WB_MemRead_Output,
	
	input [N-1:0] MEM_WB_ReadData_Input,
	input [N-1:0] MEM_WB_AluResult_Input,
	input [4:0] MEM_WB_WriteRegister_Input,
	input [N-1:0] MEM_WB_PC_4_Input,

	
	output reg [N-1:0] MEM_WB_ReadData_Output,
	output reg [N-1:0] MEM_WB_AluResult_Output,
	output reg [4:0] MEM_WB_WriteRegister_Output,
	output reg [N-1:0] MEM_WB_PC_4_Output

);

always@(negedge reset or negedge clk) begin
	if(reset==0) begin
		MEM_WB_ReadData_Output <= 0;
		MEM_WB_AluResult_Output <= 0;
		MEM_WB_WriteRegister_Output <= 0;
		MEM_WB_PC_4_Output <= 0;
		
		MEM_WB_RegWrite_Output <= 0;
		MEM_WB_MemtoReg_Output <= 0;
		MEM_WB_MemRead_Output <= 0;
	end
	else	begin
		MEM_WB_ReadData_Output <= MEM_WB_ReadData_Input;
		MEM_WB_AluResult_Output <= MEM_WB_AluResult_Input;
		MEM_WB_WriteRegister_Output <= MEM_WB_WriteRegister_Input;
		MEM_WB_PC_4_Output <= MEM_WB_PC_4_Input;
		
		MEM_WB_RegWrite_Output <= MEM_WB_RegWrite_Input;
		MEM_WB_MemtoReg_Output <= MEM_WB_MemtoReg_Input;
		MEM_WB_MemRead_Output <= MEM_WB_MemRead_Input;
	end
end

endmodule