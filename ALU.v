module ALU(clk, reset, ALU_enable, ID_function_bit, ID_rD, ID_PPPWW, ID_rA_data, ID_rB_data, ALU_output, ALU_PPPWW, ALU_rD);

input ALU_enable, clk, reset;
input[0:5] ID_function_bit;
input[0:4] ID_rD;
input[0:4] ID_PPPWW;
input[0:63] ID_rA_data;
input[0:63] ID_rB_data;
output reg [0:63] ALU_output;
output reg [0:2] ALU_PPPWW;
output reg [0:4] ALU_rD;

integer i, WW, bit, s;  // bit and s are for VSLL


always@(posedge clk) begin
	if(reset) begin
		ALU_output <= 0;
	end
	else if(ALU_enable) begin
		ALU_PPPWW <= ID_PPPWW;
		ALU_rD <= ID_rD;

		case(ID_function_bit[2:5])
			4'b0000: 	ALU_output <= ID_rA_data[0:63] & ID_rB_data[0:63]; 	// VAND
				
			4'b0001: 	ALU_output <= ID_rA_data[0:63] | ID_rB_data[0:63]; 	// VOR

			4'b0010:	ALU_output <= ID_rA_data[0:63] ^ ID_rB_data[0:63]; 	// VXOR				

			4'b0011: 	ALU_output <= ~ ID_rA_data[0:63]; 	// VNOT
				
			4'b0100: 	ALU_output <= ID_rA_data[0:63]; 	// VMOV
				

			4'b0101: 	
				begin 	// VADD
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
								end
						2'b01 : begin
									WW = 16;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
								end
						2'b10 : begin
									WW = 32;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
								end
						2'b11 : begin
									WW = 64;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b0110: 	
				begin	// VSUB
					case(ID_PPPWW[3:4])
						2'b00 : begin 
									WW = 8;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
								end
						2'b01 : begin
									WW = 16;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
								end
						2'b10 : begin
									WW = 32;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
								end
						2'b11 : begin
									WW = 64;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b0111: 	
				begin	// VMULEU
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8;
									for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i:i+(WW-1)] * ID_rB_data[i:i+(WW-1)];
								end
						2'b01 : 	begin
									WW = 16;
									for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i:i+(WW-1)] * ID_rB_data[i:i+(WW-1)];
								end
						2'b10 : 	begin
									WW = 32;
									for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i:i+(WW-1)] * ID_rB_data[i:i+(WW-1)];
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b1000:	
				begin	// VMULOU
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8;
									for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i+WW:i+(2*WW-1)] * ID_rB_data[i+WW:i+(2*WW-1)];
								end
						2'b01 : 	begin
									WW = 16;
									for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i+WW:i+(2*WW-1)] * ID_rB_data[i+WW:i+(2*WW-1)];
								end
						2'b10 : 	begin
									WW = 32;
									for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i+WW:i+(2*WW-1)] * ID_rB_data[i+WW:i+(2*WW-1)];
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b1001:	
				begin	// VRRTH
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
								end
						2'b01 : begin
									WW = 16;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
								end
						2'b10 : begin
									WW = 32;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
								end
						2'b11 : begin
									WW = 64;
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b1010:	
				begin	// VSLL
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8; bit = 3;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+WW-bit:i+WW-1];
										ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s'b0};
									end
								end
						2'b01 : begin
									WW = 16; bit = 4;										
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+WW-bit:i+WW-1];
										ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
									end
								end
						2'b10 : begin
									WW = 32; bit = 5;										
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+WW-bit:i+WW-1];
										ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
									end
								end
						2'b11 : begin
									WW = 64; bit = 6;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+WW-bit:i+WW-1];
										ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
									end
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b1011:	
				begin	// VSLLi
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8; bit = 3;
									s = ID_rB_data[63-bit:63];  // put the shift amount at rB[59:63]
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
								end
						2'b01 : begin
									WW = 16; bit = 4;
									s = ID_rB_data[63-bit:63]; 
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
								end
						2'b10 : begin
									WW = 32; bit = 5;
									s = ID_rB_data[63-bit:63]; 
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
								end
						2'b11 : begin
									WW = 64; bit = 5;
									s = ID_rB_data[63-bit:63];
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b1100:	
				begin	// VSRL
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8; bit = 3;								
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
									end
								end
						2'b01 : begin
									WW = 16; bit = 4;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
									end
								end
						2'b10 : begin
									WW = 32; bit = 5;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
									end
								end										
						2'b11 : begin
									WW = 64; bit = 6;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
									end
								end										
						default: ALU_output <= 0;
					endcase
				end

			4'b1101:	
				begin 	// VSRLi
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8; bit = 3;
									s = ID_rB_data[63-bit:63];  // put the shift amount at rB[59:63]
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
								end
						2'b01 : begin
									WW = 16; bit = 4;
									s = ID_rB_data[63-bit:63]; 
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
								end
						2'b10 : begin
									WW = 32; bit = 5;
									s = ID_rB_data[63-bit:63]; 
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
								end
						2'b11 : begin
									WW = 64; bit = 5;
									s = ID_rB_data[63-bit:63];
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
								end
						default: ALU_output <= 0;
					endcase
				end

			4'b1110:	
				begin	// VSRA
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8; bit = 3;								
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
									end
								end
						2'b01 : begin
									WW = 16; bit = 4;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
									end
								end
						2'b10 : begin
									WW = 32; bit = 5;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
									end
								end										
						2'b11 : begin
									WW = 64; bit = 6;
									for(i=0; i<63-WW; i=i+WW) begin
										s = ID_rB_data[i+(WW-bit):i+(WW-1)];
										ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
									end	
								end									
						default: ALU_output <= 0;
					endcase
				end

			4'b1111:	
				begin	// VSRAi
					case(ID_PPPWW[3:4])
						2'b00 : begin
									WW = 8; bit = 3;
									s = ID_rB_data[63-bit:63];  // put the shift amount at rB[59:63]
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
								end
						2'b01 : begin
									WW = 16; bit = 4;
									s = ID_rB_data[63-bit:63]; 
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
								end
						2'b10 : begin
									WW = 32; bit = 5;
									s = ID_rB_data[63-bit:63]; 
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
								end
						2'b11 : begin
									WW = 64; bit = 5;
									s = ID_rB_data[63-bit:63];
									for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
								end
						default: ALU_output <= 0;
					endcase
				end
		endcase
	end
end
endmodule

