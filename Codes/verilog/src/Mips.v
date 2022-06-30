module Mips (Clk, Rst);
    input Rst, Clk;
    wire RegDst, R31, RegWrite, WriteLink, AluSrc,
      MemRead, MemWrite, MemToReg, Branch, jump, jr,
      PC_Write, IF_ID_Write, 
      Ex_Mem_RegWrite, Mem_WB_RegWrite,
      EQ, flush;
    wire [1:0] ForwardA, ForwardB;
    wire [2:0] ALUOperation;
    wire  [5:0] opcode, func;
    wire  [4:0] Rt, Rs, Ex_Mem_Rd, Mem_WB_Rd, ID_Ex_Rt_hazard,ID_Ex_Rs,  ID_Ex_Rt_forward;

  MipsController CU (
    .opcode(opcode), .func(func), .MemToReg(MemToReg), .MemRead(MemRead), .MemWrite(MemWrite),
    .RegWrite(RegWrite), .ALUOperation(ALUOperation), .Branch(Branch), .jump(jump), .jr(jr),
    .WriteLink(WriteLink), .RegDst(RegDst), .R31(R31), .ALUSrc(AluSrc), .EQ(EQ), .flush(flush)
  );
  MipsDatapath DP (
    .clk(Clk), .rst(Rst), .RegDst(RegDst), .R31(R31), .RegWrite(RegWrite), .WriteLink(WriteLink), .AluSrc(AluSrc),
    .flush(flush), .cntrl0(cntrl0),
    .MemRead(MemRead), .MemWrite(MemWrite), .MemToReg(MemToReg), .Branch(Branch),
    .jump(jump), .jr(jr), .PC_Write(PC_Write), .IF_ID_Write(IF_ID_Write),
    .ALUOperation(ALUOperation), .A_forwarding(ForwardA), .B_forwarding(ForwardB),
    .RegWrite_forward_WB(Mem_WB_RegWrite), .RegWrite_forward_MEM(Ex_Mem_RegWrite),
    .Rs_hazard_ID(Rs), .Rt_hazard_ID(Rt), .Rt_hazard_EX(ID_Ex_Rt_hazard),
    .Rs_forward(ID_Ex_Rs), .Rt_forward(ID_Ex_Rt_forward), .Rd_forward_WB(Mem_WB_Rd), .Rd_forward_MEM(Ex_Mem_Rd),
    .opcode(opcode), .func(func), .EQ(EQ), .MemRead_hazard_EX(ID_EX_MemRead)
  );
  HazardUnit HU (
    .ID_EX_MemRead(ID_EX_MemRead), .ID_Ex_Rt(ID_Ex_Rt_hazard), .Rs(Rs), .Rt(Rt), 
    .cntrl0(cntrl0), .IF_ID_Write(IF_ID_Write), .PCwrite(PC_Write)
  );
  ForwardingUnit FU (
    .Ex_Mem_RegWrite(Ex_Mem_RegWrite), .Mem_WB_RegWrite(Mem_WB_RegWrite),
    .Ex_Mem_Rd(Ex_Mem_Rd), .ID_Ex_Rs(ID_Ex_Rs), .Mem_WB_Rd(Mem_WB_Rd), .ID_Ex_Rt(ID_Ex_Rt_forward),
    .ForwardA(ForwardA), .ForwardB(ForwardB)
  );
  
endmodule