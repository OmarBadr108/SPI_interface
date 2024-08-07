class  mosirand;
	rand logic mosiC ;
	constraint c {
		mosiC <= 1;
	}
endclass : mosirand





module spiwrappertb;
logic MOSI;
logic MISO;
logic SS_n;
logic clk;
logic rst_n;
logic tempS [$];
logic [7:0] tempaddress;
logic [7:0] tempdata;
logic [7:0]	tempout;
//Class Instance
mosirand m;

//DUT Instantiation
spi_wrapper uut (MISO,MOSI,SS_n,clk,rst_n);


//Clock Generation
	initial begin
		clk=0;
		forever begin
		#1 clk =~clk;
		end	
	end
////////////////////////*Assertions Block*//////////////////////////////////
aWriteAddress : cover property (@(negedge clk) $fell(SS_n) |-> ##1 !MOSI [*3]);
aWriteData : cover property (@(negedge clk) $fell(SS_n) |-> ##1 !MOSI[*2] ##1 MOSI);
aReadAddress : cover property (@(negedge clk) $fell(SS_n) |-> ##1 MOSI[*2] ##1 !MOSI);
aReadData : cover property (@(negedge clk) $fell(SS_n) |-> ##1 MOSI[*3]);

////////////////////////////////////////////////////////////////////////////////

// Main initial Block
initial begin
	m = new();
repeat(5) @(negedge clk)
	rst_n =0;

rst_n =1;
SS_n = 1;
MOSI=0;

$display("/////////////////writing Random Data/////////////////");
//////////////////////*Write Address*/////////////////////////////
@(negedge clk)
	SS_n=0;
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 || i==2) begin
			MOSI= 0 ;
		end	
		else begin
			assert(m.randomize());
			MOSI= m.mosiC ;
			tempS.push_back(MOSI);
		end
	end

for (int i = 7 ; i >= 0 ; i--) begin
	tempaddress[i]= tempS.pop_front();
end

$write("this is the address:");
for (int i = 7; i >= 0; i--) begin
	$write(tempaddress[i]);
end
$display("");
repeat(2)@(negedge clk)
SS_n= 1;

//////////////////////*Write Data*/////////////////////////////////
	@(negedge clk)
	 SS_n=0;
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 ) begin
			MOSI= 0 ;
		end	
		else if (i==2)
			MOSI=1;
		else begin
			assert(m.randomize());
			MOSI= m.mosiC ;
			tempS.push_back(MOSI);
		end
	end


for (int i = 7 ; i >= 0 ; i--) begin
	tempdata[i]= tempS.pop_front();
end

$write("this is the data:");
for (int i = 7; i >= 0; i--) begin
	$write(tempdata[i]);
end
$display("");
repeat(2)@(negedge clk)
SS_n= 1;


//////////////////////*Read Address*/////////////////////////////////
	@(negedge clk)
	SS_n=0;
	for (int i = 10 ; i >= 0 ; i--) begin
		@(negedge clk )
		if (i == 10 || i== 9 ) begin
			MOSI= 1 ;
		end	
		else if (i==8)
			MOSI=0;
		else begin
			MOSI= tempaddress[i] ;
			tempS.push_back(MOSI);
		end
	end

$display ("this is read address %0p",tempS);

tempS = {};

repeat(2)@(negedge clk)
SS_n= 1;
//////////////////////*Read Data*/////////////////////////////////
	@(negedge clk)
	SS_n=0;
//Check MOSI inputs for Read Data Command
//111
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 || i==2 ) begin
			MOSI= 1 ;
		end	
		else begin
			assert(m.randomize());
			MOSI= m.mosiC ;
		end
	end

//Read MISO Outputs

for (int i = 7; i >= 0; i--) begin
	@(negedge clk)
		tempout[i] = MISO;
end


$write("this is the Read Data : ");
for (int i = 7; i >= 0; i--) begin
	$write(tempout[i]);
end
$display("");
checkOut(tempout, tempdata);
repeat(2) @(negedge clk)
SS_n= 1;

$display("/////////////////writing Zeros Data/////////////////");
//////////////////////*Write Address*/////////////////////////////
@(negedge clk)
	SS_n=0;
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 || i==2) begin
			MOSI= 0 ;
		end	
		else begin
			assert(m.randomize());
			MOSI= m.mosiC ;
			tempS.push_back(MOSI);
		end
	end

for (int i = 7 ; i >= 0 ; i--) begin
	tempaddress[i]= tempS.pop_front();
end

$write("this is the address:");
for (int i = 7; i >= 0; i--) begin
	$write(tempaddress[i]);
end
$display("");
repeat(2)@(negedge clk)
SS_n= 1;

