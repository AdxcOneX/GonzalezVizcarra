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
#(	parameter DATA_WIDTH=32,
	parameter MEMORY_DEPTH = 512

)
(
	input [DATA_WIDTH-1:0] WriteData,
	input [DATA_WIDTH-1:0]  Address,
	input MemWrite,MemRead, clk,
	output  [DATA_WIDTH-1:0]  ReadData
);
	//Esto se implemento en top level sin embargo no funcionaba
	wire[(DATA_WIDTH-1):0] Aux_Address;
	assign Aux_Address = (Address[(DATA_WIDTH-1):0] - 32'h1001_0000) >> 2;
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
	wire [DATA_WIDTH-1:0] ReadDataAux;

	always @ (posedge clk)
	begin
		// Write
		if (MemWrite)
			ram[Aux_Address] <= WriteData;
	end
	assign ReadDataAux = ram[Aux_Address];
  	assign ReadData = {DATA_WIDTH{MemRead}}& ReadDataAux;

endmodule
