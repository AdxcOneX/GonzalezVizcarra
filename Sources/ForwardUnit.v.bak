/**********************************************************************
*
*  Module forwarding
*	
********************************************************************/

module ForwardUnit
(

		input  [4:0]EXMEMRd,			
		input  [4:0]MEMWBRd,
		input  [4:0]IDEXRt,
		input  [4:0]IDEXRs,	
		
		input  /*[1:0]*/ EXMEM_RW,			// viene de wb del exmem
		input  /*[1:0]*/ MEMWB_RW,        // viene de wb del write back
		
		
		output reg [1:0] ForwardA, //salidas de control
		output reg [1:0] ForwardB  // salidas de control
				
);
/*
always@( EXMEMRd or IDEXRt or MEMWBRd or IDEXRs or EXMEM_RW or MEMWB_RW )
	begin
	 if (EXMEM_RW && (EXMEMRd != 0) && (EXMEMRd == IDEXRs)) 
	 begin 
		ForwardB= 10;
	  end
	 if (EXMEM_RW && (EXMEMRd != 0) && (EXMEMRd == IDEXRt)) 
	 begin 
		ForwardA = 10;
	  end
	 if (MEMWB_RW && (MEMWBRd != 0) && (EXMEMRd != IDEXRs) && (MEMWBRd == IDEXRs)) 
	 begin 
		ForwardB = 01;
	  end
	 if (MEMWB_RW && (MEMWBRd != 0) && (EXMEMRd != IDEXRt) && (MEMWBRd == IDEXRt)) 
	 begin 
		ForwardB = 01;
	  end
	
	end
*/

always@( EXMEMRd or IDEXRt or MEMWBRd or IDEXRs or EXMEM_RW or MEMWB_RW )
	begin
		ForwardA <= 0;
		ForwardB <= 0;
		if (EXMEM_RW && (EXMEMRd != 0) && (EXMEMRd == IDEXRs)) 
		 begin 
			ForwardA <= 2'b10;
		 end
		if (EXMEM_RW && (EXMEMRd != 0) && (EXMEMRd == IDEXRt)) 
		 begin 
			ForwardB <= 2'b10;
		 end
		if (MEMWB_RW && (MEMWBRd != 0) && (EXMEMRd != IDEXRs) && (MEMWBRd == IDEXRs)) 
		 begin 
			ForwardA <= 2'b01;
		 end
		if (MEMWB_RW && (MEMWBRd != 0) && (EXMEMRd != IDEXRt) && (MEMWBRd == IDEXRt)) 
		 begin 
			ForwardB <= 2'b01;
		 end
	end

endmodule