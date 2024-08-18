module sp_async_ram(clk, rst_n, rx_valid, tx_valid, din, dout);

parameter MEM_DEPTH = 256;  parameter ADDR_SIZE = 8;

input  clk, rst_n, rx_valid;
input  [9:0]din;
output reg tx_valid;
output reg [7:0]dout;

reg [7:0] mem [MEM_DEPTH-1:0];

reg  [ADDR_SIZE-1:0]addr_wr;
reg  [ADDR_SIZE-1:0]addr_rd;

always @(posedge clk) begin
	
	if (~rst_n) begin
		addr_wr <= 0; addr_rd <= 0;
		tx_valid <= 1'b0;
		dout     <= 0;
	end
	else begin
		if(rx_valid == 1) begin
			if(din[9:8] == 2'b00) begin
				tx_valid <= 0;
				addr_wr <= din[7:0];
			end
			else if(din[9:8] == 2'b01) begin
				tx_valid <= 0;
				mem[addr_wr] <= din[7:0];
			end
			else if(din[9:8] == 2'b10) begin
				tx_valid <= 0;
				addr_rd <= din[7:0];
			end
			else begin
				tx_valid <= 1'b1;
				dout <= mem[addr_rd];
			end
		end
	
	end

end

endmodule