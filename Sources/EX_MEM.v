module EX_MEM
(
	input clk,
	input reset,
	input enable,
	//Control
	input Branch,
	input MemRead,
	input MemtoReg,
	input MemWrite,
	input RegWrite,
	output reg Branch_Out,
	output reg MemRead_Out,
	output reg MemtoReg_Out,
	output reg MemWrite_Out,
	output reg RegWrite_Out,
	//Add
	input [31:0]Add,
	output reg [31:0]Add_Out,
	//ALU
	input Zero,
	input [31:0]ALUResult,
	output reg Zero_Out,
	output reg [31:0]ALUResult_Out,
	//ID_EX
	input [31:0]ReadData2,
	output reg [31:0]ReadData2_Out,
	//Mux
	input [4:0]Mux,
	output reg [4:0]Mux_Out
);
always@(negedge reset or posedge clk) begin
	if(reset==0)
		begin
		Branch_Out <= 0;
		MemRead_Out <= 0;
		MemtoReg_Out <= 0;
		MemWrite_Out <= 0;
		RegWrite_Out <= 0;
		Add_Out <= 0;
		Zero_Out <= 0;
		ALUResult_Out <= 0;
		ReadData2_Out <= 0;
		Mux_Out <= 0;
		end
		else
	if(enable==1)
	begin
			Branch_Out <= Branch;
		MemRead_Out <= MemRead;
		MemtoReg_Out <= MemtoReg;
		MemWrite_Out <= MemWrite;
		RegWrite_Out <= RegWrite;
		Add_Out <= Add;
		Zero_Out <= Zero;
		ALUResult_Out <= ALUResult;
		ReadData2_Out <= ReadData2;
		Mux_Out <= Mux; 
		end
end

endmodule