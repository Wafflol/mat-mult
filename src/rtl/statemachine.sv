module statemachine #(
    SIZE  = 4,
    WIDTH = 16
) (
    input logic clk,
    reset,
    start,
    input logic [2:0] a_width,
    b_width,
    input logic [8:0] k_length,
    output logic led_done,
    output logic [WIDTH-1:0] a_in[SIZE],
    output logic [WIDTH-1:0] b_in[SIZE],
    output logic valid_a[SIZE],
    output logic valid_b[SIZE],
    output logic [2:0] ram_a1_addr_a,
    ram_a1_addr_b,
    ram_a2_addr_a,
    ram_a2_addr_b,
    ram_b1_addr_a,
    ram_b1_addr_b,
    ram_b2_addr_a,
    ram_b2_addr_b,
    output logic [WIDTH-1:0] ram_a1_data_a,
    ram_a1_data_b,
    ram_a2_data_a,
    ram_a2_data_b,
    ram_b1_data_a,
    ram_b1_data_b,
    ram_b2_data_a,
    ram_b2_data_b,
    output logic ram_a1_wren_a,
    ram_a1_wren_b,
    ram_a2_wren_a,
    ram_a2_wren_b,
    ram_b1_wren_a,
    ram_b1_wren_b,
    ram_b2_wren_a,
    ram_b2_wren_b,
    input logic [WIDTH-1:0] ram_a1_q_a,
    ram_a1_q_b,
    ram_a2_q_a,
    ram_a2_q_b,
    ram_b1_q_a,
    ram_b1_q_b,
    ram_b2_q_a,
    ram_b2_q_b
);
    localparam DEPTH = 8;

    logic [2:0] state;
    logic [8:0] cycle;
    logic [2:0] m, n;
    logic [3:0] k;

    parameter IDLE = 3'b000, SET_K = 3'b001, LOAD_1 = 3'b010, COMPUTE = 3'b011, DONE = 3'b100;

    logic [2:0] m_c, n_c;
    logic [3:0] k_c;

    always_comb begin
        m_c = (a_width > SIZE) ? SIZE[2:0] : a_width;
        n_c = (b_width > SIZE) ? SIZE[2:0] : b_width;
        k_c = (k_length > DEPTH) ? DEPTH[3:0] : k_length[3:0];
    end

    logic [8:0] last_cycle;
    always_comb begin
        last_cycle = m + n + k - 9'd3;
    end

    logic feeding;
    logic [8:0] nf;

    always_comb begin
        feeding = (state == LOAD_1) || (state == COMPUTE);
        nf      = (state == LOAD_1) ? 9'd0 : cycle + 9'd1;
    end

    logic [2:0] a_addr    [4];
    logic [2:0] b_addr    [4];
    logic       a_vld_next[4];
    logic       b_vld_next[4];

    always_comb begin
        int ea, eb;
        for (int i = 0; i < 4; i++) begin
            ea = int'(nf) - i;
            eb = int'(nf) - i;
            a_vld_next[i] = feeding && (i < SIZE) && (i < int'(m)) && (ea >= 0) && (ea < int'(k));
            b_vld_next[i] = feeding && (i < SIZE) && (i < int'(n)) && (eb >= 0) && (eb < int'(k));
            a_addr[i] = a_vld_next[i] ? ea[2:0] : 3'd0;
            b_addr[i] = b_vld_next[i] ? eb[2:0] : 3'd0;
        end
    end

    assign ram_a1_addr_a = a_addr[0];
    assign ram_a1_addr_b = a_addr[1];
    assign ram_a2_addr_a = a_addr[2];
    assign ram_a2_addr_b = a_addr[3];
    assign ram_b1_addr_a = b_addr[0];
    assign ram_b1_addr_b = b_addr[1];
    assign ram_b2_addr_a = b_addr[2];
    assign ram_b2_addr_b = b_addr[3];
    assign ram_a1_data_a = '0;
    assign ram_a1_data_b = '0;
    assign ram_a2_data_a = '0;
    assign ram_a2_data_b = '0;
    assign ram_b1_data_a = '0;
    assign ram_b1_data_b = '0;
    assign ram_b2_data_a = '0;
    assign ram_b2_data_b = '0;
    assign ram_a1_wren_a = 1'b0;
    assign ram_a1_wren_b = 1'b0;
    assign ram_a2_wren_a = 1'b0;
    assign ram_a2_wren_b = 1'b0;
    assign ram_b1_wren_a = 1'b0;
    assign ram_b1_wren_b = 1'b0;
    assign ram_b2_wren_a = 1'b0;
    assign ram_b2_wren_b = 1'b0;

    logic [WIDTH-1:0] a_q[4];
    logic [WIDTH-1:0] b_q[4];
    always_comb begin
        a_q[0] = ram_a1_q_a;
        a_q[1] = ram_a1_q_b;
        a_q[2] = ram_a2_q_a;
        a_q[3] = ram_a2_q_b;
        b_q[0] = ram_b1_q_a;
        b_q[1] = ram_b1_q_b;
        b_q[2] = ram_b2_q_a;
        b_q[3] = ram_b2_q_b;
        for (int i = 0; i < SIZE; i++) begin
            a_in[i] = valid_a[i] ? a_q[i] : '0;
            b_in[i] = valid_b[i] ? b_q[i] : '0;
        end
    end

    assign led_done = (state == DONE);

    always_ff @(posedge clk) begin
        if (~reset) begin
            state <= IDLE;
            cycle <= '0;
            m     <= '0;
            n     <= '0;
            k     <= '0;
            for (int i = 0; i < SIZE; i++) begin
                valid_a[i] <= 1'b0;
                valid_b[i] <= 1'b0;
            end
        end else begin
            for (int i = 0; i < SIZE; i++) begin
                valid_a[i] <= a_vld_next[i];
                valid_b[i] <= b_vld_next[i];
            end

            case (state)
                IDLE: begin
                    if (start) state <= SET_K;
                end
                SET_K: begin
                    m     <= m_c;
                    n     <= n_c;
                    k     <= k_c;
                    cycle <= '0;
                    state <= (m_c == 0 || n_c == 0 || k_c == 0) ? DONE : LOAD_1;
                end
                LOAD_1: begin
                    cycle <= '0;
                    state <= COMPUTE;
                end
                COMPUTE: begin
                    if (cycle == last_cycle) state <= DONE;
                    else cycle <= cycle + 9'd1;
                end
                DONE: begin
                    state <= DONE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
