`timescale 1ns/1ps

module fifo_tb;

    parameter DATA_WIDTH = 32;
    parameter DEPTH = 8;

    logic clk;
    logic rst;

    logic wr_en;
    logic rd_en;

    logic [DATA_WIDTH-1:0] din;
    logic [DATA_WIDTH-1:0] dout;

    logic full;
    logic empty;

    // ------------------------------------------------
    // Instantiate FIFO
    // ------------------------------------------------

    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),

        .wr_en(wr_en),
        .rd_en(rd_en),

        .din(din),
        .dout(dout),

        .full(full),
        .empty(empty)
    );

    // ------------------------------------------------
    // Clock generation
    // ------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------
    // Test sequence
    // ------------------------------------------------

    initial begin

        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);

        // Initial values
        clk   = 0;
        rst   = 1;
        wr_en = 0;
        rd_en = 0;
        din   = 0;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #10;
        rst = 0;

        // ------------------------------------------------
        // Test 1: Write data
        // ------------------------------------------------

        @(negedge clk);
        wr_en = 1;
        din = 32'd100;

        @(negedge clk);
        din = 32'd200;

        @(negedge clk);
        din = 32'd300;

        @(negedge clk);
        wr_en = 0;

        $display("TEST 1: Data written to FIFO");

        // ------------------------------------------------
        // Test 2: Read data
        // ------------------------------------------------

        @(negedge clk);
        rd_en = 1;

        @(posedge clk);
        #1;

        if (dout == 100)
            $display("TEST 2A PASSED: Read %0d", dout);
        else
            $display("TEST 2A FAILED: Expected 100, Got %0d", dout);

        @(posedge clk);
        #1;

        if (dout == 200)
            $display("TEST 2B PASSED: Read %0d", dout);
        else
            $display("TEST 2B FAILED: Expected 200, Got %0d", dout);

        @(posedge clk);
        #1;

        if (dout == 300)
            $display("TEST 2C PASSED: Read %0d", dout);
        else
            $display("TEST 2C FAILED: Expected 300, Got %0d", dout);

        @(negedge clk);
        rd_en = 0;

        // ------------------------------------------------
        // Test 3: Empty flag
        // ------------------------------------------------

        @(posedge clk);
        #1;

        if (empty)
            $display("TEST 3 PASSED: FIFO is empty");
        else
            $display("TEST 3 FAILED: FIFO should be empty");

        // ------------------------------------------------
        // Test 4: Fill FIFO
        // ------------------------------------------------

        @(negedge clk);
        wr_en = 1;
        din = 32'd400;

        repeat (DEPTH) begin
            @(negedge clk);
            din = din + 1;
        end

        @(negedge clk);
        wr_en = 0;

        @(posedge clk);
        #1;

        if (full)
            $display("TEST 4 PASSED: FIFO is full");
        else
            $display("TEST 4 FAILED: FIFO should be full");

        // ------------------------------------------------
        // Test complete
        // ------------------------------------------------

        $display("--------------------------------");
        $display("FIFO SIMULATION COMPLETE");
        $display("--------------------------------");

        $finish;

    end

endmodule