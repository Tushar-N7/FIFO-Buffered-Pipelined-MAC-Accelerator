module mac #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2*WIDTH-1:0] acc,

    output logic [2*WIDTH-1:0] result
);

    logic [2*WIDTH-1:0] product;

    // Multiplication
    assign product = a * b;

    // Multiply-Accumulate
    assign result = product + acc;

endmodule