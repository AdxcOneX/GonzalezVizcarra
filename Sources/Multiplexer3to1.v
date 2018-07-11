/********************************
Modulo multiplexor 3 a 1
Fernanda Muñoz
Alondra macias
Alberto Anton
*******************/

module Multiplexer3to1

#(

	parameter NBits = 32
	
)

(
	input [1:0] Selector,
	input [NBits-1:0] Data0,
	input [NBits-1:0] Data1,
	input [NBits-1:0] Data2,
	
	output reg [NBits-1:0] OUT

);


	always@(Selector,Data2,Data1,Data0) 
	begin
	//cambiamos el if por un case para las 3 opciones
		/*if(Selector)
			OUT = Data1;
		else
			OUT = Data0;*/
			
		case(Selector)
		
		2'b00:
			
			OUT <= Data0;
		
		2'b01:
			
			OUT <= Data1;
	   
		2'b10:
			
			OUT <= Data2;
		
		default:
			
			OUT <= 0;
			
		endcase
			
			
	end

endmodule