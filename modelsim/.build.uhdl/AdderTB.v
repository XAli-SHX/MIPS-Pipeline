module AdderTB();

    reg [3:0] A = 4'b0000, B = 4'b0000;
    reg sub = 0;
    wire [3:0] res;
    Adder #(4) UUT (
        .A(A), .B(B), .sub(sub), .res(res)
    );

    initial begin
        #20 A = 4'b0001; B = 4'b0000;
        #20 sub = 0;
        #20 sub = 1;
        #20 A = 4'b0001; B = 4'b0001;
        #20 sub = 0;
        #20 sub = 1;
        #20 A = 4'b0100; B = 4'b0110;
        #20 sub = 0;
        #20 sub = 1;
        #20 A = 4'b0010; B = 4'b1000;
        #20 sub = 0;
        #20 sub = 1;
        #200 $stop;
    end
    
endmodule