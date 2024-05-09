module Top_FFT #(
    parameter   INTEGER_SIZE = 8,
                FRACT_SIZE = 8,
                NFFT = 128
) (
    input       wire                                             clk, rst,
    input       wire                                             start_FFT,
    input       wire    signed  [INTEGER_SIZE+FRACT_SIZE-1:0]    serial_in_r, serial_in_i,
    output      wire    signed  [INTEGER_SIZE+FRACT_SIZE-1:0]    serial_out_r, serial_out_i,
    output      wire                                             end_FFT, data_valid_FFT
);
localparam DATA_WIDTH = INTEGER_SIZE+FRACT_SIZE ;

genvar i;
wire    [$clog2(NFFT)-1:0]      start_stages;
wire    [DATA_WIDTH-1:0]        stage_n_in_r      [0:$clog2(NFFT)-2];
wire    [DATA_WIDTH-1:0]        stage_n_in_i      [0:$clog2(NFFT)-2];

generate
    for (i =0 ;i< $clog2(NFFT); i=i+1) begin :for_loop
        if(i==0) begin //for the first stage
            SDF_Stage #(
                .INTEGER_SIZE   (INTEGER_SIZE       ), 
                .FRACT_SIZE     (FRACT_SIZE         ), 
                .STAGE_NO       (i+1                ), 
                .NFFT           (NFFT               )
                ) ST1 (
                .clk            (clk                ),
                .rst            (rst                ),
                .start_conv     (start_stages[i]    ),
                .serial_in_r    (serial_in_r        ),
                .serial_in_i    (serial_in_i        ),
                .serial_out_r   (stage_n_in_r[i]    ),
                .serial_out_i   (stage_n_in_i[i]    )
            );
        end
        else if(i==$clog2(NFFT)-1) begin //for the last stage
            SDF_Stage #(
                .INTEGER_SIZE   (INTEGER_SIZE       ), 
                .FRACT_SIZE     (FRACT_SIZE         ), 
                .STAGE_NO       (i+1                ), 
                .NFFT           (NFFT               )
                ) ST3 (
                .clk            (clk                ),
                .rst            (rst                ),
                .start_conv     (start_stages[i]    ),
                .serial_in_r    (stage_n_in_r[i-1]  ),
                .serial_in_i    (stage_n_in_i[i-1]  ),
                .serial_out_r   (serial_out_r       ),
                .serial_out_i   (serial_out_i       )
            );
        end
        else begin //for the rest of the stages
            SDF_Stage #(
                .INTEGER_SIZE   (INTEGER_SIZE       ), 
                .FRACT_SIZE     (FRACT_SIZE         ), 
                .STAGE_NO       (i+1                ), 
                .NFFT           (NFFT               )
                ) ST2 (
                .clk            (clk                ),
                .rst            (rst                ),
                .start_conv     (start_stages[i]    ),
                .serial_in_r    (stage_n_in_r[i-1]  ),
                .serial_in_i    (stage_n_in_i[i-1]  ),
                .serial_out_r   (stage_n_in_r[i]    ),
                .serial_out_i   (stage_n_in_i[i]    )
            );
        end
    end
endgenerate
//------------without using the for-generate--------//
/*wire    [DATA_WIDTH-1:0]        stage2_in_r, stage2_in_i;
wire    [DATA_WIDTH-1:0]        stage3_in_r, stage3_in_i;
wire    [DATA_WIDTH-1:0]        stage4_in_r, stage4_in_i;
wire    [DATA_WIDTH-1:0]        stage5_in_r, stage5_in_i;
wire    [DATA_WIDTH-1:0]        stage6_in_r, stage6_in_i;
wire    [DATA_WIDTH-1:0]        stage7_in_r, stage7_in_i;

SDF_Stage #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .STAGE_NO(1), .NFFT(NFFT)) ST1 (
    .clk(clk),
    .rst(rst),
    .start_conv(start_stages[0]),
    .serial_in_r(serial_in_r),
    .serial_in_i(serial_in_i),
    .serial_out_r(stage2_in_r),
    .serial_out_i(stage2_in_i)
);

SDF_Stage #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .STAGE_NO(2), .NFFT(NFFT)) ST2 (
    .clk(clk),
    .rst(rst),
    .start_conv(start_stages[1]),
    .serial_in_r(stage2_in_r),
    .serial_in_i(stage2_in_i),
    .serial_out_r(stage3_in_r),
    .serial_out_i(stage3_in_i)
);

SDF_Stage #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .STAGE_NO(3), .NFFT(NFFT)) ST3 (
    .clk(clk),
    .rst(rst),
    .start_conv(start_stages[2]),
    .serial_in_r(stage3_in_r),
    .serial_in_i(stage3_in_i),
    .serial_out_r(stage4_in_r),
    .serial_out_i(stage4_in_i)
);

SDF_Stage #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .STAGE_NO(4), .NFFT(NFFT)) ST4 (
    .clk(clk),
    .rst(rst),
    .start_conv(start_stages[3]),
    .serial_in_r(stage4_in_r),
    .serial_in_i(stage4_in_i),
    .serial_out_r(stage5_in_r),
    .serial_out_i(stage5_in_i)
);

SDF_Stage #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .STAGE_NO(5), .NFFT(NFFT)) ST5 (
    .clk(clk),
    .rst(rst),
    .start_conv(start_stages[4]),
    .serial_in_r(stage5_in_r),
    .serial_in_i(stage5_in_i),
    .serial_out_r(stage6_in_r),
    .serial_out_i(stage6_in_i)
);

SDF_Stage #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .STAGE_NO(6), .NFFT(NFFT)) ST6 (
    .clk(clk),
    .rst(rst),
    .start_conv(start_stages[5]),
    .serial_in_r(stage6_in_r),
    .serial_in_i(stage6_in_i),
    .serial_out_r(stage7_in_r),
    .serial_out_i(stage7_in_i)
);

SDF_Stage #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .STAGE_NO(7), .NFFT(NFFT)) ST7 ( //change the stage number here
    .clk(clk),
    .rst(rst),
    .start_conv(start_stages[6]),
    .serial_in_r(stage7_in_r),
    .serial_in_i(stage7_in_i),
    .serial_out_r(serial_out_r),
    .serial_out_i(serial_out_i)
);*/

Top_controller #(.NFFT(NFFT)) TOP_CONT1 (
    .clk(clk),
    .rst(rst),
    .start_FFT(start_FFT),
    .start_stage(start_stages),
    .end_FFT(end_FFT),
    .data_valid(data_valid_FFT)
);
endmodule