//////////////////////*Write Data Zeros*/////////////////////////////////
	@(negedge clk)
	 SS_n=0;
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 ) begin
			MOSI= 0 ;
		end	
		else if (i==2)
			MOSI=1;
		else begin
			MOSI= 0 ;
			tempS.push_back(MOSI);
		end
	end


for (int i = 7 ; i >= 0 ; i--) begin
	tempdata[i]= tempS.pop_front();
end

$write("this is the data:");
for (int i = 7; i >= 0; i--) begin
	$write(tempdata[i]);
end
$display("");
repeat(2)@(negedge clk)
SS_n= 1;



//////////////////////*Read Address*/////////////////////////////////
	@(negedge clk)
	SS_n=0;
	for (int i = 10 ; i >= 0 ; i--) begin
		@(negedge clk )
		if (i == 10 || i== 9 ) begin
			MOSI= 1 ;
		end	
		else if (i==8)
			MOSI=0;
		else begin
			MOSI= tempaddress[i] ;
			tempS.push_back(MOSI);
		end
	end

$display ("this is read address %0p",tempS);

tempS = {};

repeat(2)@(negedge clk)
SS_n= 1;
//////////////////////*Read Data*/////////////////////////////////
	@(negedge clk)
	SS_n=0;
//Check MOSI inputs for Read Data Command
//111
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 || i==2 ) begin
			MOSI= 1 ;
		end	
		else begin
			assert(m.randomize());
			MOSI= m.mosiC ;
		end
	end

//Read MISO Outputs

for (int i = 7; i >= 0; i--) begin
	@(negedge clk)
		tempout[i] = MISO;
end


$write("this is the Read Data : ");
for (int i = 7; i >= 0; i--) begin
	$write(tempout[i]);
end
$display("");

checkOut(tempout, tempdata);
repeat(2) @(negedge clk)
SS_n= 1;

$display("/////////////////writing ONEs Data/////////////////");
//////////////////////*Write Address*/////////////////////////////
@(negedge clk)
	SS_n=0;
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 || i==2) begin
			MOSI= 0 ;
		end	
		else begin
			assert(m.randomize());
			MOSI= m.mosiC ;
			tempS.push_back(MOSI);
		end
	end


for (int i = 7 ; i >= 0 ; i--) begin
	tempaddress[i]= tempS.pop_front();
end

$write("this is the address:");
for (int i = 7; i >= 0; i--) begin
	$write(tempaddress[i]);
end
$display("");
repeat(2)@(negedge clk)
SS_n= 1;

//////////////////////*Write Data ONEs*/////////////////////////////////
	@(negedge clk)
	 SS_n=0;
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 ) begin
			MOSI= 0 ;
		end	
		else if (i==2)
			MOSI=1;
		else begin
			MOSI= 1 ;
			tempS.push_back(MOSI);
		end
	end

for (int i = 7 ; i >= 0 ; i--) begin
	tempdata[i]= tempS.pop_front();
end

$write("this is the data:");
for (int i = 7; i >= 0; i--) begin
	$write(tempdata[i]);
end
$display("");
repeat(2)@(negedge clk)
SS_n= 1;


//////////////////////*Read Address*/////////////////////////////////
	@(negedge clk)
	SS_n=0;
	for (int i = 10 ; i >= 0 ; i--) begin
		@(negedge clk )
		if (i == 10 || i== 9 ) begin
			MOSI= 1 ;
		end	
		else if (i==8)
			MOSI=0;
		else begin
			MOSI= tempaddress[i] ;
			tempS.push_back(MOSI);
		end
	end

$display ("this is read address %0p",tempS);
tempS = {};

repeat(2)@(negedge clk)
SS_n= 1;
//////////////////////*Read Data*/////////////////////////////////
	@(negedge clk)
	SS_n=0;
//Check MOSI inputs for Read Data Command
//111
	for (int i = 0; i < 11 ; i++) begin
		@(negedge clk )
		if (i == 0 || i==1 || i==2 ) begin
			MOSI= 1 ;
		end	
		else begin
			assert(m.randomize());
			MOSI= m.mosiC ;
		end
	end

//Read MISO Outputs

for (int i = 7; i >= 0; i--) begin
	@(negedge clk)
		tempout[i] = MISO;
end


$write("this is the Read Data : ");
for (int i = 7; i >= 0; i--) begin
	$write(tempout[i]);
end
$display("");
checkOut(tempout, tempdata);
repeat(2) @(negedge clk)
SS_n= 1;


$stop;
end
task checkOut(logic [7:0] expected, logic [7:0] actual);
	int errorCount;
	for(int i = 7 ; i >= 0 ; i--) begin
		if (expected[i] != actual[i] ) begin
			errorCount++;
		end
	end
	if (errorCount > 0 )
		$display("the output isn't similar to the input");
endtask : checkOut
endmodule
