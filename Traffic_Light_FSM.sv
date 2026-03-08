module Traffic_Light_FSM (
    input logic clk,
    input logic reset,
    input logic TAORB,
    output logic [2:0] LA,
    output logic [2:0] LB
);

    typedef enum logic [1:0] {S0, S1, S2, S3} state_t;
    state_t current_state, next_state;
    logic [3:0] timer;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            timer <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == S1 || current_state == S3)
                timer <= timer + 1;
            else
                timer <= 0;
        end
    end

    always_comb begin
        case (current_state)
            S0: begin
                LA = 3'b001;
                LB = 3'b100;
                if (~TAORB) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                LA = 3'b010;
                LB = 3'b100;
                if (timer >= 5) next_state = S2;
                else next_state = S1;
            end
            S2: begin
                LA = 3'b100;
                LB = 3'b001;
                if (TAORB) next_state = S3;
                else next_state = S2;
            end
            S3: begin
                LA = 3'b100;
                LB = 3'b010;
                if (timer >= 5) next_state = S0;
                else next_state = S3;
            end
            default: next_state = S0;
        endcase
    end

endmodule