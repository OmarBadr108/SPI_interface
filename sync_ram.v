module sync_ram(din,dout,rx_valid,tx_valid,clk,rst_n);
input[9:0] din;
input rx_valid,clk,rst_n;
output reg[7:0] dout;
output reg tx_valid;

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
reg[7:0] mem[MEM_DEPTH-1:0];

reg[7:0] wr_addr,rd_addr;
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		dout <= 0;
		tx_valid<=0;
	end
	else begin
		case(din[9:8])
		2'b00: begin
				if (rx_valid) begin
					wr_addr <= din[7:0];
					tx_valid <=0;	
				end 
				
		end
		2'b01: begin
				if (rx_valid) begin
					mem[wr_addr] <= din[7:0];
					tx_valid <=0;	
				end 
				
			
		end 
		2'b10: begin 
				if (rx_valid) begin
					rd_addr <= din[7:0];
					tx_valid<=0;	
				end 
				
		end
		2'b11: begin
				dout <= mem[rd_addr];
				tx_valid <= 1;
		end
		endcase

	end

end


endmodule