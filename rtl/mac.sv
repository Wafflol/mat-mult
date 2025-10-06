module mac #(
    parameter WIDTH = 8
) (
    input logic [WIDTH-1 : 0] a_in, b_in,
    input logic load_en, mult_en, acc_en, reset, clk,
    output logic [WIDTH-1 : 0] a_out, b_out,
    output logic [WIDTH*4-1 : 0] acc_out
);

    logic [WIDTH*2-1 : 0] x;
    logic [WIDTH-1 : 0] a, b;

    always_ff @(posedge clk) begin : ab_regs
        if (load_en) begin
            a <= a_in;
            b <= b_in;
        end
    end

    always_ff @(posedge clk) begin : multiplier
        if (mult_en) begin
            x <= a * b;
        end
    end

    always_ff @(posedge clk) begin : accum
        if (~reset)
            acc_out <= '0;
        else if (acc_en)
            acc_out <= acc_out + x;
    end
endmodule
