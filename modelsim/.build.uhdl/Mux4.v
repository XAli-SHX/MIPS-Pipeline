module Mux4(d0, d1, d2, d3, sel, w);

    parameter DATA_SIZE = 32;

    input [(DATA_SIZE - 1):0] d0, d1, d2, d3;
    input [1:0] sel;
    output [(DATA_SIZE - 1):0] w;

    assign w = (sel == 2'b00) ? d0:
    (sel == 2'b01) ? d1:
    (sel == 2'b10) ? d2:
    (sel == 2'b11) ? d3: {DATA_SIZE{1'bz}};
    
endmodule