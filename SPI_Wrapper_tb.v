module SPI_Wrapper_tb();
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
	#2;        //delay to set in CHK_CMD -->not must
	
    // -----------------------------test the writing--------------------------------//
    //for addres to write in
	MOSI=0;   // as ss_n=0 & MOSI=0  go to WRITE -->the first bit that spi know it's write operation
	// send the mosi 00 to ram to Know that it"s add of write opearation on 2 clk cycle
	#2 MOSI=0;
	#2 MOSI=0;
	#2;
    // the adderss bits
    for(i=0;i<9;i=i+1)     // to randomize the addres bits
    begin
    	MOSI=$random;
    	#2;               //to randomize with posedge clk
    end                  // after finshing the addres it return back to IDLE state but ss_n still 0 it will go to CHK_CMD
  //  #4;                 //wait to go to CHK-CMD

    // for writing the data 
    MOSI=0;            // as ss_n=0 & MOSI=0  go to WRITE -->the first bit that spi know it's write operation
	// send the mosi 01 to ram to Know that it"s data of write opearation on 2 clk cycle
	#2 MOSI=0;
	#2 MOSI=1;
	#2;
	// the data bits
    for(i=0;i<9;i=i+1)     // to randomize the data bits
    begin
    	MOSI=$random;
    	#2;               //to randomize with posedge clk
    end                  // after finshing the data it return back to IDLE state but ss_n still 0 it will go to CHK_CMD
  //  #4;                  //wait to go to CHK-CMD  



    // -----------------------------test the reading--------------------------------//
    //for addres to read in
	MOSI=1;   // as ss_n=0 & MOSI=1  go to READ-->the first bit that spi know it's READ operation
	// send the mosi 10 to ram to Know that it"s add of read opearation on 2 clk cycle
	#2 MOSI=1;
	#2 MOSI=0;
	#2;
    // the adderss bits
    for(i=0;i<9;i=i+1)     // to randomize the addres bits
    begin
    	MOSI=$random;
    	#2;               //to randomize with posedge clk
    end                  // after finshing the addres it return back to IDLE state but ss_n still 0 it will go to CHK_CMD
    #4;                 //wait to go to CHK-CMD

    // for read the data 
    MOSI=1;            // as ss_n=0 & MOSI=1  go to READ -->the first bit that spi know it's READ operation
	// send the mosi 11 to ram to Know that it"s data of READ opearation on 2 clk cycle
	#2 MOSI=1;
	#2 MOSI=1;
	#2;
	// the data  bits NOTE --> it's dummy
    for(i=0;i<9;i=i+1)     // to randomize the data bits
    begin
    	MOSI=$random;
    	#2;               //to randomize with posedge clk
    end                  // after finshing the data it return back to IDLE state but ss_n still 0 it will go to CHK_CMD
//    #4;                  //wait to go to CHK-CMD  
    for(i=0;i<9;i=i+1)     // to randomize the data bits
    begin
    	#2;               //to randomize with posedge clk
    end   
    for(i=0;i<9;i=i+1)     // to randomize the data bits
    begin
    	#2;               //to randomize with posedge clk
    end  
    $stop;


end

endmodule