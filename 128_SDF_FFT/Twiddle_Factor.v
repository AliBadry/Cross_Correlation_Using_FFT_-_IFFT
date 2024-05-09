module Twiddle_Factor 
#(parameter NFFT = 128, //-------------LOG2 (FFT points)--------------//
            DATA_WIDTH = 16
)
(
    input   wire     [$clog2(NFFT/2)-1:0]      address,
    output  wire     [DATA_WIDTH-1:0]          data_real, data_imag 
);

reg     [DATA_WIDTH-1:0]    ROM_imag    [NFFT/2 - 1:0];
reg     [DATA_WIDTH-1:0]    ROM_real    [NFFT/2 - 1:0];
initial
begin
    $readmemb("F:/Aloshka/Graduation Project/Digital/synch and coeff estimation/RTL/xcorrelation/128_SDF_FFT/Twiddle_factor_binary_real.txt",ROM_real);
    $readmemb("F:/Aloshka/Graduation Project/Digital/synch and coeff estimation/RTL/xcorrelation/128_SDF_FFT/Twiddle_factor_binary_imag.txt",ROM_imag);
end
 
assign data_real = ROM_real[address];
assign data_imag = ROM_imag[address];   

endmodule