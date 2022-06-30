module RegisterFileTB ();

    reg [1:0] ReadReg1 = 2'b00, ReadReg2 = 2'b01, WriteReg = 2'b00;
    reg [3:0] WriteData = 2'b11;
    reg clk = 0, RegWrite = 0;
    wire [3:0] ReadData1, ReadData2;

    RegisterFile #(4, 2) UUT (
        .ReadReg1(ReadReg1), .ReadReg2(ReadReg2), .WriteReg(WriteReg),
        .WriteData(WriteData),
        .clk(clk), .RegWrite(RegWrite),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    always #11 clk <= ~clk;
    initial begin
        #54 WriteReg = 2'b00; RegWrite = 1;
        #54 WriteReg = 2'b01; RegWrite = 1;
        #54 ReadReg1 = 2'b10; ReadReg2 = 2'b11;
        #54 WriteReg = 2'b10; RegWrite = 1;
        #54 WriteReg = 2'b11; RegWrite = 1;
        #200 $stop;
    end

endmodule
