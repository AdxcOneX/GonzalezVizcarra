module IF_ID
(
	input clk,
	input reset,
	input enable,
	input [31:0] Instruction_In,
	input [31:0] PC_4_In,
	input [31:0] PC,
	
	output reg [31:0] Instruction_Out,
	output reg [31:0] PC_4_Out,
	output reg [31:0] PC_Out
);

always@(negedge reset or posedge clk) begin
	if(reset==0)
	begin
		Instruction_Out <= 0;
		PC_4_Out <= 0;	
		PC_Out <= 0;
		end
	else	
		if(enable==1)
		begin
			Instruction_Out <= Instruction_In;
		PC_4_Out <= PC_4_In;		
		PC_Out <= PC;
		end
end

endmodule