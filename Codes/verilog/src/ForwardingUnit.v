module ForwardingUnit(
    input Ex_Mem_RegWrite, Mem_WB_RegWrite,
    input [4:0] Ex_Mem_Rd, ID_Ex_Rs, Mem_WB_Rd, ID_Ex_Rt,
    output reg [1:0] ForwardA, ForwardB
);
    // Rs - ForwardA
    always @(Ex_Mem_RegWrite, Ex_Mem_Rd, ID_Ex_Rs, Mem_WB_RegWrite, Mem_WB_Rd) begin
        if((Ex_Mem_RegWrite) &
           (Ex_Mem_Rd == ID_Ex_Rs) & 
           (Ex_Mem_Rd != 0))
           ForwardA = 2'b10;
        else if((Mem_WB_RegWrite) &
                (Mem_WB_Rd == ID_Ex_Rs) & 
                (Mem_WB_Rd != 0))
           ForwardA = 2'b01;
        else 
           ForwardA = 2'b00;   
    end
    
    // Rt - ForwardB
    always @(Ex_Mem_RegWrite, Ex_Mem_Rd, ID_Ex_Rt, Mem_WB_RegWrite, Mem_WB_Rd) begin
        if((Ex_Mem_RegWrite) &
           (Ex_Mem_Rd == ID_Ex_Rt) & 
           (Ex_Mem_Rd != 0))
           ForwardB = 2'b10;
        else if((Mem_WB_RegWrite) &
                (Mem_WB_Rd == ID_Ex_Rt) & 
                (Mem_WB_Rd != 0))
           ForwardB = 2'b01;
        else 
           ForwardB = 2'b00;   
    end

endmodule