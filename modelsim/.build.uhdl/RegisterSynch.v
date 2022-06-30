module RegisterSynch(clk, rst, clr, ld, regIn, regOut);

    parameter SIZE = 8;
    input clk, rst, ld, clr;
    input [(SIZE-1):0] regIn;
    output reg [(SIZE-1):0] regOut;
    
    always@(posedge clk, posedge rst) begin
        if(rst)
            regOut <= 0;
        else if(clr)
            regOut <= 0;
        else if(ld)
            regOut <= regIn;
    end

endmodule