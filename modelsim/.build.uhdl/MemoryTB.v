module MemoryTB ();
    
    reg [31:0] Address = 0;
    reg [31:0] WriteData = 1;
    reg MemRead = 1, MemWrite = 0, clk = 0;
    wire [31:0] ReadData;
    Memory #(32, 32) UUT(
        .Address(Address),
        .WriteData(WriteData),
        .MemRead(MemRead), .MemWrite(MemWrite), .clk(clk),
        .ReadData(ReadData)
    );

    always #11 clk <= ~clk;
    initial begin
        #53 MemWrite = 1; MemRead = 0;
        #53 Address = 0; WriteData = 2;
        #53 Address = Address + 1; WriteData = 3;
        #53 Address = Address + 1; WriteData = 4;
        #53 Address = Address + 1; WriteData = 5;
        #53 Address = Address + 1; WriteData = 6;
        #53 MemWrite = 0; MemRead = 1;
        #53 Address = 0;
        #53 Address = Address + 4;
        #53 Address = Address + 4;
        #53 Address = Address + 4;
        #53 Address = Address + 4;
        #53 Address = 1000;
        #53 Address = Address + 1;
        #53 Address = Address + 1;
        #53 Address = Address + 1;
        #53 Address = Address + 1;
        #53 Address = Address + 1;
        #300 $stop;
    end

endmodule
