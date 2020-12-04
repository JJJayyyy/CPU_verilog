`timescale 1ns/10ps
//output is 144 bits 
//rA and rB are 64 bits each
//function 6 bits(2 bits opcode)(4 bits function)
//rD 5 bits 
//PPPWW 5 bits 

module ID(clk, rst, IF_instruction, ALU_WB_en, WB_rD, WB_PPPWW, WB_data, ID_function_bit, ID_rD, ID_PPPWW, ID_rA_data, ID_rB_data, ID_WB_en, ID_wmem_en);
input wire clk, rst;
input wire [0:31] IF_instruction;
input wire ALU_WB_en;
input wire [0:4] WB_rD;
input wire [0:4] WB_PPPWW;
input wire [0:63] WB_data;

output reg [0:5] ID_function_bit;
output reg [0:4] ID_rD;
output reg [0:4] ID_PPPWW;
output reg [0:63] ID_rA_data;
output reg [0:63] ID_rB_data;
output reg ID_WB_en, ID_wmem_en;


reg [0:63] Register [0:31];
integer i;

always @(posedge clk)
begin
	if(rst==1)
	begin
		ID_function_bit <= 0;
		ID_rD <= 0;
		ID_PPPWW <= 0;
		ID_rA_data <= 0;
		ID_rB_data <= 0;
		ID_WB_en <= 0;
		ID_wmem_en <= 0;
	end
	else
	begin
		ID_rD <= IF_instruction[6:10];
		ID_PPPWW <= IF_instruction[21:25];
		ID_WB_en <= 1;
		ID_wmem_en <= 0;
		case(IF_instruction[0:5])
			6'b101010 :
				case(IF_instruction[28:31])
					4'b0000 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b0001 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b0010 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b0011 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b0100 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b0101 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b0110 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b0111 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b1000 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b1001 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b1010 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b1011 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]};
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= {59'b0,IF_instruction[16:20]};
					end
					4'b1100 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b1101 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= {59'b0,IF_instruction[16:20]};
					end
					4'b1110 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= Register[IF_instruction[16:20]];
					end
					4'b1111 :
					begin
						ID_function_bit <= {2'b00,IF_instruction[28:31]}; 
						ID_rA_data <= Register[IF_instruction[11:15]]; 
						ID_rB_data <= {59'b0,IF_instruction[16:20]};
					end
				endcase
						
			6'b100000 ://Load 
			begin
				ID_function_bit <= 6'b010000; 
				ID_rA_data <= 0; 
				ID_rB_data <= {48'b0,IF_instruction[16:31]};
			end
			6'b100001 ://Store
			begin
				ID_function_bit <= 6'b100000; 
				ID_rA_data <= Register[IF_instruction[6:10]]; 
				ID_rB_data <= {48'b0,IF_instruction[16:31]}; 
				ID_WB_en <= 0;
				ID_wmem_en <= 1;
			end
			6'b111100 :
			begin
				ID_function_bit <= 6'b110000; 
				ID_rA_data <= 0; 
				ID_rB_data <= 0; 
				ID_WB_en <= 0;//NOP
			end
			default :
			begin
				ID_function_bit <= 6'b110000; 
				ID_rA_data <= 0; 
				ID_rB_data <= 0; 
				ID_WB_en <= 0;//NOP
			end
		endcase
	end
end

always @(posedge clk)
begin
	if(rst==1)
	begin
		for(i = 1;i <32; i = i +1)
		begin
			Register[i] <= 0; 
		end
	end
	else
	begin
		if(ALU_WB_en==1 && WB_rD!=5'b00000)
		begin
			case(WB_PPPWW[0:2])
				3'b000 :
					Register[WB_rD] <= WB_data;
				3'b001 : 
					Register[WB_rD][0:31] <= WB_data[0:31];
				3'b010 : 
					Register[WB_rD][32:63] <= WB_data[32:63];
				3'b011 :
					case(WB_PPPWW[3:4])
						2'b00 :
						begin
							Register[WB_rD][0:7] <= WB_data[0:7];
							Register[WB_rD][16:23] <= WB_data[16:23];
							Register[WB_rD][32:39] <= WB_data[32:39];
							Register[WB_rD][48:55] <= WB_data[48:55];
						end
						2'b01 :
						begin
							Register[WB_rD][0:15] <= WB_data[0:15];
							Register[WB_rD][32:47] <= WB_data[32:47];
						end
						2'b10 : 
							Register[WB_rD][0:31] <= WB_data[0:31];
						2'b11 : 
							Register[WB_rD] <= WB_data;
					endcase
				3'b100 :
					case(WB_PPPWW[3:4])
						2'b00 :
						begin
							Register[WB_rD][8:15] <= WB_data[8:15];
							Register[WB_rD][24:31] <= WB_data[24:31];
							Register[WB_rD][40:47] <= WB_data[40:47];
							Register[WB_rD][56:63] <= WB_data[56:63];
						end
						2'b01 :
						begin
							Register[WB_rD][16:31] <= WB_data[16:31];
							Register[WB_rD][48:63] <= WB_data[48:63];
						end
						2'b10 : 
							Register[WB_rD][32:63] <= WB_data[32:63];
						2'b11 : 
							Register[WB_rD] <= Register[WB_rD];
					endcase
				default : 
					Register[WB_rD] <= Register[WB_rD];
			endcase
		end
	end
end

endmodule