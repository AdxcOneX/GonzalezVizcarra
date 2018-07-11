/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add
*		sub
*		or
*		and
*		nor
* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/

module ALU 
(
	input [3:0] ALUOperation,
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,	//PCValue, used for JAL
	input [4:0] shamt,
	output reg Zero,
	output reg [31:0]ALUResult
);

localparam ADD = 4'b0000;//
localparam AND = 4'b0001;//
localparam JR = 4'b0010;//
localparam NOR = 4'b0011;
localparam OR = 4'b0100;//
localparam SLL = 4'b0101;//
localparam SRL = 4'b0110;//
localparam SUB = 4'b0111;//
		
localparam ADDI = 4'b0000;// *
localparam ANDI = 4'b0001;//
localparam BEQ = 4'b1000;//
localparam BNE = 4'b1001;//
localparam LUI = 4'b1010;// <<
localparam LW = 4'b1011;//
localparam ORI = 4'b0100;// #
localparam SW = 4'b1100;//
		
//localparam J = 4'b1101;//
localparam JAL = 4'b1111;//
   
   always @ (A or B or ALUOperation)
     begin
		case (ALUOperation)
		
		//R_Type
		  ADD: // add | addi
			ALUResult = A + B;
		  AND: // and | andi
			ALUResult = A & B;
		  JR: //jr
		   ALUResult = A;
		  NOR: // nor
			ALUResult = ~(A|B);
		  OR:  // or  | ori
			ALUResult = A | B;
		  SLL: // R TYPE
			ALUResult = B<<shamt;
		  SRL: // R TYPE					
			ALUResult = B>>shamt; // I TYPE
		  SUB: // R TYPE		  
			ALUResult = A - B;
		  
		//I_Type
		  ADDI: // add | addi
			ALUResult = A + B;
		  ANDI: // and | andi
			ALUResult = A & B;
		  BEQ: // beq
			ALUResult = (A - B); // A -B only
		  BNE: // bne
		   ALUResult = ( (A - B) == 0)? 1'b1 : 1'b0;
		  LUI: // lui
			ALUResult = {B[15:0], 16'b0}; //
		  LW: // lw
			ALUResult = (A + B);
			//ALUResult = ( (A + B) - 32'h1001_0000 ) / 4;
		  ORI:  // or  | ori4
			ALUResult = A | B;
		  SW: //sw
			ALUResult = (A + B);
			//ALUResult = ( (A + B) - 32'h1001_0000 ) / 4;
			
		//J_Type
		  //J: // j
		   //ALUResult = A; //This is wrong, Jump does not go through ALU
		  JAL: //jal
		   ALUResult = C + 6'h4;
		  
		default:
			ALUResult= 0;
		endcase // case(control)
		Zero = (ALUResult==0) ? 1'b1 : 1'b0;
     end // always @ (A or B or control)
endmodule // ALU