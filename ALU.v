module ALU(clk, reset, ID_function_bit, ID_rD, ID_PPPWW, ID_rA_data, ID_rB_data, ID_WB_en, ALU_function_bit, ALU_output, ALU_PPPWW, ALU_rD, ALU_WB_en);

input clk, reset, ID_WB_en;
input[0:5] ID_function_bit;
input[0:4] ID_rD;
input[0:4] ID_PPPWW;
input[0:63] ID_rA_data;
input[0:63] ID_rB_data;
output reg [0:63] ALU_output;
output reg [0:5] ALU_function_bit;
output reg [0:4] ALU_PPPWW;
output reg [0:4] ALU_rD;
output reg ALU_WB_en;
reg [0:5] shift_num[0:2];
wire [0:64] SLL, SRL;
integer i, j, WW, bit, s;  // bit and s are for VSLL


assign SLL=	(ID_PPPWW[3:4] == 2'b00) ? {ID_rA_data[0:7] << shift_num[0], ID_rA_data[8:15] << shift_num[1], 
				ID_rA_data[16:23] << shift_num[2], ID_rA_data[24:31] << shift_num[3], ID_rA_data[32:39] << shift_num[4], 
				ID_rA_data[40:47] << shift_num[5], ID_rA_data[48:55] << shift_num[6], ID_rA_data[56:63] << shift_num[7]}: 
			(ID_PPPWW[3:4] == 2'b01) ? {ID_rA_data[0:15] << shift_num[0], ID_rA_data[16:31] << shift_num[1], 
				ID_rA_data[32:47] << shift_num[2], ID_rA_data[48:63] << shift_num[3]} : 
			(ID_PPPWW[3:4] == 2'b10) ? {ID_rA_data[0:31] << shift_num[0], ID_rA_data[32:63] << shift_num[1]} : {ID_rA_data[0:63] << shift_num[0]};

assign SRL=	(ID_PPPWW[3:4] == 2'b00) ? {ID_rA_data[0:7] >> shift_num[0], ID_rA_data[8:15] >> shift_num[1], 
				ID_rA_data[16:23] >> shift_num[2], ID_rA_data[24:31] >> shift_num[3], ID_rA_data[32:39] >> shift_num[4], 
				ID_rA_data[40:47] >> shift_num[5], ID_rA_data[48:55] >> shift_num[6], ID_rA_data[56:63] >> shift_num[7]}: 
			(ID_PPPWW[3:4] == 2'b01) ? {ID_rA_data[0:15] >> shift_num[0], ID_rA_data[16:31] >> shift_num[1], 
				ID_rA_data[32:47] >> shift_num[2], ID_rA_data[48:63] >> shift_num[3]} : 
			(ID_PPPWW[3:4] == 2'b10) ? {ID_rA_data[0:31] >> shift_num[0], ID_rA_data[32:63] >> shift_num[1]} : {ID_rA_data[0:63] >> shift_num[0]};			


always@(posedge clk) begin
	if(reset) begin
		ALU_output <= 0;
	end
	else begin
		ALU_PPPWW <= ID_PPPWW;
		ALU_rD <= ID_rD;
		ALU_WB_en <= ID_WB_en;
		ALU_function_bit <= ID_function_bit;
		case(ID_function_bit[2:5])
			4'b0000: 	ALU_output <= ID_rA_data[0:63] & ID_rB_data[0:63]; 	// VAND
				
			4'b0001: 	ALU_output <= ID_rA_data[0:63] | ID_rB_data[0:63]; 	// VOR

			4'b0010:	ALU_output <= ID_rA_data[0:63] ^ ID_rB_data[0:63]; 	// VXOR				

			4'b0011: 	ALU_output <= ~ ID_rA_data[0:63]; 	// VNOT
				
			4'b0100: 	ALU_output <= ID_rA_data[0:63]; 	// VMOV

			4'b0101: 	
				begin 	// VADD
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<63; i=i+8) ALU_output[i+:8] <=  ID_rA_data[i+:8] + ID_rB_data[i+:8];
						2'b01 : for(i=0; i<63; i=i+16) ALU_output[i+:16] <=  ID_rA_data[i+:16] + ID_rB_data[i+:16];
						2'b10 : for(i=0; i<63; i=i+32) ALU_output[i+:32] <=  ID_rA_data[i+:32] + ID_rB_data[i+:32];
						2'b11 : for(i=0; i<63; i=i+64) ALU_output[i+:64] <=  ID_rA_data[i+:64] + ID_rB_data[i+:64];
						default: ALU_output <= 0;
					endcase
				end

			4'b0110: 	
				begin	// VSUB
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<63; i=i+8) ALU_output[i+:8] <=  ID_rA_data[i+:8] + ~ID_rB_data[i+:8] + 1;
						2'b01 : for(i=0; i<63; i=i+16) ALU_output[i+:16] <=  ID_rA_data[i+:16] + ~ID_rB_data[i+:16] + 1;
						2'b10 : for(i=0; i<63; i=i+32) ALU_output[i+:32] <=  ID_rA_data[i+:32] + ~ID_rB_data[i+:32] + 1;
						2'b11 : for(i=0; i<63; i=i+64) ALU_output[i+:64] <=  ID_rA_data[i+:64] + ~ID_rB_data[i+:64] + 1;
						default: ALU_output <= 0;
					endcase
				end

			4'b0111: 	
				begin	// VMULEU
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<63; i=i+2*8) ALU_output[i+:2*8] <=  ID_rA_data[i+:8] * ID_rB_data[i+:8];
						2'b01 : for(i=0; i<63; i=i+2*16) ALU_output[i+:2*16] <=  ID_rA_data[i+:16] * ID_rB_data[i+:16];
						2'b10 : for(i=0; i<63; i=i+2*32) ALU_output[i+:2*32] <=  ID_rA_data[i+:32] * ID_rB_data[i+:32];
						default: ALU_output <= 0;
					endcase
				end

			4'b1000:	
				begin	// VMULOU
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<63; i=i+2*8) ALU_output[i+:2*8] <=  ID_rA_data[(i+8)+:8] * ID_rB_data[(i+8)+:8];
						2'b01 : for(i=0; i<63; i=i+2*16) ALU_output[i+:2*16] <=  ID_rA_data[(i+16)+:16] * ID_rB_data[(i+16)+:16];
						2'b10 : for(i=0; i<63; i=i+2*32) ALU_output[i+:2*32] <=  ID_rA_data[(i+32)+:32] * ID_rB_data[(i+32)+:32];
						default: ALU_output <= 0;
					endcase
				end

			4'b1001:	
				begin	// VRRTH
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<63; i=i+8) ALU_output[i+:8] <=  {ID_rA_data[(i+8/2)+:4], ID_rA_data[i+:4]};
						2'b01 : for(i=0; i<63; i=i+16) ALU_output[i+:16] <=  {ID_rA_data[(i+16/2)+:8], ID_rA_data[i+:8]};
						2'b10 : for(i=0; i<63; i=i+32) ALU_output[i+:32] <=  {ID_rA_data[(i+32/2)+:16], ID_rA_data[i+:16]};
						2'b11 : for(i=0; i<63; i=i+64) ALU_output[i+:64] <=  {ID_rA_data[(i+64/2)+:32], ID_rA_data[i+:32]};
						default: ALU_output <= 0;
					endcase
				end

			4'b1010:	
				begin	// VSLL
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<8; i=i+1)  shift_num[i] <= {3'b0, ID_rB_data[(i*8+8-3)+:3]};
						2'b01 : for(i=0; i<4; i=i+1)  shift_num[i] <= {2'b0, ID_rB_data[(i*16+16-4)+:4]};
						2'b10 : for(i=0; i<2; i=i+1)  shift_num[i] <= {1'b0, ID_rB_data[(i*32+32-5)+:5]};
						2'b11 : for(i=0; i<1; i=i+1)  shift_num[i] <= ID_rB_data[(i*64+64-6)+:6];
						default: ALU_output <= 0;
					endcase
					
				end

			4'b1011:	
				begin	// VSLLi
					case(ID_PPPWW[3:4])  // put the shift amount at rB[59:63]
						2'b00 : for(i=0; i<8; i=i+1) shift_num[i] <= {3'b0, ID_rB_data[63-3:63]}; 
						2'b01 : for(i=0; i<4; i=i+1) shift_num[i] <= {2'b0, ID_rB_data[63-4:63]}; 				
						2'b10 : for(i=0; i<2; i=i+1) shift_num[i] <= {1'b0, ID_rB_data[63-5:63]}; 
						2'b11 : for(i=0; i<1; i=i+1) shift_num[i] <= {1'b0, ID_rB_data[63-5:63]}; 
						default: ALU_output <= 0;
					endcase
					
				end

			4'b1100:	
				begin	// VSRL
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<8; i=i+1)  shift_num[i] <= {3'b0, ID_rB_data[i+8-3+:3]};
						2'b01 : for(i=0; i<4; i=i+1)  shift_num[i] <= {2'b0, ID_rB_data[i+16-4+:4]};
						2'b10 : for(i=0; i<2; i=i+1)  shift_num[i] <= {1'b0, ID_rB_data[i+32-5+:5]};									
						2'b11 : for(i=0; i<1; i=i+1)  shift_num[i] <= ID_rB_data[i+64-6+:6];
						default: ALU_output <= 0;
					endcase
					
				end

			4'b1101:	
				begin 	// VSRLi
					case(ID_PPPWW[3:4])
						2'b00 : for(i=0; i<8; i=i+1) shift_num[i] <= {3'b0, ID_rB_data[63-3:63]}; 
						2'b01 : for(i=0; i<4; i=i+1) shift_num[i] <= {2'b0, ID_rB_data[63-4:63]}; 
						2'b10 : for(i=0; i<2; i=i+1) shift_num[i] <= {1'b0, ID_rB_data[63-5:63]}; 									
						2'b11 : for(i=0; i<1; i=i+1) shift_num[i] <= {1'b0, ID_rB_data[63-5:63]}; 
						default: ALU_output <= 0;
					endcase
				end

			4'b1110:	
				begin	// VSRA
					case(ID_PPPWW[3:4])
						2'b00 : begin
									for(i=0; i<8; i=i+1) begin
										shift_num[i] <= {3'b0, ID_rB_data[(i+8-3)+:3]};
										for(j=0; j<8; j=j+1) ALU_output[i*8+j] <= (j<shift_num[i]) ? ID_rA_data[i*8] : ID_rA_data[i*8+j-shift_num[i]];
									end
								end
						2'b01 : begin
									for(i=0; i<8; i=i+1) begin
										shift_num[i] <= {2'b0, ID_rB_data[(i+8-4)+:4]};
										for(j=0; j<4; j=j+1) ALU_output[i*16+j] <= (j<shift_num[i]) ? ID_rA_data[i*16] : ID_rA_data[i*16+j-shift_num[i]];
									end
								end
						2'b10 : begin
									for(i=0; i<8; i=i+1) begin
										shift_num[i] <= {1'b0, ID_rB_data[(i+8-5)+:5]};
										for(j=0; j<2; j=j+1) ALU_output[i*32+j] <= (j<shift_num[i]) ? ID_rA_data[i*32] : ID_rA_data[i*32+j-shift_num[i]];
									end
								end										
						2'b11 : begin
									for(i=0; i<8; i=i+1) begin
										shift_num[i] <= ID_rB_data[(i+8-5)+:6];
										for(j=0; j<1; j=j+1) ALU_output[i*64+j] <= (j<shift_num[i]) ? ID_rA_data[i*64] : ID_rA_data[i*64+j-shift_num[i]];
									end 
								end								
						default: ALU_output <= 0;
					endcase
				end

			4'b1111:	
				begin	// VSRAi
					case(ID_PPPWW[3:4])  // put the shift amount at rB[59:63]
						2'b00 : begin
									for(i=0; i<8; i=i+1) begin
										shift_num[i] <= {3'b0, ID_rB_data[63-3:63]}; 
										for(j=0; j<8; j=j+1) ALU_output[i*8+j] <= (j<shift_num[i]) ? ID_rA_data[i*8] : ID_rA_data[i*8+j-shift_num[i]];
									end
								end
						2'b01 : begin
									for(i=0; i<4; i=i+1) begin
										shift_num[i] <= {2'b0, ID_rB_data[63-4:63]}; 
										for(j=0; j<8; j=j+1) ALU_output[i*16+j] <= (j<shift_num[i]) ? ID_rA_data[i*16] : ID_rA_data[i*16+j-shift_num[i]];
									end
								end
						2'b10 : begin
									for(i=0; i<2; i=i+1) begin
										shift_num[i] <= {1'b0, ID_rB_data[63-5:63]}; 
										for(j=0; j<8; j=j+1) ALU_output[i*32+j] <= (j<shift_num[i]) ? ID_rA_data[i*32] : ID_rA_data[i*32+j-shift_num[i]];
									end
								end										
						2'b11 : begin
									for(i=0; i<1; i=i+1) begin
										shift_num[i] <= {1'b0, ID_rB_data[63-5:63]}; 
										for(j=0; j<8; j=j+1) ALU_output[i*64+j] <= (j<shift_num[i]) ? ID_rA_data[i*64] : ID_rA_data[i*64+j-shift_num[i]];
									end 
								end
						default: ALU_output <= 0;
					endcase

				end
		endcase
	end
end
endmodule

