vlog *.v
vsim -voptargs=+acc work.Top_FFT_tb
add wave -position insertpoint sim:/Top_FFT_tb/*

#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST1/*
#------------stage 1 debugging ------------------#
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST1/CU1/*
#
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST1/MS1/*
#
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST1/MUX1/*
#
#add wave -position insertpoint  \
#sim:/Top_FFT_tb/DUT/ST1/MS1/out_data_r
#
#add wave -position insertpoint  \
#sim:/Top_FFT_tb/DUT/ST1/MS1/out_data_i

#------------------------------------------------#
#------------stage 2 debugging ------------------#
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST2/CU1/*
#
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST2/MS1/*
#
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST2/MUX1/*
#
#add wave -position insertpoint  \
#sim:/Top_FFT_tb/DUT/ST2/MS1/out_data_r
#
#add wave -position insertpoint  \
#sim:/Top_FFT_tb/DUT/ST2/MS1/out_data_i
#------------------------------------------------#

#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST2/*
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST3/*
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST4/*
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST5/*
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST6/*
#add wave -position insertpoint sim:/Top_FFT_tb/DUT/ST7/*
add wave -position insertpoint sim:/Top_FFT_tb/DUT/TOP_CONT1/*


run -all