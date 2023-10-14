module test_w_div_par_1();
    reg clk = 0;
    reg rst = 0;
    always #1 clk = !clk;
    initial #2000 $finish;

    parameter W = 11;
    reg [W-1:0] d;
    reg row;
    reg [0:1] col;
    reg [3:0] action;
    wire t_busy;
    wire r_busy;
    wire [W-1:0] t_cell;
    wire [W-1:0] r_cell;

    main #(.W(W), .DIV(10), .PAR(1)) main_sch(.clk(clk), .rst(rst), .d(d), .row(row), .col(col), .action(action), .t_busy(t_busy), .r_busy(r_busy), .t_cell(t_cell), .r_cell(r_cell));
    initial begin
        $dumpfile("vcd/test_w_div_par_1.vcd");
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
        action <= #338 0;

        action <= #1300 1;
        d <= #1300 1365;    row <= #1300 1;     col <= #1300 2;
        d <= #1304 682;     row <= #1304 0;     col <= #1304 2;

        // transmit column matrix[][2]
        action <= #1308 4;

        // after trasmission stop doing anything
        action <= #1324 0;

        row <= #1960 0;  col <= #1960 0;
        row <= #1964 0;  col <= #1964 1;
        row <= #1968 0;  col <= #1968 2;
        row <= #1972 0;  col <= #1972 3;
        row <= #1976 1;  col <= #1976 0;
        row <= #1980 1;  col <= #1980 1;
        row <= #1984 1;  col <= #1984 2;
        row <= #1988 1;  col <= #1988 3;
    end
endmodule