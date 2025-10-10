module tb_mac ();
    reg clk;
    logic [7:0] a_in, b_in, a_out, b_out;
    logic valid_a, valid_b, valid_a_out, valid_b_out, reset;
    logic [31:0] acc_out;

    mac dut(.*);
    initial clk = 0;
    always #5 clk = ~clk;

    /* simple assert tb since theres not much to test */
    initial begin
        reset = 0;
        valid_a = 0;
        valid_b = 0;
        #10;
        assert(dut.acc_out == 0);
        reset = 1;
        a_in = 1;
        b_in = 1;
        valid_a = 1;
        valid_b = 1;
        #10;
        assert(dut.a == 1 && dut.b == 1);
        a_in = 2;
        b_in = 4;
        #10;
        assert(dut.a == 2 && dut.b == 4);
        assert(dut.x == 1);
        a_in = 3;
        b_in = 7;
        #10;
        valid_a = 0;
        valid_b = 0;
        assert(dut.a == 3 && dut.b == 7);
        assert(dut.x == 8)
        assert(dut.acc_out == 1);
        #50;
        $stop;
    end
endmodule
