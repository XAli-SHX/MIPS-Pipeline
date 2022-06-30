module AluController(
    input [1:0] AluOp, input [5:0] func, 
    output reg [2:0] AluOperation
);

    always @(AluOp, func) begin
        case (AluOp)
            2'b10: begin
                case (func)
                    6'b100000: AluOperation = 3'b010; // add
                    6'b100010: AluOperation = 3'b110; // sub
                    6'b100001: AluOperation = 3'b000; // and
                    6'b100101: AluOperation = 3'b001; // or
                    6'b101010: AluOperation = 3'b111; // slt
                endcase
            end
            2'b11: AluOperation = 3'b111; // slt
            2'b00: AluOperation = 3'b010; // add
            2'b01: AluOperation = 3'b110; // sub
        endcase    
    end

endmodule