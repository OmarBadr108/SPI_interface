module SPI_SLAVE (MISO,MOSI,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
parameter IDLE = 3'b000; //0
parameter WRITE = 3'b001; // 1
parameter CHK_CMD = 3'b010; // 2
parameter READ_ADD = 3'b011; // 3 
parameter READ_DATA = 3'b100; // 4

input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data ;
output reg [9:0] rx_data ;
output reg MISO , rx_valid ;
reg [2:0] cs , ns ;
//wire increment_in_read_add_state ;
reg [7:0] tmp_tx ;
reg [9:0] tmp_rx ;
reg add_or_data ;// 1 for data 0 for add  
reg done ; // processing
reg [3:0] i , j ;
// state memory 
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			cs <= IDLE ;
		else 
			cs <= ns ; 
	end


// next state logic 
	always @(*) begin
		case (cs) 
			IDLE :begin
				if(SS_n) ns = IDLE ;
				else ns = CHK_CMD ;
				i = 10 ;
				j = 8 ;
				done=0;
				rx_valid =0;
				tmp_rx=0;
				tmp_tx=0;			
			end 

			WRITE :begin
				if (~SS_n && ~done) ns = WRITE ;
				else ns = IDLE ;
			end

			CHK_CMD :
				if(SS_n) ns = IDLE ;
				else begin
					if (~MOSI) ns = WRITE ;
					else if (MOSI) begin 
					 	if (add_or_data) ns = READ_DATA ;
					 	else ns = READ_ADD ;
					 end 
				end
			READ_ADD :begin
				if (~SS_n && ~done) begin
					ns = READ_ADD ;
					add_or_data = 0;	
				end
				else if(SS_n || done) ns = IDLE ;
				end
			READ_DATA : begin 
				if (~SS_n && ~done) ns = READ_DATA ;
				else if(SS_n || done) ns = IDLE ;
			end
		endcase
	end

// output logic 
	always @(posedge clk) begin
		if ((cs == WRITE || cs == READ_DATA ||cs == READ_ADD) && SS_n == 0 ) begin
			if(~done) begin
				tmp_rx[i-1] <= MOSI ;
				i<=i-1;
				
			end	 
			if (i==0)begin 
				done <= 1 ;
				rx_valid <= 1 ; 
				rx_data [9:0] <= tmp_rx[9:0];
				if (rx_data[9:8] == 2'b10) add_or_data <=1;
			end // kda el write (seriel to parallel operation)

		end 
		if (cs == READ_DATA && tx_valid ) begin // here tmp_tx is complete and ram decides the operation 
			tmp_tx[7:0] <= tx_data [7:0] ;
			MISO <= tmp_tx[j-1];
			j <= j-1 ;
			if (j==0) done <= 1 ;
		end
	end
endmodule