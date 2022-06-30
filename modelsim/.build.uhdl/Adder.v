module Adder #(parameter SIZE = 8) (
    input [(SIZE-1):0] A, B,
    input sub,
    output [(SIZE-1):0] res
);

    assign res = sub ? (A - B) : (A + B);
    
endmodule