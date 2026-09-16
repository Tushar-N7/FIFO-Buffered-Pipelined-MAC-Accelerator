module mac_fifo_top #(
    parameter WIDTH = 8,
    parameter FIFO_DEPTH = 8
)(
    input  logic clk,
    input  logic rst,

    // Input data
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2*WIDTH-1:0] acc,

    // Control
    input  logic write_en,
    input  logic read_en,

    // Output
    output logic [2*WIDTH-1:0] result,

    // FIFO status
    output logic fifo_full,
    output logic fifo_empty
);

    // ------------------------------------------------
    // Pack MAC inputs into one FIFO word
    // ------------------------------------------------

    localparam FIFO_DATA_WIDTH = 4 * WIDTH;

    logic [FIFO_DATA_WIDTH-1:0] fifo_din;
    logic [FIFO_DATA_WIDTH-1:0] fifo_dout;

    assign fifo_din = {a, b, acc};

    // ------------------------------------------------
    // FIFO
    // ------------------------------------------------

    fifo #(
        .DATA_WIDTH(FIFO_DATA_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) data_fifo (
        .clk(clk),
        .rst(rst),

        .wr_en(write_en),
        .rd_en(read_en),

        .din(fifo_din),
        .dout(fifo_dout),

        .full(fifo_full),
        .empty(fifo_empty)
    );

    // ------------------------------------------------
    // Extract MAC inputs from FIFO output
    // ------------------------------------------------

    logic [WIDTH-1:0] mac_a;
    logic [WIDTH-1:0] mac_b;
    logic [2*WIDTH-1:0] mac_acc;

    assign mac_a   = fifo_dout[4*WIDTH-1:3*WIDTH];
    assign mac_b   = fifo_dout[3*WIDTH-1:2*WIDTH];
    assign mac_acc = fifo_dout[2*WIDTH-1:0];

    // ------------------------------------------------
    // MAC
    // ------------------------------------------------

    mac #(
        .WIDTH(WIDTH)
    ) mac_unit (
        .a(mac_a),
        .b(mac_b),
        .acc(mac_acc),
        .result(result)
    );

endmodule