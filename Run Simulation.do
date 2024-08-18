vlib work
vlog sp_async_ram.v spi_slave.v spi_wrapper.v spi_wrapper_tb.v
vsim -voptargs=+acc work.spi_wrapper_tb
add wave *

add wave -position insertpoint sim:/spi_wrapper_tb/w1/r1/rx_valid 

add wave -position insertpoint sim:/spi_wrapper_tb/w1/r1/din 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/r1/tx_valid 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/r1/dout
add wave -position insertpoint sim:/spi_wrapper_tb/w1/r1/mem 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/r1/addr_wr  
add wave -position insertpoint sim:/spi_wrapper_tb/w1/r1/addr_rd 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/s1/rx_data 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/s1/tx_data 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/s1/count 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/s1/cs 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/s1/ns 
add wave -position insertpoint sim:/spi_wrapper_tb/w1/s1/read_add

run -all
#quit -sim