module ALU(ALU_enable, ID_function_bit, ID_rD, ID_PPPWW, ID_rA_data, ID_rB_data
		ALU_output, ALU_PPPWW, ALU_rD, CLK, RST);

input ALU_enable, CLK, RST;
input[0:5] ID_function_bit;
input[0:4] ID_rD;
input[0:4] ID_PPPWW;
input[0:63] ID_rA_data;
input[0:63] ID_rB_data;
output reg [0:63] ALU_output;
output reg [0:2] ALU_PPPWW;
output reg [0:4] ALU_rD;

integer i, WW, bit, s;  // bit and s are for VSLL

always@(posedge CLK) begin
	if(RST) begin
		ALU_output <= 0;
	end
	else if(ALU_enable) begin
		case(ID_function_bit[2:5])
			4b'0000: 	// VAND
				ALU_output <= ID_rA_data[0:63] & ID_rB_data[0:63];
				
			4b'0001: 	// VOR
				ALU_output <= ID_rA_data[0:63] | ID_rB_data[0:63];

			4b'0010: 	// VXOR
				ALU_output <= ID_rA_data[0:63] ^ ID_rB_data[0:63];

			4b'0011: 	// VNOT
				ALU_output <= ~ ID_rA_data[0:63];

			4b'0100: 	// VMOV
				2'11 : ALU_output <= ID_rA_data[0:63];

			4b'0101: 	// VADD
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
					2'01 : 	WW = 16;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
					2'10 : 	WW = 32;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
					2'11 : 	WW = 64;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ID_rB_data[i:i+(WW-1)];
					default: ALU_output <= 0;
				endcase

			4b'0110: 	// VSUB
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
					2'01 : 	WW = 16;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
					2'10 : 	WW = 32;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
					2'11 : 	WW = 64;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  ID_rA_data[i:i+(WW-1)] + ~ID_rB_data[i:i+(WW-1)] + 1;
					default: ALU_output <= 0;
				endcase

			4b'0111: 	// VMULEU
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i:i+(WW-1)] * ID_rB_data[i:i+(WW-1)];
					2'01 : 	WW = 16;
							for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i:i+(WW-1)] * ID_rB_data[i:i+(WW-1)];
					2'10 : 	WW = 32;
							for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i:i+(WW-1)] * ID_rB_data[i:i+(WW-1)];
					default: ALU_output <= 0;
				endcase

			4b'1000:	// VMULOU
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i+WW:i+(2*WW-1)] * ID_rB_data[i+WW:i+(2*WW-1)];
					2'01 : 	WW = 16;
							for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i+WW:i+(2*WW-1)] * ID_rB_data[i+WW:i+(2*WW-1)];
					2'10 : 	WW = 32;
							for(i=0; i<63-WW*2; i=i+2*WW) ALU_output[i:i+(2*WW-1)] <=  ID_rA_data[i+WW:i+(2*WW-1)] * ID_rB_data[i+WW:i+(2*WW-1)];
					default: ALU_output <= 0;
				endcase

			4b'1001:	// VRRTH
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
					2'01 : 	WW = 16;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
					2'10 : 	WW = 32;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
					2'11 : 	WW = 64;
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+WW/2:i+(WW-1)], ID_rA_data[i:i+(WW/2-1)]};
					default: ALU_output <= 0;
				endcase

			4b'1010:	// VSLL
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							bit = 3;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+WW-bit:i+WW-1];
								ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
							end
					2'01 : 	WW = 16;
							bit = 4;										
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+WW-bit:i+WW-1];
								ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
							end
					2'10 : 	WW = 32;
							bit = 5;										
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+WW-bit:i+WW-1];
								ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
							end
					2'11 : 	WW = 64;
							bit = 6;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+WW-bit:i+WW-1];
								ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
							end
					default: ALU_output <= 0;
				endcase

			4b'1011:	// VSLLi
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							bit = 3;
							s = ID_rB_data[63-bit:63];  // put the shift amount at rB[59:63]
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
					2'01 : 	WW = 16;
							bit = 4;
							s = ID_rB_data[63-bit:63]; 
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
					2'10 : 	WW = 32;
							bit = 5;
							s = ID_rB_data[63-bit:63]; 
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
					2'11 : 	WW = 64;
							bit = 5;
							s = ID_rB_data[63-bit:63];
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {ID_rA_data[i+s:i+(WW-1)], s{0}};
					default: ALU_output <= 0;
				endcase

			4b'1100:	// VSRL
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							bit = 3;								
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
							end
					2'01 : 	WW = 16;
							bit = 4;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
							end
					2'10 : 	WW = 32;
							bit = 5;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
							end										
					2'11 : 	WW = 64;
							bit = 6;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
							end										
					default: ALU_output <= 0;
				endcase

			4b'1101:	// VSRLi
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							bit = 3;
							s = ID_rB_data[63-bit:63];  // put the shift amount at rB[59:63]
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
					2'01 : 	WW = 16;
							bit = 4;
							s = ID_rB_data[63-bit:63]; 
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
					2'10 : 	WW = 32;
							bit = 5;
							s = ID_rB_data[63-bit:63]; 
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
					2'11 : 	WW = 64;
							bit = 5;
							s = ID_rB_data[63-bit:63];
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{0}, ID_rA_data[i:i+(WW-s-1)]};
					default: ALU_output <= 0;
				endcase

			4b'1110:	// VSRA
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							bit = 3;								
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
							end
					2'01 : 	WW = 16;
							bit = 4;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
							end
					2'10 : 	WW = 32;
							bit = 5;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
							end										
					2'11 : 	WW = 64;
							bit = 6;
							for(i=0; i<63-WW; i=i+WW) begin
								s = ID_rB_data[i+(WW-bit):i+(WW-1)];
								ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
							end										
					default: ALU_output <= 0;
				endcase

			4b'1111:	// VSRAi
				case(PPPWW[3:4])
					2'00 : 	WW = 8;
							bit = 3;
							s = ID_rB_data[63-bit:63];  // put the shift amount at rB[59:63]
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
					2'01 : 	WW = 16;
							bit = 4;
							s = ID_rB_data[63-bit:63]; 
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
					2'10 : 	WW = 32;
							bit = 5;
							s = ID_rB_data[63-bit:63]; 
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
					2'11 : 	WW = 64;
							bit = 5;
							s = ID_rB_data[63-bit:63];
							for(i=0; i<63-WW; i=i+WW) ALU_output[i:i+(WW-1)] <=  {s{ID_rA_data[i]}, ID_rA_data[i:i+(WW-s-1)]};
					default: ALU_output <= 0;
				endcase
