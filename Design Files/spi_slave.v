module spi_slave(clk, rst_n, SS_n, MOSI, MISO, rx_valid, rx_data, tx_valid, tx_data);

parameter IDLE = 3'b000; parameter CHK_CMD = 3'b001; parameter WRITE = 3'b010; parameter READ_ADD = 3'b011; parameter READ_DATA = 3'b100;

input  clk, rst_n, SS_n, MOSI, tx_valid;
input  [7:0]tx_data;
output reg MISO, rx_valid;
output reg [9:0]rx_data;

//(*fsm_encoding = "gray"*)
(*fsm_encoding = "one_hot"*)
//(*fsm_encoding = "sequential"*)
reg [2:0]cs, ns;
reg read_add; //if High, read address has already been received.
reg [3:0]count;
//Next State Logic

always @(*) begin
	case(cs)
	IDLE: begin
		if(SS_n) begin
			ns = IDLE;
		end
		else begin
			ns = CHK_CMD;
		end
	end
	CHK_CMD: begin
		if(SS_n) begin
			ns = IDLE;
		end
		else begin
			if(MOSI) begin
				if(read_add) begin
					ns = READ_DATA;
				end
				else begin
					ns = READ_ADD;
				end
			end
			else begin
				ns = WRITE;
			end
		end
	end
	WRITE: begin
		if(SS_n) begin
			ns = IDLE;
		end
		else begin
			ns = WRITE;
		end
	end
	READ_ADD: begin
		if(SS_n) begin
			ns = IDLE;
		end
		else begin
			ns = READ_ADD;
		end
	end
	READ_DATA: begin
		if(SS_n) begin
			ns = IDLE;
		end
		else begin
			ns = READ_DATA;
		end
	end
	default: ns = IDLE;

	endcase

end

//State Memory

always @(posedge clk) begin
	if(~rst_n) begin
		cs <= IDLE;
	end
	else begin
		cs <= ns;
	end
end

//Output Logic

always @(posedge clk) begin
	if(~rst_n) begin
		rx_valid <= 0; rx_data <= 0;
		MISO <= 0; read_add <= 0;
	end
	else begin
		if((cs == IDLE) || (cs == CHK_CMD)) begin
			MISO <= 0; rx_valid <= 0; count <= 0;
		end
		else if(cs == WRITE) begin
			if(count < 10) begin
				rx_data <= {rx_data[8:0], MOSI}; rx_valid <= 0; count <= count + 1;
			end
			if(count == 10) begin
				rx_valid <= 1;
			end
		end
		else if(cs == READ_ADD) begin
			if(count < 10) begin
				rx_data <= {rx_data[8:0], MOSI}; rx_valid <= 0; count <= count + 1;
			end
			if(count == 10) begin
				rx_valid <= 1; read_add <= 1;
			end
		end
		else begin
			if(tx_valid == 0) begin
				if(count < 10) begin
					rx_data <= {rx_data[8:0], MOSI}; rx_valid <= 0; count <= count + 1;
				end
				if(count == 10) begin
					rx_valid <= 1; read_add <= 0;
				end
			end
			else begin
				if(count >= 3) begin
					MISO <= tx_data[count - 3];
					count <= count - 1;
				end
			end
		end
	end

end

endmodule