`timescale 1ns/10ps
//output is 144 bits 
//rA and rB are 64 bits each
//function 6 bits(2 bits opcode)(4 bits function)
//rD 5 bits 
//PPPWW 5 bits 

module ID_stage (clk, rst, IF_instruction, ID_function_bit, ID_rD, ID_PPPWW, ID_rA_data, ID_rB_data, ID_wb_en, ID_wmem_en);
input clk, rst;
input [0:31] IF_instruction;
wire clk, rst;


output reg [0:5] ID_function_bit;
output reg [0:4] ID_rD;
output reg [0:4] ID_PPPWW;
output reg [0:63] ID_rA_data;
output reg [0:63] ID_rB_data;
output reg ID_wb_en, ID_wmem_en;

	
reg [0:63] Register [0:4];


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
		ID_wb_en <= 0;
		ID_wmem_en <= 0;
	end
	else
	begin
		ID_rD <= IF_instruction[6:10];
		ID_PPPWW <= IF_instruction[21:25];
		ID_wb_en <= 1;
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
						
			6'b100000 :
			begin
				ID_function_bit <= 6'b010000; 
				ID_rA_data <= 0; 
				ID_rB_data <= {48'b0,IF_instruction[16:31]};
			end
			6'b100001 :
			begin
				ID_function_bit <= 6'b100000; 
				ID_rA_data <= 0; 
				ID_rB_data <= {48'b0,IF_instruction[16:31]}; 
				ID_wb_en <= 0;
				ID_wmem_en <= 1;
			end
			6'b111100 :
			begin
				ID_function_bit <= 6'b110000; 
				ID_rA_data <= 0; 
				ID_rB_data <= 0; 
				ID_wb_en <= 0;//NOP
			end
			default :
			begin
				ID_function_bit <= 6'b110000; 
				ID_rA_data <= 0; 
				ID_rB_data <= 0; 
				ID_wb_en <= 0;//NOP
			end
		endcase
	end
end

endmodule