module test_main();
    reg clk = 0;
    reg rst = 0;
    always #1 clk = !clk;
    initial #1000 $finish;
    main main_sch(.clk(clk), .rst(rst));
    initial begin
        $dumpfile("vcd/test_main.vcd");
        $dumpvars(0, main_sch);
        rst <= #2 1;
        rst <= #4 0;
    end
endmodule