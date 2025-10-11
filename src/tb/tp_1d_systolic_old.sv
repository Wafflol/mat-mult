module tp_1d_systolic_old ();
    parameter SIZE = 2;
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 32;

    logic clk, reset, err;
    logic [IN_WIDTH-1:0] a_in [SIZE];
    logic valid_a [SIZE];
    logic [IN_WIDTH-1:0] b_in [SIZE];
    logic valid_b [SIZE];
    logic [OUT_WIDTH-1:0] out [SIZE][SIZE];

    systolic #(.SIZE(SIZE)) dut (.*);

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
        input logic [OUT_WIDTH] expected_out [SIZE][SIZE];
    begin
        if (dut.out !== expected_out) begin
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

    /* test multiplying two 2x2 matrices */
    /*  a       b       c
    * [1 2] * [1 2] = [9 12]
    *         [4 5]
    *
    * rows:
    * a1: 1, 2
    * a2: 0, 0
    * b1: 1, 4
    * b2: 0, 2, 5
    */
    initial begin
        reset = 0;
        valid_a = '{default: 0};
        valid_b = '{default: 0};
        #10;
        my_checker('{'{0, 0}, '{0, 0}});

        reset = 1;
        valid_a = '{1, 0};
        valid_b = '{1, 0};
        a_in = '{1, 0};
        b_in = '{1, 0};
        #10;

        valid_b = '{1, 0};
        a_in = '{2, 0};
        b_in = '{4, 0};
        #10;

        valid_a = '{0, 0};
        valid_b = '{0, 0};
        a_in = '{0, 0};
        b_in = '{0, 0};
        #10;

        //data reaches 2nd mac
        valid_b = '{0, 1};
        b_in = '{0, 2};
        my_checker('{'{1, 0}, '{0, 0}});
        #10;


        b_in = '{0, 5};
        my_checker('{'{9, 0}, '{0, 0}});
        #10;

        valid_b = '{0, 0};
        b_in = '{0, 0};
        my_checker('{'{9, 0}, '{0, 0}});
        #10;

        my_checker('{'{9, 2}, '{0, 0}});
        #10;

        my_checker('{'{9, 12}, '{0, 0}});
        #10;

        #30;
        $stop;
    end
endmodule
