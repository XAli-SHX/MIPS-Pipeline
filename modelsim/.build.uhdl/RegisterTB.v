module RegisterTB();
    
    reg clk = 0, rst = 0, ld = 0;
    reg [3:0] regIn;
    wire [3:0] regOut;

    Register #(4) UUT(
        .clk(clk),
        .rst(rst),
        .ld(ld),
        .regIn(regIn),
        .regOut(regOut)
    );
    
    always #11 clk <= ~clk;

    initial begin
        #53 rst = 1; regIn = 4'b1100;
        #53 ld = 1; rst = 0;
        #53 ld = 0;
        #67 regIn = 4'b0101;
        #53 ld = 1;
        #200 $stop;
    end

endmodule
