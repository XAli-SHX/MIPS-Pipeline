module Mux2(d0, d1, sel, w);

    parameter DATA_SIZE = 32;

    input [(DATA_SIZE-1):0] d0, d1;
    input sel;
    output [(DATA_SIZE-1):0] w;
    assign w = sel ? d1 : d0;

endmodule