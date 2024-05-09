module Butterfly #(
    parameter   DATA_WIDTH = 16
) (
    input   wire                                          en, //clk, rst,
    input   wire    signed        [DATA_WIDTH-1:0]        in1_r, in1_i,
    input   wire    signed        [DATA_WIDTH-1:0]        in2_r, in2_i,
    output  wire    signed        [DATA_WIDTH-1:0]        sum_out_r, sum_out_i,
    output  wire    signed        [DATA_WIDTH-1:0]        diff_out_r, diff_out_i
);
//localparam  DATA_WIDTH= INTEGER_SIZE+FRACT_SIZE;
    assign sum_out_r = en? in1_r + in2_r:'b0;
    assign sum_out_i = en? in1_i + in2_i:'b0;
    assign diff_out_r = en? in1_r - in2_r:'b0;
    assign diff_out_i = en? in1_i - in2_i:'b0;

    /*always @(posedge clk or negedge rst) begin
        if(!rst) begin
            sum_out_r <= 'b0;
            sum_out_i <= 'b0;
            diff_out_r <= 'b0;
            diff_out_i <= 'b0;
        end
        else if(en) begin
            sum_out_r <= in1_r + in2_r; 
            sum_out_i <= in1_i + in2_i; 
            diff_out_r <= in1_r - in2_r; 
            diff_out_i <= in1_i - in2_i; 
        end
    end*/
endmodule