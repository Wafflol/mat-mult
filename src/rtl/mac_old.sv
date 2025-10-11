module mac_old #(
    parameter WIDTH = 8
) (
    input logic [WIDTH-1 : 0] a_in, b_in,
    input logic valid_a, valid_b, reset, clk,
    output logic [WIDTH-1 : 0] a_out, b_out,
    output logic [WIDTH*4-1 : 0] acc_out,
    output logic valid_a_out, valid_b_out
);

    logic [WIDTH*2-1 : 0] x;
    logic [WIDTH-1 : 0] a, b, a_next, b_next;
    logic valid_a_0, valid_a_1;
    logic valid_b_0, valid_b_1;

    always_ff @(posedge clk) begin : valid_shift_reg
        if (~reset) begin
            valid_a_0   <= 0;
            valid_a_1   <= 0;
            valid_a_out <= 0;

            valid_b_0   <= 0;
            valid_b_1   <= 0;
            valid_b_out <= 0;
        end
        else begin
            valid_a_0   <= valid_a;
            valid_a_1   <= valid_a_0;
            valid_a_out <= valid_a_1;
            a_next      <= a;
            a_out       <= a_next;

            valid_b_0   <= valid_b;
            valid_b_1   <= valid_b_0;
            valid_b_out <= valid_b_1;
            b_next      <= b;
            b_out       <= b_next;
        end
    end

    always_ff @(posedge clk) begin : pipeline
        if (~reset) begin
            a <= 0;
            b <= 0;
            x <= 0;
            acc_out <= 0;
        end
        else begin
            if (valid_a && valid_b) begin
                a <= a_in;
                b <= b_in;
            end

            if (valid_a_0 && valid_b_0)
                x <= a * b;

            if (valid_a_1 && valid_b_1)
                acc_out <= acc_out + x;
        end
    end
endmodule
