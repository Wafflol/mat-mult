module tb_systolic ();
    parameter SIZE = 3;
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 32;

    logic clk, reset, load_en, mult_en, acc_en, err;
    logic [IN_WIDTH-1:0] a_in [0:SIZE-1];
    logic [IN_WIDTH-1:0] b_in [0:SIZE-1];
    logic [OUT_WIDTH-1:0] out [0:SIZE-1][0:SIZE-1];

    systolic #(
            .SIZE(SIZE)
        ) dut (
            .clk(clk),
            .reset(reset),
            .load_en(load_en),
            .mult_en(mult_en),
            .acc_en(acc_en),
            .a_in(a_in),
            .b_in(b_in),
            .out(out)
    );

    logic test [SIZE][SIZE] = '{'{1, 2, 3}, '{4, 5, 6}, '{7, 8, 9}};

    function static void printMat (logic [OUT_WIDTH-1:0] x [SIZE] [SIZE]);
        for (int i = 0; i < SIZE; i++) begin
            $write("[");
            for (int j = 0; j < SIZE-1; j++) begin
                $write("%0d, ", x[i][j]);
            end
            $display("%0d]", x[i][SIZE-1]);
        end
    endfunction

    task static my_checker;
        input logic [OUT_WIDTH] expected_out [0:SIZE-1][0:SIZE-1];
    begin
        if (dut.out !== expected_out)
            begin
                $display("expected output: ");
                printMat(expected_out);
                $display("actual output: ");
                printMat(dut.out);
                err = 1'b1;
            end
        end
    endtask

    initial clk = 0;
    always #5 clk = ~clk;

    /* test multiplying two 3x3 matrices */
    /*   a         b            c
    * [1 2 3]   [1 2 3]   [30  36  42 ]
    * [4 5 6] * [4 5 6] = [66  81  96 ]
    * [7 8 9]   [7 8 9]   [102 126 150]
    *
    * rows:
    * a1: 1, 2, 3
    * a2:    4, 5, 6
    * a3:       7, 8, 9
    * b1: 1, 4, 7
    * b2:    2, 5, 8
    * b3:       3, 6, 9
    */
    initial begin
        reset = 0;
        acc_en = 0;
        mult_en = 0;
        load_en = 0;
        #10;
        my_checker('{'{0, 0, 0}, '{0, 0, 0}, '{0, 0, 0}});

        reset = 1;
        acc_en = 1;
        mult_en = 1;
        load_en = 1;
        a_in = '{1, 0, 0};
        b_in = '{1, 0, 0};
        #30;
        my_checker('{'{1, 0, 0}, '{0, 0, 0}, '{0, 0, 0}});

        a_in = '{2, 4, 0};
        b_in = '{4, 2, 0};
        #30;

        a_in = '{3, 5, 7};
        b_in = '{7, 5, 3};
        #30;

        a_in = '{0, 6, 8};
        b_in = '{0, 8, 6};
        #30;

        a_in = '{0, 0, 9};
        b_in = '{0, 0, 9};
        #30;

        acc_en = 0;
        mult_en = 0;
        load_en = 0;
        #60;

        $stop;
    end
endmodule
