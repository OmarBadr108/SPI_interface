module SPI_Wrapper (MOSI,MISO,SS_n,clk,rst_n);
input MOSI,SS_n,rst_n,clk;
output MISO;

wire [9:0] din;
wire [7:0] tx_data;
wire rx_valid,tx_valid;
wire [7:0] dout;
wire [9:0] rx_data;

SPI_SLAVE dut0(MISO,MOSI,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
sync_ram  dut1(din,dout,rx_valid,tx_valid,clk,rst_n);


assign tx_data = dout;
assign din = rx_data;

endmodule 