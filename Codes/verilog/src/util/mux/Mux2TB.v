module Mux2TB();

    reg [3:0] d0, d1;
    assign d0 = 4'b0000;
    assign d1 = 4'b1111;
    reg sel;
    wire [3:0] w;
    Mux2 #(4) UUT(d0, d1, sel, w);

    initial begin
        #20 sel = 0;
        #20 sel = 1;
        #200 $stop;
    end

endmodule