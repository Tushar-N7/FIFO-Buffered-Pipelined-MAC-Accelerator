`timescale 1ns/1ps

module mac_fifo_pipelined_tb;

    parameter WIDTH = 8;
    parameter FIFO_DEPTH = 8;

    logic clk;
    logic rst;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [2*WIDTH-1:0] acc;

    logic write_en;
    logic read_en;

    logic [2*WIDTH-1:0] result;

    logic fifo_full;
    logic fifo_empty;

    mac_fifo_pipelined_top #(
        .WIDTH(WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),

        .a(a),
        .b(b),
        .acc(acc),

        .write_en(write_en),
        .read_en(read_en),

        .result(result),

        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task automatic test_mac(
        input integer test_a,
        input integer test_b,
        input integer test_acc
    );

        integer expected;

        begin
            expected = (test_a * test_b) + test_acc;

            // Write transaction
            @(negedge clk);

            a        = test_a;
            b        = test_b;
            acc      = test_acc;
            write_en = 1;
            read_en  = 0;

            @(posedge clk);
            #1;

            write_en = 0;

            // Read from FIFO
            @(negedge clk);

            read_en = 1;

            @(posedge clk);
            #1;

            read_en = 0;

            // Wait for pipelined MAC result
            @(posedge clk);
            #1;

            if (result == expected) begin
                $display(
                    "TEST PASSED: %0d x %0d + %0d = %0d",
                    test_a, test_b, test_acc, result
                );
            end
            else begin
                $display(
                    "TEST FAILED: %0d x %0d + %0d | Expected=%0d Got=%0d",
                    test_a, test_b, test_acc, expected, result
                );
            end
        end

    endtask

    initial begin

        $dumpfile("mac_fifo_pipelined.vcd");
        $dumpvars(0, mac_fifo_pipelined_tb);

        a = 0;
        b = 0;
        acc = 0;

        write_en = 0;
        read_en = 0;

        rst = 1;

        repeat (2)
            @(posedge clk);

        #1;
        rst = 0;

        test_mac(5, 4, 10);
        test_mac(10, 3, 20);
        test_mac(15, 15, 5);
        test_mac(0, 100, 25);
        test_mac(25, 8, 50);
        test_mac(255, 255, 100);

        $display("--------------------------------");
        $display("FIFO + PIPELINED MAC SIMULATION COMPLETE");
        $display("--------------------------------");

        $finish;

    end

endmodule