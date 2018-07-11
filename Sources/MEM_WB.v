module MEM_WB
(
	input clk,
	input reset,
	input enable,
	//Control
	input MemtoReg,
	input RegWrite,
	output reg MemtoReg_Out,
	output reg RegWrite_Out,
	//RAM
	input [31:0]ReadData,
	output reg [31:0]ReadData_Out,
	//EX_MEM
	input [31:0]ALUResult,
	input [4:0]WriteRegister,
	output reg [31:0]ALUResult_Out,
	output reg [4:0]WriteRegister_Out
);

always@(negedge reset or negedge clk) begin
	if(reset==0)
	begin
			MemtoReg_Out <= 0;
		RegWrite_Out <= 0;
		ReadData_Out <= 0;
		ALUResult_Out <= 0;
		WriteRegister_Out <= 0;
		end
	else	
		if(enable==1)
		begin
			MemtoReg_Out <= MemtoReg;
		RegWrite_Out <= RegWrite;
		ReadData_Out <= ReadData;
		ALUResult_Out <= ALUResult;
		WriteRegister_Out <= WriteRegister;
		end
end

endmodule