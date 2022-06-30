module AluTB();
    
    reg [3:0] A = 3'b000, B = 3'b000;
    reg [2:0] op = 3'b000;
    wire [3:0] res;
    wire zero;

    Alu #(4) UUT(
        .A(A), .B(B),
        .op(op),
        .res(res), .zero(zero)
    );

    initial begin
        #20 A = 3'b010; B = 3'b001;
        #20 op = 3'b000;
        #20 op = 3'b001;
        #20 op = 3'b010;
        #20 op = 3'b110;
        #20 op = 3'b111;
        #20 A = 3'b001; B = 3'b110;
        #20 A = 3'b110; B = 3'b110;
        #20 op = 3'b110;
        #200 $stop;
    end

endmodule
