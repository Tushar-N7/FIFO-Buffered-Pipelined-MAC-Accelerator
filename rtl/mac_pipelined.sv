module mac_pipelined #(
    parameter WIDTH = 8
)(
    input  logic                 clk,
    input  logic                 rst,

    input  logic [WIDTH-1:0]     a,
    input  logic [WIDTH-1:0]     b,
    input  logic [2*WIDTH-1:0]   acc,

    output logic [2*WIDTH-1:0]   result
);

    // ------------------------------------------------
    // Pipeline Stage 1
    // Multiply A and B
    // ------------------------------------------------

    logic [2*WIDTH-1:0] product_reg;
    logic [2*WIDTH-1:0] acc_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            product_reg <= '0;
            acc_reg     <= '0;
        end
        else begin
            product_reg <= a * b;
            acc_reg     <= acc;
        end
    end

    // ------------------------------------------------
    // Pipeline Stage 2
    // Add product and accumulated value
    // ------------------------------------------------

    always_ff @(posedge clk) begin
        if (rst) begin
            result <= '0;
        end
        else begin
            result <= product_reg + acc_reg;
        end
    end

endmodule