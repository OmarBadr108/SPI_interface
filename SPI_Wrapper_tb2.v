module SPI_Wrapper_tb2();
reg MOSI,SS_n,rst_n,clk;
wire MISO;


SPI_Wrapper dut3(MOSI,MISO,SS_n,clk,rst_n);

//clock generation
initial
begin
    $readmemh("sync_ram.dat" ,dut3.dut1.mem);   
	clk=0;
	forever 
	#1 clk=~clk;
end

integer i;
initial
begin
	rst_n=1;
	SS_n=1; 
	#2;
	rst_n=0;
	#4 rst_n=1;
	SS_n=0;     // from IDEL to CHK_CMD
	for(i=0;i<1000;i=i+1) begin
		#2 MOSI = $random;
	end
  $stop;


end

endmodule