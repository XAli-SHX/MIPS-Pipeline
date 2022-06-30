module Compare #(
    parameter SIZE = 32
) (
    input [(SIZE-1):0] A, B,
    output zero
);

    assign zero = (A==B) ? 1'b1 : 1'b0;
    
endmodule