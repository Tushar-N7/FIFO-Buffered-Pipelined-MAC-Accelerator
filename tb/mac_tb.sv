`timescale 1ns/1ps

module mac_tb;

    parameter WIDTH = 8;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [2*WIDTH-1:0] acc;

    logic [2*WIDTH-1:0] result;

    // Instantiate MAC
    mac #(
        .WIDTH(WIDTH)
    ) dut (
        .a(a),
        .b(b),
        .acc(acc),
        .result(result)
    );

    // Test procedure
    initial begin

        $dumpfile("mac.vcd");
        $dumpvars(0, mac_tb);

        // Test 1
        a = 5;
        b = 4;
        acc = 10;

        #10;

        if (result == 30)
            $display("TEST 1 PASSED: %0d x %0d + %0d = %0d",
                     a, b, acc, result);
        else
            $display("TEST 1 FAILED: Expected 30, Got %0d",
                     result);


        // Test 2
        a = 10;
        b = 3;
        acc = 20;

        #10;

        if (result == 50)
            $display("TEST 2 PASSED");
        else
            $display("TEST 2 FAILED: Expected 50, Got %0d",
                     result);


        // Test 3
        a = 15;
        b = 15;
        acc = 5;

        #10;

        if (result == 230)
            $display("TEST 3 PASSED");
        else
            $display("TEST 3 FAILED: Expected 230, Got %0d",
                     result);


        // Test 4
        a = 0;
        b = 100;
        acc = 25;

        #10;

        if (result == 25)
            $display("TEST 4 PASSED");
        else
            $display("TEST 4 FAILED: Expected 25, Got %0d",
                     result);


        $display("--------------------------------");
        $display("MAC SIMULATION COMPLETE");
        $display("--------------------------------");

        $finish;

    end

endmodule