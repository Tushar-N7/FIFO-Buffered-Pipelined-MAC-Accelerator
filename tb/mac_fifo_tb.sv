`timescale 1ns/1ps

module mac_fifo_tb;

    parameter WIDTH = 8;
    parameter FIFO_DEPTH = 8;
    parameter NUM_TESTS = 100;

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

    integer i;
    integer passed;
    integer failed;

    logic [2*WIDTH-1:0] expected;

    // ------------------------------------------------
    // Instantiate FIFO + MAC
    // ------------------------------------------------

    mac_fifo_top #(
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

    // ------------------------------------------------
    // Clock generation
    // ------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------
    // Randomized test
    // ------------------------------------------------

    initial begin

        $dumpfile("mac_fifo_random.vcd");
        $dumpvars(0, mac_fifo_tb);

        // Initial values
        clk      = 0;
        rst      = 1;

        a        = 0;
        b        = 0;
        acc      = 0;

        write_en = 0;
        read_en  = 0;

        passed   = 0;
        failed   = 0;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #10;
        rst = 0;

        $display("--------------------------------");
        $display("RANDOMIZED MAC + FIFO TEST");
        $display("Number of tests = %0d", NUM_TESTS);
        $display("--------------------------------");

        // ------------------------------------------------
        // Run random tests
        // ------------------------------------------------

        for (i = 0; i < NUM_TESTS; i = i + 1) begin

            // Generate random inputs
            a   = $urandom_range(0, (2**WIDTH)-1);
            b   = $urandom_range(0, (2**WIDTH)-1);
            acc = $urandom_range(0, (2**(2*WIDTH))-1);

            // Calculate expected result
            expected = (a * b) + acc;

            // ------------------------------------------------
            // Write transaction
            // ------------------------------------------------

            @(negedge clk);

            write_en = 1;

            @(negedge clk);

            write_en = 0;

            // ------------------------------------------------
            // Read transaction
            // ------------------------------------------------

            @(negedge clk);

            read_en = 1;

            @(posedge clk);
            #1;

            // ------------------------------------------------
            // Compare actual vs expected
            // ------------------------------------------------

            if (result == expected) begin

                passed = passed + 1;

                $display(
                    "TEST %0d PASSED: A=%0d B=%0d ACC=%0d RESULT=%0d",
                    i + 1,
                    a,
                    b,
                    acc,
                    result
                );

            end
            else begin

                failed = failed + 1;

                $display(
                    "TEST %0d FAILED: A=%0d B=%0d ACC=%0d EXPECTED=%0d GOT=%0d",
                    i + 1,
                    a,
                    b,
                    acc,
                    expected,
                    result
                );

            end

            @(negedge clk);

            read_en = 0;

        end

        // ------------------------------------------------
        // Final results
        // ------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("RANDOMIZED VERIFICATION COMPLETE");
        $display("--------------------------------");
        $display("Total Tests : %0d", NUM_TESTS);
        $display("Passed      : %0d", passed);
        $display("Failed      : %0d", failed);

        if (failed == 0)
            $display("RESULT      : ALL TESTS PASSED");
        else
            $display("RESULT      : VERIFICATION FAILED");

        $display("--------------------------------");

        $finish;

    end

endmodule