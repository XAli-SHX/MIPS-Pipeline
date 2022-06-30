module MipsDatapath(
    input clk, rst, RegDst, R31, RegWrite, WriteLink, AluSrc, flush, cntrl0,
    MemRead, MemWrite, MemToReg, Branch, jump, jr,
    PC_Write, IF_ID_Write,
    input [2:0] ALUOperation,
    input [1:0] A_forwarding, B_forwarding,
    output RegWrite_forward_WB, RegWrite_forward_MEM, EQ, MemRead_hazard_EX,
    output [4:0] Rs_hazard_ID, Rt_hazard_ID, Rt_hazard_EX, Rs_forward, Rt_forward, Rd_forward_WB, Rd_forward_MEM, //new parameters are being passed to hazard unit and forwarding unit
    output [5:0] opcode, func // passed to controller
);

    wire AluSrc_cntrl0_Out, RegDst_cntrl0_Out, R31_cntrl0_Out, func_minus1,
    MemRead_cntrl0_Out, MemWrite_cntrl0_Out, WriteLink_cntrl0_Out,
    MemToReg_cntrl0_Out, RegWrite_cntrl0_Out;
    wire [2:0] ALUOperation_cntrl0_Out;
    wire [31:0] InstAddress, PC_Adder_Out0, PC_Adder_Out1, PC_Adder_Out2, PC_Adder_Out3, PC_Adder_Out4, Instruction0, Instruction1, ReadData1_0, ReadData1_1, ReadData2_0, ReadData2_1;
    wire [4:0] Mux_Dst_Out, Mux_Jal_Out0, Mux_Jal_Out1, Mux_Jal_Out2, Rt0, Rs0, Rd0;
    wire [31:0] WriteData, Mux_AluSrc_Out, se_Out0, se_Out1;
    wire [31:0] MemReadData0, MemReadData1, AluRes0, AluRes1, AluRes2, Mux_MemToReg_Out, Mux_Jump_Out, Mux_Jr_Out, Mux_ForwardB_Out0, Mux_ForwardB_Out1, Mux_ForwardA_Out;
    wire [31:0] br_Adder_Out, Mux_Br_Out;
    wire zero, AluSrc_EX, RegDst_EX, R31_EX, MemRead_EX, MemWrite_EX, MemRead_MEM, MemWrite_MEM,
    WriteLink_EX, WriteLink_MEM, WriteLink_WB, MemToReg_EX, MemToReg_MEM, MemToReg_WB, RegWrite_EX, RegWrite_MEM, RegWrite_WB;
    wire [2:0] AluOperation_EX;
    wire rstAndFlush;
    
    // assign rstAndFlush = (rst | flush_synch);

    Register #(32) PC(.clk(clk), .rst(rst), .ld(PC_Write), .regIn(Mux_Jr_Out), .regOut(InstAddress)); // PC_Write
    InstructionMemory #(32, 32) InstMem(.clk(clk), .Address(InstAddress), .Instruction(Instruction0));
    Adder #(32) PC_Adder (.A(32'b00000000000000000000000000000100), .B(InstAddress), .sub(1'b0), .res(PC_Adder_Out0));

    // Register #(1) flush_reg(.clk(clk), .rst(rst), .ld(1'b1), .regIn(flush), .regOut(flush_synch)); // flush register

    // pipe IF/ID
    RegisterSynch #(32) PC_ID(.clk(clk), .rst(rst), .ld(IF_ID_Write), .clr(flush), .regIn(PC_Adder_Out0), .regOut(PC_Adder_Out1));        // IF_ID_Write added for hazard unit
    RegisterSynch #(32) Instruction_ID(.clk(clk), .rst(rst), .ld(IF_ID_Write), .clr(flush), .regIn(Instruction0), .regOut(Instruction1)); // flush (synch) signal added for control unit
    // pipe IF/ID

    Mux2 #(11) Mux_cntrl0(
    .d0({ALUOperation, RegDst, AluSrc, R31, MemRead, MemWrite, RegWrite, WriteLink, MemToReg}),
    .d1(11'b0),
    .sel(cntrl0),
    .w({ALUOperation_cntrl0_Out, RegDst_cntrl0_Out, AluSrc_cntrl0_Out, R31_cntrl0_Out, MemRead_cntrl0_Out, MemWrite_cntrl0_Out, RegWrite_cntrl0_Out, WriteLink_cntrl0_Out, MemToReg_cntrl0_Out})
    ); // cntrl0 Mux

    RegisterFile #(32, 5) RegFile (
        .ReadReg1(Instruction1[25:21]), .ReadReg2(Instruction1[20:16]), .WriteReg(Mux_Jal_Out2),
        .WriteData(WriteData),
        .clk(clk), .RegWrite(RegWrite_WB),
        .ReadData1(ReadData1_0), .ReadData2(ReadData2_0)
    );
    Compare comp(.A(ReadData1_0), .B(ReadData2_0), .zero(zero));
    SignExtend #(16, 32) se(.in(Instruction1[15:0]), .out(se_Out0));
    Adder #(32) br_Adder (.A(PC_Adder_Out1), .B((se_Out0<<2)), .sub(1'b0), .res(br_Adder_Out));
    Mux2 #(32) Mux_Br(.d0(PC_Adder_Out0), .d1(br_Adder_Out), .sel((Branch & zero)), .w(Mux_Br_Out)); // Branch & another zero!
    // PC_Adder_Out0 is not from pipeline.
    Mux2 #(32) Mux_Jump(
        .d0(Mux_Br_Out), .d1({PC_Adder_Out1[31:28], Instruction1[25:0], 2'b00}), // pc_adder_out[31:28]
        .sel(jump), .w(Mux_Jump_Out)
    );
    Mux2 #(32) Mux_Jr(.d0(Mux_Jump_Out), .d1(ReadData1_0), .sel(jr), .w(Mux_Jr_Out));

    // pipe ID/EX
    Register #(32) PC_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(PC_Adder_Out1), .regOut(PC_Adder_Out2));
    Register #(32) ReadData1_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(ReadData1_0), .regOut(ReadData1_1));
    Register #(32) ReadData2_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(ReadData2_0), .regOut(ReadData2_1));
    Register #(32) se_Out_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(se_Out0), .regOut(se_Out1));
    Register #(5) Rt_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(Instruction1[20:16]), .regOut(Rt0)); // 
    Register #(5) Rd_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(Instruction1[15:11]), .regOut(Rd0)); // are these ok?
    Register #(5) Rs_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(Instruction1[25:21]), .regOut(Rs0)); //
    Register #(3) ALUOp_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(ALUOperation_cntrl0_Out), .regOut(AluOperation_EX));
    Register #(1) RegDst_Reg_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(RegDst_cntrl0_Out), .regOut(RegDst_EX));
    Register #(1) ALUSrc_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(AluSrc_cntrl0_Out), .regOut(AluSrc_EX));
    Register #(1) Mux_Jal_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(R31_cntrl0_Out), .regOut(R31_EX));
    Register #(1) MemRead_Reg_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemRead_cntrl0_Out), .regOut(MemRead_EX));
    Register #(1) MemWrite_Reg_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemWrite_cntrl0_Out), .regOut(MemWrite_EX));
    Register #(1) RegWrite_Reg_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(RegWrite_cntrl0_Out), .regOut(RegWrite_EX));
    Register #(1) WriteLink_Reg_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(WriteLink_cntrl0_Out), .regOut(WriteLink_EX));
    Register #(1) MemToReg_Reg_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemToReg_cntrl0_Out), .regOut(MemToReg_EX));
    // Register #(1) func_EX(.clk(clk), .rst(rst), .ld(1'b1), .regIn(func_minus1), .regOut(func));    
    // pipe ID/EX

    Mux4 #(32) Mux_ForwardA(.d0(ReadData1_1), .d1(WriteData), .d2(AluRes1), .d3(32'bz), .sel(A_forwarding), .w(Mux_ForwardA_Out)); // Does Mux4 work?
    Mux4 #(32) Mux_ForwardB(.d0(ReadData2_1), .d1(WriteData), .d2(AluRes1), .d3(32'bz), .sel(B_forwarding), .w(Mux_ForwardB_Out0));// problem solved
    Mux2 #(32) Mux_AluSrc(.d0(Mux_ForwardB_Out0), .d1(se_Out1), .sel(AluSrc_EX), .w(Mux_AluSrc_Out));
    Mux2 #(5) Mux_Dst(.d0(Rt0), .d1(Rd0), .sel(RegDst_EX), .w(Mux_Dst_Out));
    Mux2 #(5) Mux_Jal(.d0(Mux_Dst_Out), .d1(5'b11111), .sel(R31_EX), .w(Mux_Jal_Out0));
    wire dummy;
    Alu #(32) myALU(.A(Mux_ForwardA_Out), .B(Mux_AluSrc_Out), .op(AluOperation_EX), .res(AluRes0), .zero(dummy)); // zero isn't attached to anything

    // pipe EX/MEM
    Register #(32) PC_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(PC_Adder_Out2), .regOut(PC_Adder_Out3));
    Register #(32) AluRes_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(AluRes0), .regOut(AluRes1));
    Register #(32) Mux_ForwardB_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(Mux_ForwardB_Out0), .regOut(Mux_ForwardB_Out1));
    Register #(5) Mux_Jal_Out_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(Mux_Jal_Out0), .regOut(Mux_Jal_Out1));
    Register #(1) MemRead_Reg_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemRead_EX), .regOut(MemRead_MEM));
    Register #(1) MemWrite_Reg_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemWrite_EX), .regOut(MemWrite_MEM));
    Register #(1) RegWrite_Reg_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(RegWrite_EX), .regOut(RegWrite_MEM));
    Register #(1) WriteLink_Reg_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(WriteLink_EX), .regOut(WriteLink_MEM));
    Register #(1) MemToReg_Reg_MEM(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemToReg_EX), .regOut(MemToReg_MEM));
    // pipe EX/MEM

    Memory #(32, 32) DataMem(
        .Address(AluRes1),
        .WriteData(Mux_ForwardB_Out1),
        .MemRead(MemRead_MEM), .MemWrite(MemWrite_MEM), .clk(clk),
        .ReadData(MemReadData0)
    );

    // pipe MEM/WB
    Register #(32) PC_WB(.clk(clk), .rst(rst), .ld(1'b1), .regIn(PC_Adder_Out3), .regOut(PC_Adder_Out4));
    Register #(32) ReadData_WB(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemReadData0), .regOut(MemReadData1));
    Register #(32) AluRes_WB(.clk(clk), .rst(rst), .ld(1'b1), .regIn(AluRes1), .regOut(AluRes2));
    Register #(5) Mux_Jal_Out_WB(.clk(clk), .rst(rst), .ld(1'b1), .regIn(Mux_Jal_Out1), .regOut(Mux_Jal_Out2));
    Register #(1) RegWrite_Reg_WB(.clk(clk), .rst(rst), .ld(1'b1), .regIn(RegWrite_MEM), .regOut(RegWrite_WB)); //regwrite
    Register #(1) WriteLink_Reg_WB(.clk(clk), .rst(rst), .ld(1'b1), .regIn(WriteLink_MEM), .regOut(WriteLink_WB));
    Register #(1) MemToReg_Reg_WB(.clk(clk), .rst(rst), .ld(1'b1), .regIn(MemToReg_MEM), .regOut(MemToReg_WB));
    // pipe MEM/WB

    Mux2 #(32) Mux_WriteLink(.d0(Mux_MemToReg_Out), .d1(PC_Adder_Out4), .sel(WriteLink_WB), .w(WriteData));
    Mux2 #(32) Mux_MemToReg(.d0(AluRes2), .d1(MemReadData1), .sel(MemToReg_WB), .w(Mux_MemToReg_Out));


    assign opcode = Instruction1[31:26];
    // assign func_minus1 = Instruction1[5:0]; // func has to be passed to alu controller in execution level!
    assign func = Instruction1[5:0];

    assign Rs_hazard_ID = Instruction1[25:21];
    assign Rt_hazard_ID = Instruction1[20:16];
    assign Rt_hazard_EX = Rt0;

    assign MemRead_hazard_EX = MemRead_EX;

    assign Rs_forward = Rs0;
    assign Rt_forward = Rt0;
    assign RegWrite_forward_MEM = RegWrite_MEM;
    assign RegWrite_forward_WB = RegWrite_WB;
    assign Rd_forward_MEM = Mux_Jal_Out1;
    assign Rd_forward_WB = Mux_Jal_Out2;

    assign EQ = zero;

endmodule