module SignExtendTB();

    reg [3:0] in;
    wire [7:0] out;

    SignExtend #(4, 8) UUT(.in(in), .out(out));

    initial begin
        #20 in = 4'b0111;
        #20 in = 4'b1111;
        #20 in = 4'b0101;
        #20 in = 4'b1010;
        #200 $stop;
    end

endmodule