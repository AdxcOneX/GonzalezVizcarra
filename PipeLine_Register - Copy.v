/******************************************************************
* Description
*	This is a register of 32-bit that corresponds to the PC counter. 
*	This register does not have an enable signal.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/

module PipeLine_Register
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input enable,
	input  [N-1:0] Pipe_Input,
	
	
	output reg [N-1:0] Pipe_Output
);

always@(negedge reset or negedge clk) begin
	if(reset==0)
		Pipe_Output <= 'h400000; //empezaremos en la memoria de la ROM 400000
	else	
		Pipe_Output<=Pipe_Input;
end

endmodule