module HazardUnit(ID_EX_MemRead, ID_Ex_Rt, Rs, Rt, cntrl0, IF_ID_Write, PCwrite);
	input ID_EX_MemRead;
	input [4:0] ID_Ex_Rt, Rs, Rt;
	output reg cntrl0, IF_ID_Write, PCwrite;
	
	always @ (ID_EX_MemRead, Rt, ID_Ex_Rt, Rs) begin
		if(ID_EX_MemRead & ((Rt == ID_Ex_Rt) | (Rs == ID_Ex_Rt)))
			{PCwrite, IF_ID_Write, cntrl0} = 3'b001;
		else
			{PCwrite, IF_ID_Write, cntrl0} = 3'b110;
	end
endmodule
