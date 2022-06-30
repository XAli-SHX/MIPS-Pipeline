module RegisterFile #(parameter WORD_SIZE = 32, ADDRESS_SIZE = 5) (
    input [(ADDRESS_SIZE-1):0] ReadReg1, ReadReg2, WriteReg,
    input [(WORD_SIZE-1):0] WriteData,
    input clk, RegWrite,
    output reg [(WORD_SIZE-1):0] ReadData1, ReadData2
);

    reg [(WORD_SIZE-1):0] memReg [0:((1<<ADDRESS_SIZE)-1)];
    assign ReadData1 = memReg[ReadReg1];    
    assign ReadData2 = memReg[ReadReg2];

    always @(posedge clk) begin
        memReg[0] = 32'b0;
        if(RegWrite & (WriteReg != 5'b0))       
            memReg[WriteReg] <= WriteData;
    end

endmodule