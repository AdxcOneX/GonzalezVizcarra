/******************************************************************
* Description
*	This is the data memory for the MIPS processor
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/

module DataMemory 
#(	
	//Entrada y salida de memoria, deberia de ser de 32 bits, no 8
	parameter DATA_WIDTH=8,
	//Podemos almacenar a 2^32
	//Modificar la memoria
	parameter MEMORY_DEPTH = 512

)
(
	input [DATA_WIDTH-1:0] WriteData,
	input [DATA_WIDTH-1:0]  Address,
	input MemWrite,MemRead, clk,
	output  [DATA_WIDTH-1:0]  ReadData
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
	wire [DATA_WIDTH-1:0] ReadDataAux;

	always @ (posedge clk)
	begin
		// Write
		if (MemWrite)
			ram[Address] <= WriteData;
	end
	assign ReadDataAux = ram[Address];
  	assign ReadData = {DATA_WIDTH{MemRead}}& ReadDataAux;

endmodule
