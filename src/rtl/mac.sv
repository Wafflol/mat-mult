module mac #(
    parameter WIDTH = 8
) (
    input logic [WIDTH-1 : 0] a_in, b_in,
    input logic valid_a, valid_b, reset, clk,
    output logic [WIDTH-1 : 0] a_out, b_out,
    output logic [WIDTH*4-1 : 0] acc_out,
    output logic valid_a_out, valid_b_out
);

    logic [WIDTH*2-1 : 0] x;

    always_comb begin : multiply
        x = a_in * b_in;
    end

    always_ff @(posedge clk) begin : valid_reg
        if (~reset) begin
            valid_a_out <= 0;
            valid_b_out <= 0;
        end
        else begin
            valid_a_out <= valid_a;
            valid_b_out <= valid_b;
        end
    end

    always_ff @(posedge clk) begin : accumulator
        if (~reset) begin
            a_out   <= 0;
            b_out   <= 0;
            acc_out <= 0;
        end
        else begin
            if (valid_a && valid_b) begin
                a_out <= a_in;
                b_out <= b_in;
            end
            if (valid_a && valid_b)
                acc_out <= acc_out + x;
        end
    end
endmodule
