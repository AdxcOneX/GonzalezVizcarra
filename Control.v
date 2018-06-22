/******************************************************************
* Description
*	This is control unit for the MIPS processor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module Control
(
	input [5:0]OP,
	
	output RegDst,
	output BranchEQ,
	output BranchNE,
	output MemRead,
	output MemtoReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output [2:0]ALUOp
);
//Estos parametros deben de ser equivalentes al opcode de la greenCard
localparam R_Type = 0;
localparam I_Type_ADDI= 6'h8;
localparam I_Type_ORI = 6'h0d;
localparam I_Type_LUI = 6'h0f;
localparam I_Type_LW  = 6'h23;
localparam I_Type_SW	 = 6'h2b;

reg [11:0] ControlValues;

always@(OP) begin
	casex(OP)
		// RegDst//ALUSrc//MemtoReg//RegWrite//MemRead//MemWrite//Branches//ALUOp(Relacionado a ALUCtrl)
		R_Type:       ControlValues= 12'b1_0_0_1_00_00_111;
		I_Type_ADDI:  ControlValues= 12'b0_1_0_1_00_00_0100;
		I_Type_ORI:	  ControlValues= 12'b0_1_0_1_00_00_0101;
		I_Type_LUI:	  ControlValues= 12'b0_1_0_1_00_00_0110;
		I_Type_LW:	  ControlValues= 12'b0_1_1_1_10_00_0001;
		I_Type_SW:	  ControlValues= 12'bx_1_x_0_01_00_0010;
		
		default:
			ControlValues= 10'b0000000000;	
		endcase
end	
	
assign RegDst = ControlValues[10];
assign ALUSrc = ControlValues[9];
assign MemtoReg = ControlValues[8];
assign RegWrite = ControlValues[7];
assign MemRead = ControlValues[6];
assign MemWrite = ControlValues[5];
assign BranchNE = ControlValues[4];
assign BranchEQ = ControlValues[3];
assign ALUOp = ControlValues[2:0];	

endmodule


