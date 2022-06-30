module MipsTB();

    reg clk = 0, rst = 0;
    Mips DUT (clk, rst);

    always #11 clk <= ~clk;
    initial begin
        #23 rst = 1;
        #23 rst = 0;
        #8000 
        $display(
            "mem[2000..2003] = %h %h %h %h", 
            DUT.DP.DataMem.mem[2000],
            DUT.DP.DataMem.mem[2001],
            DUT.DP.DataMem.mem[2002],
            DUT.DP.DataMem.mem[2003],
        ); 
        $display(
            "mem[2004..2007] = %h %h %h %h", 
            DUT.DP.DataMem.mem[2004],
            DUT.DP.DataMem.mem[2005],
            DUT.DP.DataMem.mem[2006],
            DUT.DP.DataMem.mem[2007],
        ); 
        #5 $stop;
    end

    /*
    add wave -position insertpoint \
    sim:/MipsTB/clk \
    sim:/MipsTB/rst \
    sim:/MipsTB/DUT/DP/PC/regOut \
    sim:/MipsTB/DUT/DP/RegFile/memReg \
    sim:/MipsTB/DUT/DP/Mux_ForwardB/sel \
    sim:/MipsTB/DUT/DP/Mux_ForwardB/w \
    sim:/MipsTB/DUT/DP/Mux_ForwardA/sel \
    sim:/MipsTB/DUT/DP/Mux_ForwardA/w \
    sim:/MipsTB/DUT/DP/ALUOp_EX/regIn \
    sim:/MipsTB/DUT/DP/ALUOp_EX/regOut \
    sim:/MipsTB/DUT/CU/EQ \
    sim:/MipsTB/DUT/CU/Branch \
    sim:/MipsTB/DUT/CU/jump \
    sim:/MipsTB/DUT/CU/jr \
    sim:/MipsTB/DUT/FU/ForwardA \
    sim:/MipsTB/DUT/FU/ForwardB \
    sim:/MipsTB/DUT/DP/Instruction0 \
    sim:/MipsTB/DUT/DP/Instruction1 \
    sim:/MipsTB/DUT/CU/flush \
    sim:/MipsTB/DUT/DP/Instruction_ID/regIn \
    sim:/MipsTB/DUT/DP/Instruction_ID/regOut \
    sim:/MipsTB/DUT/DP/RegFile/ReadData1 \
    sim:/MipsTB/DUT/DP/RegFile/ReadData2 \
    sim:/MipsTB/DUT/DP/ReadData1_EX/regOut \
    sim:/MipsTB/DUT/DP/ReadData2_EX/regOut \
    sim:/MipsTB/DUT/DP/RegFile/WriteReg \
    sim:/MipsTB/DUT/DP/RegFile/WriteData \
    sim:/MipsTB/DUT/DP/RegFile/RegWrite \
    sim:/MipsTB/DUT/HU/cntrl0 \
    sim:/MipsTB/DUT/DP/DataMem/Address \
    sim:/MipsTB/DUT/DP/DataMem/WriteData \
    sim:/MipsTB/DUT/DP/DataMem/MemRead \
    sim:/MipsTB/DUT/DP/DataMem/MemWrite \
    sim:/MipsTB/DUT/DP/DataMem/ReadData \
    sim:/MipsTB/DUT/DP/myALU/res \
    sim:/MipsTB/DUT/DP/myALU/A \
    sim:/MipsTB/DUT/DP/myALU/B \
    sim:/MipsTB/DUT/DP/myALU/op



    --------------------------------------
    -> Hazard Unit
    sim:/MipsTB/DUT/HU/ID_EX_MemRead \
    sim:/MipsTB/DUT/HU/ID_Ex_Rt \
    sim:/MipsTB/DUT/HU/Rs \
    sim:/MipsTB/DUT/HU/Rt \
    sim:/MipsTB/DUT/HU/cntrl0 \
    sim:/MipsTB/DUT/HU/IF_ID_Write \
    sim:/MipsTB/DUT/HU/PCwrite \
    */

endmodule