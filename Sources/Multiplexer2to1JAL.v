/******************************************************************
* Description
*	This is a  an 2to1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/

module Multiplexer2to1JAL
#(
	parameter NBits=5
)
(
	input Selector,
	input [NBits-1:0] Data0,
	input [NBits-1:0] Data1,
	
	output reg [NBits-1:0] OUT

);

	always@(Selector,Data1,Data0) begin
		if(Selector)
			OUT = Data1;
		else
			OUT = Data0;
	end

endmodule