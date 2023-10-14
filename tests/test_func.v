module test_func();
    reg clk = 0;
    reg rst = 0;
    always #1 clk = !clk;
    initial #1000 $finish;

    parameter W = 8;
    reg [W-1:0] d;
    reg row;
    reg [0:1] col;
    reg [3:0] action;
    wire t_busy;
    wire r_busy;
    wire [W-1:0] t_cell;
    wire [W-1:0] r_cell;

    main main_sch(.clk(clk), .rst(rst), .d(d), .row(row), .col(col), .action(action), .t_busy(t_busy), .r_busy(r_busy), .t_cell(t_cell), .r_cell(r_cell));
    initial begin
        $dumpfile("vcd/test_func.vcd");
        $dumpvars(0, main_sch);
        d <= #1 0; row <= #1 0; col <= #1 0; action <= #1 0;
        rst <= #2 1;
        rst <= #4 0;

        // complex test that tests all actions

        // fill matrix on transmitter with:
        // 1, 2, 3, 4
        // 5, 6, 7, 8
        d <= #4 1;  row <= #4 0;    col <= #4 0;
        action <= #6 1;
        d <= #8 2;  row <= #8 0;    col <= #8 1;
        d <= #12 3;  row <= #12 0;    col <= #12 2;
        d <= #16 4; row <= #16 0;   col <= #16 3;
        d <= #20 5; row <= #20 1;   col <= #20 0;
        d <= #24 6; row <= #24 1;   col <= #24 1;
        d <= #28 7; row <= #28 1;   col <= #28 2;
        d <= #32 8; row <= #32 1;   col <= #32 3;

        // transmit matrix[1][3] (= 8)
        action <= #34 2;

        // and right after that transmit row matrix[0] (= 1, 2, 3, 4)
        row <= #40 0;
        action <= #40 3;
    
        // after second trasmission stop doing anything
        action <= #100 0;

        // matrix[1][2] = 170
        action <= #306 1;
        d <= #306 170;  row <= #306 1;    col <= #306 2;
        // matrix[0][2] = 85
        d <= #310 85;  row <= #310 0;    col <= #310 2;

        // transmit column matrix[][2] (= 85, 170)
        action <= #314 4;

        // after trasmission stop doing anything
        action <= #320 0;


        // watch matrices through t_cell and r_cell in 960-990 seconds
        // matrix on transmitter must be:
        // 1,   2,  85, 4
        // 5,   6,  170,8
        // matrix on receiver must be:
        // 1,   2,  85, 4
        // 0,   0,  170,8

        row <= #960 0;  col <= #960 0;
        row <= #964 0;  col <= #964 1;
        row <= #968 0;  col <= #968 2;
        row <= #972 0;  col <= #972 3;
        row <= #976 1;  col <= #976 0;
        row <= #980 1;  col <= #980 1;
        row <= #984 1;  col <= #984 2;
        row <= #988 1;  col <= #988 3;
    end
endmodule