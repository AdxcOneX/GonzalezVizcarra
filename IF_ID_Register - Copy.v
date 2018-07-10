module IF_ID_Register
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input stall,
	
	input flush,
	
	input [N-1:0] IF_ID_PC_Input,
	input [N-1:0] IF_ID_Inst_Input,
	
	output reg [N-1:0] IF_ID_PC_Output,
	output reg [N-1:0] IF_ID_Inst_Output
	

);

always@(negedge reset or negedge clk) begin
	if(reset==0) begin
		IF_ID_PC_Output <= 0;
		IF_ID_Inst_Output <= 0;
		
	end
	else if (stall) begin
		IF_ID_PC_Output <= IF_ID_PC_Input;
		IF_ID_Inst_Output <= IF_ID_Inst_Input;
				
	end
	else begin
		if(flush) begin 
			IF_ID_PC_Output <= 0;
			IF_ID_Inst_Output <= 0;
		end
	end
end

endmodule