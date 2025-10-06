module tb_mac ();
    reg clk;
    logic [7:0] a_in, b_in, a_out, b_out;
    logic load_en, mult_en, acc_en, reset;
    logic [31:0] acc_out;

    mac dut(.*);
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 0;
        acc_en = 1;
        #10;
        reset = 1;
        acc_en = 0;
        assert(dut.acc_out == 0);
        a_in = 5;
        b_in = 10;
        #5;
        load_en = 1;
        #5;
        assert(dut.a == 5 && dut.b == 10);
        mult_en = 1;
        load_en = 0;
        #10;
        assert(dut.x == 50);
        acc_en = 1;
        mult_en = 0;
        #10;
        assert(dut.acc_out == 50);
        acc_en = 0;
        #5;
        acc_en = 1;
        #5;
        assert(dut.acc_out == 100);
        $stop;
    end
endmodule
