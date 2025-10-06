module tb_systolic ();
    parameter SIZE = 3;
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 32;

    logic clk, reset, load_en, mult_en, acc_en;
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
endmodule
