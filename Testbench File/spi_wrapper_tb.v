module spi_wrapper_tb();

reg  clk, rst_n, SS_n, MOSI;
wire MISO;

spi_wrapper w1(clk, rst_n, SS_n, MOSI, MISO);

initial begin
	clk = 0;
	forever
	#10 clk = ~clk;
end

initial begin
	$readmemh("mem.dat", w1.r1.mem, 0, 255);
	rst_n = 0; SS_n  = 1; MOSI  = 0;
	@(negedge clk);
	rst_n = 1;

	//Check Write Address Case
	SS_n = 0;
	@(negedge clk);
	MOSI = 0; // Control bit which make the slave determine the operation(write in this case)
	@(negedge clk);
	MOSI = 0; @(negedge clk);
	MOSI = 0; @(negedge clk); // First two bits of input data which are din[9:8] that indicates to write address operation
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk);
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk);
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk);
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk); // The address which we will write over it is 8'b10101010
	SS_n = 1;

	@(negedge clk);

	//Check Write Data Case
	SS_n = 0;
	@(negedge clk);
	MOSI = 0; // Control bit which make the slave determine the operation(write in this case)
	@(negedge clk);
	MOSI = 0; @(negedge clk);
	MOSI = 1; @(negedge clk); // First two bits of input data which are din[9:8] that indicates to write data operation
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk);
    MOSI = 0; @(negedge clk);
    MOSI = 1; @(negedge clk);
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk);
	MOSI = 0; @(negedge clk);
	MOSI = 1; @(negedge clk); // The data which we will write in the previous write address is 8'b10011001
	SS_n = 1;

 	@(negedge clk);

 	//Check Read Address Case
	SS_n = 0;
	@(negedge clk);
	MOSI = 1; // Control bit which make the slave determine the operation(read in this case)
	@(negedge clk);
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk); // First two bits of input data which are din[9:8] that indicates to read address operation
	MOSI = 1; @(negedge clk);
	MOSI = 1; @(negedge clk);
	MOSI = 0; @(negedge clk); 
	MOSI = 1; @(negedge clk);
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); 
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk); // The address which we will read from is 8'b11011011
	SS_n = 1;

	@(negedge clk);

	//Check Read Data Case
	SS_n = 0;
	@(negedge clk);
	MOSI = 1; // Control bit which make the slave determine the operation(read in this case)
	@(negedge clk);
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk); // First two bits of input data which are din[9:8] that indicates to read data operation
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); 
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk);
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk); // Input bits in this case which are 8'b10111111 are ignored
	repeat(8) begin
    	@(negedge clk);
    end
	SS_n = 1;

	@(negedge clk);

	//Check Read Address Case
	SS_n = 0;
	@(negedge clk);
	MOSI = 1; // Control bit which make the slave determine the operation(read in this case)
	@(negedge clk);
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); // First two bits of input data which are din[9:8] that indicates to read address operation
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); 
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk);
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); 
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); // The address which we will read from is 8'b10101010
	SS_n = 1;

	@(negedge clk);

	//Check Read Data Case
	SS_n = 0;
	@(negedge clk);
	MOSI = 1; // Control bit which make the slave determine the operation(read in this case)
	@(negedge clk);
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk); // First two bits of input data which are din[9:8] that indicates to read data operation
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); 
	MOSI = 1; @(negedge clk); 
	MOSI = 1; @(negedge clk);
	MOSI = 1; @(negedge clk); 
	MOSI = 0; @(negedge clk); 
	MOSI = 1; @(negedge clk); MOSI = 1; @(negedge clk); // Input bits in this case which are 8'b10111011 are ignored
	repeat(8) begin
    	@(negedge clk);
    end
	SS_n = 1;

	@(negedge clk);

	$stop;
end

endmodule