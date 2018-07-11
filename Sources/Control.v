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
	//output BranchEQ,
	//output BranchNE,
	output Branch,
	output MemRead,
	output MemtoReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output Jump,
	output Jal,
	output [5:0]ALUOp
);
localparam R_Type = 0;
localparam I_Type_ADDI 	 = 6'h8;
localparam I_Type_ORI 	 = 6'hd;
localparam I_Type_LUI  	 = 6'hf; //o

localparam I_Type_ANDI   = 6'b00_1100; //
localparam I_Type_LW	  	 = 6'b10_0011; //
localparam I_Type_SW	  	 = 6'b10_1011; //
localparam I_Type_BEQ	 = 6'b00_0100; //
localparam I_Type_BNE	 = 6'b00_0101; //

localparam J_Type_J	  = 6'h2; //o
localparam J_Type_JAL  = 6'h3; //o


reg [15:0] ControlValues;

always@(OP) begin
	casex(OP)
		R_Type:       ControlValues = 16'b001_001_00_00_000000; //h
		I_Type_ADDI:  ControlValues = 16'b000_101_00_00_001000; //h
		I_Type_ORI:   ControlValues = 16'b000_101_00_00_001101; //h
		I_Type_LUI:   ControlValues = 16'b000_101_00_00_001111; //h
		
		//TODO
		I_Type_ANDI:  ControlValues = 16'b000_101_00_00_001100; // Validate
		
		I_Type_LW:    ControlValues = 16'b000_111_10_00_100011; //h
		I_Type_SW:    ControlValues = 16'b000_100_01_00_101011; //h  6b-
		//I_Type_BEQ:   ControlValues = 16'b000_000_00_01_000100; //h
		//I_Type_BNE:   ControlValues = 16'b000_000_00_10_000101; //h
		I_Type_BEQ:   ControlValues = 16'b000_000_00_10_000100; //h
		I_Type_BNE:   ControlValues = 16'b000_000_00_10_000101; //h
		
		J_Type_J:     ControlValues = 16'b010_000_00_00_000010; //h
		J_Type_JAL:   ControlValues = 16'b110_001_00_00_000011; //h
		
		default:
			ControlValues = 16'b000000000000000;
		endcase
end	
	
assign Jal			= ControlValues[15];
assign Jump			= ControlValues[14];	
assign RegDst 		= ControlValues[13];
assign ALUSrc 		= ControlValues[12];
assign MemtoReg	= ControlValues[11];
assign RegWrite	= ControlValues[10];
assign MemRead 	= ControlValues[9];
assign MemWrite 	= ControlValues[8];
assign Branch	= ControlValues[7];
//assign BranchNE	= ControlValues[7];
//assign BranchEQ 	= ControlValues[6]; // Branch
assign ALUOp 		= ControlValues[5:0];	

endmodule


