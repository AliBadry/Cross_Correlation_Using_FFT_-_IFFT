//`include "F:/Aloshka/Graduation Project/Digital/synch and coeff estimation/RTL/xcorrelation/128_SDF_FFT/Top_FFT.v"
//`include "F:/Aloshka/Graduation Project/Digital/synch and coeff estimation/RTL/xcorrelation/128_SDF_IFFT/Top_IFFT.v"

module xcorr #(
    parameter   INTEGER_SIZE = 16,
                FRACT_SIZE = 16,
                NFFT = 128
) (
    input   wire                                                clk, rst,
    input   wire                                                start_FFT,
    input   wire    signed  [INTEGER_SIZE+FRACT_SIZE-1:0]     serial_in1_r, serial_in1_i,
    input   wire    signed  [INTEGER_SIZE+FRACT_SIZE-1:0]     serial_in2_r, serial_in2_i,
    output  wire    signed  [INTEGER_SIZE+FRACT_SIZE-1:0]     serial_out_r, serial_out_i,
    output  wire                                                end_FFT, end_IFFT,
    output  wire                                                data_valid_FFT, data_valid_IFFT
);
localparam DATA_WIDTH = INTEGER_SIZE+FRACT_SIZE;

wire    signed     [DATA_WIDTH-1:0]    serial_FFT_out1_r, serial_FFT_out1_i;
wire    signed     [DATA_WIDTH-1:0]    serial_FFT_out2_r, serial_FFT_out2_i;
wire    signed     [DATA_WIDTH-1:0]    conj_out_r, conj_out_i;
wire    signed     [DATA_WIDTH-1:0]    serial_IFFT_in_r, serial_IFFT_in_i;
wire               [1:0]                end_FFT_D;
wire                                    end_FFT2, data_valid_FFT2;

// FFT1 is for the PA output .
// FFT2 is for the PA input .

Top_FFT #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .NFFT(NFFT)) FFT1 (
    .clk(clk),
    .rst(rst),
    .start_FFT(start_FFT),
    .serial_in_r(serial_in1_r),
    .serial_in_i(serial_in1_i),
    .serial_out_r(serial_FFT_out1_r),
    .serial_out_i(serial_FFT_out1_i),
    .end_FFT(end_FFT),
    .data_valid_FFT(data_valid_FFT)
);

Top_FFT #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .NFFT(NFFT)) FFT2 (
    .clk(clk),
    .rst(rst),
    .start_FFT(start_FFT),
    .serial_in_r(serial_in2_r),
    .serial_in_i(serial_in2_i),
    .serial_out_r(serial_FFT_out2_r),
    .serial_out_i(serial_FFT_out2_i),
    .end_FFT(end_FFT2),
    .data_valid_FFT(data_valid_FFT2)
);

Complex_conjugate #(.DATA_WIDTH(DATA_WIDTH)) CONJ1 (
    //.clk(clk),
    //.rst(rst),
    .data_in_r(serial_FFT_out2_r),
    .data_in_i(serial_FFT_out2_i),
    .data_out_r(conj_out_r),
    .data_out_i(conj_out_i)
);

Complex_Multiplier #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE)) MULT_CONJ (
    .clk(clk),
    .rst(rst),
    .in1_r(serial_FFT_out1_r),
    .in1_i(serial_FFT_out1_i),
    .in2_r(conj_out_r),
    .in2_i(conj_out_i),
    .out_r(serial_IFFT_in_r),
    .out_i(serial_IFFT_in_i)
);

delay_unit #(.DATA_WIDTH(1)) D1_endFFT (
    .clk(clk),
    .reset(rst),
    .in_data(end_FFT2),
    .out_data(end_FFT_D[0])
);

delay_unit #(.DATA_WIDTH(1)) D2_endFFT (
    .clk(clk),
    .reset(rst),
    .in_data(end_FFT_D[0]),
    .out_data(end_FFT_D[1])
);
    
Top_IFFT #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .NFFT(NFFT)) IFFT1 (
    .clk(clk),
    .rst(rst),
    .start_FFT(end_FFT_D[1]),
    .serial_in_r(serial_IFFT_in_r),
    .serial_in_i(serial_IFFT_in_i),
    .serial_out_r(serial_out_r),
    .serial_out_i(serial_out_i),
    .end_FFT(end_IFFT),
    .data_valid_IFFT(data_valid_IFFT)
);
endmodule