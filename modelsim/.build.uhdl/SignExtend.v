module SignExtend(in, out);

    parameter IN_SIZE = 16, OUT_SIZE = 32;
    input [(IN_SIZE-1):0] in;
    input [(OUT_SIZE-1):0] out;
    assign out = {{(OUT_SIZE-IN_SIZE){in[(IN_SIZE-1)]}},in[(IN_SIZE-1):0]};

endmodule