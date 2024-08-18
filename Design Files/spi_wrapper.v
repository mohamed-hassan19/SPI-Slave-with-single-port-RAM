module spi_wrapper(clk, rst_n, SS_n, MOSI, MISO);

input  clk, rst_n, SS_n, MOSI;
output MISO;

wire rx_valid, tx_valid;
wire [9:0]rx_data;
wire [7:0]tx_data;

sp_async_ram r1(clk, rst_n, rx_valid, tx_valid, rx_data, tx_data);
spi_slave s1(clk, rst_n, SS_n, MOSI, MISO, rx_valid, rx_data, tx_valid, tx_data);

endmodule