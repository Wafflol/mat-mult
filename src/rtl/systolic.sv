module systolic #(SIZE = 4) (
    input logic clk, reset, load_en, mult_en, acc_en,
    input logic [7:0] a_in [0:SIZE-1],
    input logic [7:0] b_in [0:SIZE-1],
    output logic [32-1:0] out [0:SIZE-1] [0:SIZE-1]
    );

    logic [7:0] a_out [0:SIZE-1] [0:SIZE-2];
    logic [7:0] b_out [0:SIZE-2] [0:SIZE-1];

    /*generate corners of the matrix*/
    mac topLeft(
        .a_in(a_in[0]),
        .b_in(b_in[0]),
        .a_out(a_out[0][0]),
        .b_out(b_out[0][0]),
        .acc_out(out[0][0]),
        .*
    );
    mac topRight(
        .a_in(a_out[0][SIZE-2]),
        .b_in(b_in[SIZE-1]),
        .a_out(),
        .b_out(b_out[0][SIZE-1]),
        .acc_out(out[0][SIZE-1]),
        .*
    );
    mac bottomLeft(
        .a_in(a_in[SIZE-1]),
        .b_in(b_out[SIZE-2][0]),
        .a_out(a_out[SIZE-1][0]),
        .b_out(),
        .acc_out(out[SIZE-1][0]),
        .*
    );
    mac bottomRight(
        .a_in(a_out[SIZE-2][SIZE-2]),
        .b_in(b_out[SIZE-2][SIZE-1]),
        .a_out(),
        .b_out(),
        .acc_out(out[SIZE-1][SIZE-1]),
        .*
    );

    genvar i,j, k, l;
    generate
        /* generate first and last row (excluding first MAC and last) */
        for (i = 1; i < SIZE-1; i = i + 1) begin : g_systolic_row
            mac row0MAC(
                .a_in(a_out[0][i-1]),
                .b_in(b_in[i]),
                .a_out(a_out[0][i]),
                .b_out(b_out[0][i]),
                .acc_out(out[0][i]),
                .*
            );
            mac rowLastMAC(
                .a_in(a_out[SIZE-1][i-1]),
                .b_in(b_out[SIZE-2][i]),
                .a_out(a_out[SIZE-1][i]),
                .b_out(),
                .acc_out(out[SIZE-1][i]),
                .*
            );
        end
        /* generate first and last column (excluding first and last instance of each)*/
        for (j = 1; j < SIZE-1; j = j + 1) begin : g_systolic_col
            mac col0MAC(
                .a_in(a_in[j]),
                .b_in(b_out[j-1][0]),
                .a_out(a_out[j][0]),
                .b_out(b_out[j][0]),
                .acc_out(out[j][0]),
                .*
            );
            mac colLastMAC(
                .a_in(a_out[j][SIZE-2]),
                .b_in(b_out[j-1][SIZE-1]),
                .a_out(),
                .b_out(b_out[j][SIZE-1]),
                .acc_out(out[j][SIZE-1]),
                .*
            );
        end

        /* generate everything in the center (not along the edges) */
        for (k = 1; k < SIZE - 1; k = k + 1) begin : g_center_row
            for (l = 1; l < SIZE - 1; l = l + 1) begin : g_center_col
                mac mainSystolic(
                    .a_in(a_out[k][l-1]),
                    .b_in(b_out[k-1][l]),
                    .a_out(a_out[k][l]),
                    .b_out(b_out[k][l]),
                    .acc_out(out[k][l]),
                    .*
                );
            end
        end
    endgenerate
endmodule
