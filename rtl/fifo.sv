module fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 8
)(
    input  logic                  clk,
    input  logic                  rst,

    input  logic                  wr_en,
    input  logic                  rd_en,

    input  logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout,

    output logic                  full,
    output logic                  empty
);

    // FIFO storage
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Read and write pointers
    logic [$clog2(DEPTH)-1:0] wr_ptr;
    logic [$clog2(DEPTH)-1:0] rd_ptr;

    // Number of stored elements
    logic [$clog2(DEPTH+1)-1:0] count;

    // Write operation
    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
        end
        else if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // Read operation
    always_ff @(posedge clk) begin
        if (rst) begin
            rd_ptr <= 0;
            dout   <= 0;
        end
        else if (rd_en && !empty) begin
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Count number of stored elements
    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end

    // Status flags
    assign empty = (count == 0);
    assign full  = (count == DEPTH);

endmodule