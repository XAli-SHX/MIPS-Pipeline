module InstructionMemoryTB();

    reg clk = 0;
    reg [31:0] Address = 0;
    wire [31:0] Instruction;

    InstructionMemory #(32, 32) UUT(
        .clk(clk),
        .Address(Address),
        .Instruction(Instruction)
    );

    always #11 clk <= ~clk;

    initial begin
        #54 Address = 0;
        #54 Address = 4;
        #54 Address = 8;
        #54 Address = 12;
        #54 Address = 16;
        #54 Address = 20;
        #54 Address = 24;
        #54 Address = 28;
        #54 Address = 32;
        #54 Address = 36;
        #54 Address = 40;
        #200 $stop;
    end

endmodule
