/**********************************************************************
*
*  Module Hazard detection Unit
*	
********************************************************************/

module HazardDetect
(
		input [2:0] IDEXMemRead, //Branch, MemRead, MemWrite
		input [4:0] IDEXRt,
		input [4:0] IFIDRs,
		input [4:0] IFIDRt,
		
		output reg HazardMux, //It does convince me
		output reg IFIDWrite,
		output reg PCWrite    //stall
		//output stall
		
);

always@(IDEXMemRead or IDEXRt or IFIDRs or IFIDRt or PCWrite or IFIDWrite or HazardMux)
	begin
	PCWrite = 0;
	IFIDWrite = 1;
   HazardMux =0;
	 if((IDEXMemRead)&&((IDEXRt == IFIDRs) || (IDEXRt == IFIDRt)))
	 begin
	 PCWrite = 1;
	 IFIDWrite = 0;
    HazardMux =1;
	 end 
	end

endmodule