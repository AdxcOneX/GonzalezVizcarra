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
	input [5:0]Funct,//
	
	output BranchEQ,
	output BranchNE,
	output MemRead,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	
	output J,
	output Jr,
	
	output MemtoReg,//
	output RegDst,//
	output [3:0]ALUOp//
);
//Estos parametros deben de ser equivalentes al opcode de la greenCard
localparam R_Type = 0;
localparam I_Type_ADDI= 6'h8;
localparam I_Type_ORI = 6'h0d;
localparam I_Type_ANDI= 6'hc;
localparam I_Type_LUI = 6'h0f;
localparam I_Type_LW  = 6'h23;
localparam I_Type_SW	 = 6'h2b;
localparam I_Type_BNE = 6'h5;
localparam I_Type_BEQ = 6'h4;
//
localparam J_Type_J	 = 6'h2;
localparam J_Type_Jal = 6'h3;

localparam J_Type_Jr  = 12'b0000_1000;


reg [12:0] ControlValues;
reg JR; //si funciona ya que se implementaba erroneamente

always@(OP) begin
	casex(OP)
		//J//RegDst//ALUSrc//MemtoReg//RegWrite//MemRead//MemWrite//Branches//ALUOp(Relacionado a ALUCtrl)
		R_Type:       ControlValues= 12'b0_1_0_0_1_0_0_00_1111;
		I_Type_ADDI:  ControlValues= 12'b0_0_1_0_1_0_0_00_0100;
		I_Type_ORI:	  ControlValues= 12'b0_0_1_0_1_0_0_00_0101;
		I_Type_ANDI:  ControlValues= 12'b0_0_1_0_1_0_0_00_1101;
		I_Type_LUI:	  ControlValues= 12'b0_0_1_0_1_0_0_00_0110;
		I_Type_LW:	  ControlValues= 12'b0_0_1_1_1_1_0_00_0001;
		I_Type_SW:	  ControlValues= 12'b0_x_1_x_0_0_1_00_0010;
		I_Type_BNE:   ControlValues= 12'b0_x_0_x_0_0_1_10_0011;
		I_Type_BEQ:   ControlValues= 12'b0_x_0_x_0_0_1_01_0011;
		J_Type_J:	  ControlValues= 12'b1_x_x_x_0_0_0_00_0001;
		J_Type_Jal:	  ControlValues= 12'b1_0_0_0_1_0_0_00_0001;
		
		default:
						  ControlValues= 12'b0_0_0_0_0_0_0_00_0000;	
		endcase
end	

always@(OP,Funct)
begin
	if({OP,Funct} == Jr)
		JR = 1;
	else
		JR = 0;
end

assign Jr	  = JR;
assign J 	  = ControlValues[12];
	
assign RegDst = ControlValues[11];
assign ALUSrc = ControlValues[10];
assign MemtoReg = ControlValues[9];
assign RegWrite = ControlValues[8];
assign MemRead = ControlValues[7];
assign MemWrite = ControlValues[6];
assign BranchNE = ControlValues[5];
assign BranchEQ = ControlValues[4];
assign ALUOp = ControlValues[3:0];	

endmodule


