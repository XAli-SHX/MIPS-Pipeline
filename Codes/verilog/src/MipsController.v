module MipsController (
    opcode, func, MemToReg, MemRead, MemWrite, RegWrite, ALUOperation, Branch, jump, jr, WriteLink, RegDst, R31, ALUSrc, EQ, flush 
);
    input [5:0] opcode, func;
    input EQ;
    output reg flush, MemToReg, MemRead, MemWrite, RegWrite, Branch,
    jump, jr, WriteLink, RegDst, R31, ALUSrc;
    output [2:0] ALUOperation;
    reg[1:0] ALUOp;

    AluController AluCtrl(.func(func), .AluOp(ALUOp), .AluOperation(ALUOperation)); // ALU Ctrl Instance

    always @(opcode) begin
        MemToReg = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Branch = 1'b0; flush = 1'b0;
        jump = 1'b0; jr = 1'b0; WriteLink = 1'b0; RegDst = 1'b0; R31 = 1'b0; ALUSrc = 1'b0; ALUOp = 2'b00;
        case(opcode)
            6'b000000: begin // R-type
                ALUOp = 2'b10;
                RegWrite = 1'b1;
                RegDst = 1'b1;
            end
            6'b001000: begin // addi
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
            end
            6'b001010: begin // slti
                ALUSrc = 1'b1;
                ALUOp = 2'b11;
                RegWrite = 1'b1;
            end
            6'b100011: begin // lw
                MemRead = 1;
                MemToReg = 1;
                ALUSrc = 1;
                RegWrite = 1;
            end
            6'b101011: begin // sw
                MemWrite = 1;
                ALUSrc = 1;
            end
            6'b000100: begin // beq
                flush = EQ ? 1'b1 : 1'b0;
                ALUOp = 2'b01;
                Branch = 1'b1;
            end
            6'b100000: begin // jr
                flush = 1'b1;
                jr = 1;
                jump = 1;
            end
            6'b000010: begin // j
                flush = 1'b1;
                ALUSrc = 1;
                jump = 1;
            end
            6'b000011: begin // jal
                flush = 1'b1;
                ALUSrc = 1;
                RegWrite = 1;
                jump = 1;
                WriteLink = 1;
                R31 = 1;
            end
        endcase    
    end
    
endmodule