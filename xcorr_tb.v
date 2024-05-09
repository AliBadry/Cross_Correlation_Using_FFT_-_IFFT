`timescale 1ns/1ps
module xcorr_tb #(
    parameter   INTEGER_SIZE = 16,
                FRACT_SIZE = 16,
                NFFT = 128
) ();
localparam  HALF_CYCLE = 5,
            CLK_CYLCE = 2*HALF_CYCLE,
            DATA_WIDTH = INTEGER_SIZE+FRACT_SIZE ;
reg                                 clk_tb, rst_tb;
reg                                 start_FFT_tb;
reg     signed  [DATA_WIDTH-1:0]    serial_in1_r_tb, serial_in1_i_tb;
reg     signed  [DATA_WIDTH-1:0]    serial_in2_r_tb, serial_in2_i_tb;
wire    signed  [DATA_WIDTH-1:0]    serial_out_r_tb, serial_out_i_tb;
wire                                end_IFFT_tb, end_FFT_tb, data_valid_FFT_tb, data_valid_IFFT_tb;

integer i1, i2;

//===============clock driver==============//

initial begin
    clk_tb = 1'b1;
    forever begin
        #HALF_CYCLE clk_tb = !clk_tb;
    end
end

//===============reset driver==============//

initial begin
    rst_tb = 1'b0;
    #(CLK_CYLCE*2) rst_tb = 1'b1;
end

//===============reading the serial input data==============//

reg [DATA_WIDTH-1:0] PA_in_r [0:NFFT-1] ;
reg [DATA_WIDTH-1:0] PA_in_i [0:NFFT-1] ;
reg [DATA_WIDTH-1:0] PA_out_r [0:NFFT-1] ;
reg [DATA_WIDTH-1:0] PA_out_i [0:NFFT-1] ;
initial begin
        $readmemh("FFT_pa_in_hex_real.txt",PA_in_r);
        $readmemh("FFT_pa_in_hex_imag.txt",PA_in_i);
        $readmemh("FFT_pa_out_hex_real.txt",PA_out_r);
        $readmemh("FFT_pa_out_hex_imag.txt",PA_out_i);
end

//===============writing the output external file ==============//

integer fileID1, fileID2;
initial begin
    fileID1 = $fopen("xcorr_out_r.txt","w");
    fileID2 = $fopen("xcorr_out_i.txt","w");
end
//===============main driver==============//

initial begin
    //--------initializing the input ports---------//
    start_FFT_tb = 1'b0;
    serial_in1_r_tb = 1'b0;
    serial_in1_i_tb = 1'b0;
    serial_in2_r_tb = 1'b0;
    serial_in2_i_tb = 1'b0;
    //----------starting the operation------//
    #(CLK_CYLCE+1)
    /*#(CLK_CYLCE*2+1)*/@(posedge clk_tb) start_FFT_tb = 1'b1;
    //-------injecting the input------------//
    for (i1=0 ;i1<NFFT ;i1=i1+1 ) begin
        serial_in1_r_tb = PA_out_r[i1];
        serial_in1_i_tb = PA_out_i[i1];
        serial_in2_r_tb = PA_in_r[i1];
        serial_in2_i_tb = PA_in_i[i1];
        /*#(CLK_CYLCE)*/@(posedge clk_tb) if(start_FFT_tb)    start_FFT_tb = 1'b0;
        //---------saving the output of the first stage--------//
        /*if(i1>=NFFT/2)
        begin
            $fwrite(fileID1,"%h\n",DUT.stage2_in_r);
            $fwrite(fileID2,"%h\n",DUT.stage2_in_i);
        end*/
    end
    serial_in1_r_tb = 1'b0;
    serial_in1_i_tb = 1'b0;
    serial_in2_r_tb = 1'b0;
    serial_in2_i_tb = 1'b0;

    for(i2=0; i2<=NFFT*2; i2=i2+1) begin
        if(end_IFFT_tb) begin
            for (i1=0 ; i1<NFFT;i1=i1+1 ) begin
                if(i1==NFFT-1) begin
                    $fwrite(fileID1,"%h",serial_out_r_tb);
                    $fwrite(fileID2,"%h",serial_out_i_tb);
                end
                else begin
                    $fwrite(fileID1,"%h\n",serial_out_r_tb);
                    $fwrite(fileID2,"%h\n",serial_out_i_tb);
                    #(CLK_CYLCE);
                end
            end
        end
        else begin
            #(CLK_CYLCE);
        end
    end

        $fclose(fileID1);
        $fclose(fileID2);
$stop;
end

//===============DUT instantiation==============//
xcorr #(.INTEGER_SIZE(INTEGER_SIZE), .FRACT_SIZE(FRACT_SIZE), .NFFT(NFFT)) DUT (
    .clk(clk_tb),
    .rst(rst_tb),
    .start_FFT(start_FFT_tb),
    .serial_in1_r(serial_in1_r_tb),
    .serial_in1_i(serial_in1_i_tb),
    .serial_in2_r(serial_in2_r_tb),
    .serial_in2_i(serial_in2_i_tb),
    .serial_out_r(serial_out_r_tb),
    .serial_out_i(serial_out_i_tb),
    .end_FFT(end_FFT_tb),
    .end_IFFT(end_IFFT_tb),
    .data_valid_FFT(data_valid_FFT_tb), 
    .data_valid_IFFT(data_valid_IFFT_tb)
);
endmodule