vlog ./128_SDF_FFT/*.v
vlog ./128_SDF_IFFT/*.v
vlog *.v

vsim -voptargs=+acc work.xcorr_tb

add wave -position insertpoint sim:/xcorr_tb/DUT/FFT1/*
add wave -position insertpoint sim:/xcorr_tb/DUT/IFFT1/*
add wave -position insertpoint sim:/xcorr_tb/DUT/*


run -all