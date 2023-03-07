module ALSU (A,B,opcode,cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst,out,leds);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

parameter IDLE = 3'b000;
parameter display_out = 3'b001;
parameter invalid_out = 3'b010;
input [2:0] A,B,opcode;
input cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst;

output reg [5:0] out ;
output reg [15:0] leds ; 
reg taking_input ;
reg invalid ;
reg [2:0] cs , ns ;
//reg [31:0] k ;

	always @(posedge clk or posedge rst) begin
		if (rst)
			cs <= IDLE ;
		else 
			cs <= ns ; 
	end

	// next state logic 
	always @(*) begin
		case (cs) 
			IDLE :begin
				if(rst) ns = IDLE;
				else if (~rst && invalid) ns = invalid_out ;
					out = 0 ;
					leds = 0 ;
					//k=15; // for leds
			end 
			display_out :begin
				if (rst) ns = IDLE ;
				else ns = display_out ;
			end
			invalid_out :begin
				if(invalid && ~rst) ns = invalid_out ;
				else if (rst) ns = IDLE ;
				leds = leds ^ 16'b1111_1111_1111_1111 ;
				out = 0 ;
			end
		endcase
	end


	// output logic 
	always @(posedge clk) begin
		if (bypass_A) 
			out <= A ;
		else if (bypass_B)
			out <= B ;
		else begin
			case (opcode)
				3'b000 : begin
							if (red_op_A && ~red_op_B) out <= &A ;
							else if (red_op_B && ~red_op_A) out <= &B ;
							else out <= A&B ; 
						 end
				3'b001 : begin
							if (red_op_A && ~red_op_B) out <= ^A ;
							else if (red_op_B && ~red_op_A) out <= ^B ;
							else out <= A^B ; 
						 end 
				3'b010 : begin
							if (FULL_ADDER == "ON")
				 			out <= A+B+cin ;
				 			else invalid <= 1 ;
						 end 
				3'b011 : out <= A*B ;
				3'b100 : begin  // shift
							if (direction) // shift left
								out <={out[5:1],serial_in}; 
							else // shift right
								out <={serial_in,out[4:0]};
						 end  
				3'b101 : begin  // rotate
							if (direction) // rotate left
								out <= out<<1 ;  
							else // rotate right
								out <= out>>1 ; 
						 end  
				3'b110 : invalid <= 1 ;
				3'b111 : invalid <= 1 ;
			endcase
			if ( ((red_op_A)||(red_op_B)) && ( (opcode !=3'b000) || (opcode !=3'b001) ) ) invalid <=1;
		end
	end
endmodule