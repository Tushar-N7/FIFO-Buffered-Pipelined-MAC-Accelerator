`timescale 1ns/1ps

module mac_pipelined_tb;

    parameter WIDTH = 8;

    logic clk;
    logic rst;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [2*WIDTH-1:0] acc;

    logic [2*WIDTH-1:0] result;

    mac_pipelined #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .acc(acc),
        .result(result)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    task automatic test_mac(
        input integer test_a,
        input integer test_b,
        input integer test_acc
    );

        integer expected;

        begin
            expected = (test_a * test_b) + test_acc;

            // Drive inputs away from rising edge
            @(negedge clk);

            a   = test_a;
            b   = test_b;
            acc = test_acc;

            // Stage 1: multiplication is captured
            @(posedge clk);

            // Stage 2: addition/result is captured
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

        $dumpfile("mac_pipelined.vcd");
        $dumpvars(0, mac_pipelined_tb);

        // Initial values
        a   = 0;
        b   = 0;
        acc = 0;

        // Reset
        rst = 1;

        repeat (2)
            @(posedge clk);

        #1;
        rst = 0;

        // --------------------------------
        // Directed Tests
        // --------------------------------

        test_mac(5, 4, 10);

        test_mac(10, 3, 20);

        test_mac(15, 15, 5);

        test_mac(0, 100, 25);

        test_mac(25, 8, 50);

        test_mac(255, 255, 100);

        // --------------------------------
        // Complete
        // --------------------------------

        $display("--------------------------------");
        $display("PIPELINED MAC SIMULATION COMPLETE");
        $display("--------------------------------");

        $finish;

    end

endmodule