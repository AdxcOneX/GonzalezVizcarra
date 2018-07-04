/******************************************************************
* Description
*		This is an OR gate:
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module ORGate
(
	input A,
	input B,
	output reg C
);

always@(*)
	C = A | B;

endmodule