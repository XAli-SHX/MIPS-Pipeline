module InstructionMemory #(parameter ADDRESS_SIZE = 32, WORD_SIZE = 32) (
    input clk,
    input [31:0] Address,
    output reg [31:0] Instruction
);

    reg [7:0] mem [0:564364];

    initial begin
        $readmemb("../Codes/mem/instruction.mem", mem);
    end
        
    assign Instruction = {mem[Address], mem[Address+1], mem[Address+2], mem[Address+3]};

endmodule
