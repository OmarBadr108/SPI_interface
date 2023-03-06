module ALSU_tb();
reg clk,rst,cin,serial_in,red_op_A,red_op_B,bypass_A,bypass_B,direction;
reg[2:0] A,B,opcode;
wire[15:0] leds;
wire[5:0] out;
integer i;
//instantiation
ALSU DUT(clk,rst,A,B,cin,serial_in,red_op_A,red_op_B,opcode,bypass_A,bypass_B,direction,leds,out);


//clock initiallizing
initial begin
	clk = 0;
	forever begin
		#1 clk=~clk;
	end
end

initial begin
	rst = 0;
	#2 rst = 1;
	#2 rst = 0;
	#2


	for(i=0;i<100;i=i+1) begin
	A =$random;
	B = $random;
	opcode =$random;
	cin =$random;
	serial_in =$random;
	red_op_A =$random;
	red_op_B =$random;
	bypass_A =$random;
	bypass_B=$random;
	direction=$random;
	#2
	end

	$stop;
end


endmodule