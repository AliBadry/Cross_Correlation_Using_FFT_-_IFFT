module Twiddle_Address_gen #(
    parameter   STAGE_NO = 1,
                NFFT = 128
) (
    input       wire                        clk, rst,
    input       wire                        Twiddle_active,
    output      reg [$clog2(NFFT/2)-1:0]    Twiddle_address
);
localparam  IDLE = 0,
            ADDRESS_GEN = 1;
reg [$clog2(NFFT):0] counter, counter_seq;

reg current_state, next_state;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        counter_seq <= 'b0;
        current_state <= IDLE;
    end
    else begin
        counter_seq <= counter;
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = IDLE;
    Twiddle_address = 'b0;
    counter = 'b0;
    case (current_state)
        IDLE:begin
            Twiddle_address = 'b0;
            counter = 'b0;
            if(Twiddle_active == 1'b1) begin
                next_state = ADDRESS_GEN;
            end
            else begin
                next_state = IDLE;
            end
        end
        ADDRESS_GEN: begin
            counter = counter_seq + 1'b1;
            if(STAGE_NO == $clog2(NFFT))
                Twiddle_address = 'b0;
            else if(counter_seq[$clog2(NFFT)-STAGE_NO] )
                Twiddle_address =  2**(STAGE_NO-1) * counter_seq[$clog2(NFFT)-STAGE_NO-1:0];
            else
                Twiddle_address = 'b0;

            if(counter_seq == NFFT-1)
                next_state = IDLE;
            else
                next_state = ADDRESS_GEN;
        end
    endcase
end
endmodule