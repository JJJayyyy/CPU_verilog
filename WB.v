
module WB_stage(clk, rst, WB_en, WB_rD, WB_PPPWW, WB_data);

input WB_en;
input [0:4] WB_rD;
input [0:4] WB_PPPWW;
input [0:64] WB_data;

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
		if(WB_en==1 && WB_rD!=5'b00000)
		begin
			case(WB_PPPWW[0:2])
				3'b000 :
					Register[WB_rD] <= WB_data;
				3'b001 : 
					Register[WB_rD][32:63] <= WB_data[32:63];
				3'b010 : 
					Register[WB_rD][0:31] <= WB_data[0:31];
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
