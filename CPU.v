cardinal_processor (clk, reset, instruction, dataIn, pc, dataOut, memAddr, memEn, memWrEn);           


input clk 			// System Clock
input reset 		// System Reset
input reg [0:31] instruction  // Instruction from Instruction Memory
input [0:63] dataIn       // Data from Data Memory
output [0:31] pc           // Program Counter
output reg [0:63] dataOut      // Write Data to Data Memory
output reg [0:31] memAddr      // Write Address for Data Memory 
output memEn        // Data Memory Enable
output memWrEn      // Data Memory Write Enable

wire WB_en, ALU_enable, ID_wmem_en, ID_wb_en;
wire[0:4] WB_rD, WB_PPPWW, ID_rD, ID_PPPWW, ALU_rD, ALU_PPPWW;
wire[0:5] ID_function_bit, 
wire[0:63] WB_data, ALU_output, ID_rA_data, ID_rB_data;


IF_stage IF_block (.clk(clk), .rst(reset), .pc(pc));

ID_stage ID_block (.clk(clk), .rst(reset), .IF_instruction(instruction), .ID_function_bit(ID_function_bit), .ID_rD(ID_rD),
 	.ID_PPPWW(ID_PPPWW), .ID_rA_data(ID_rA_data), .ID_rB_data(ID_rB_data), .ID_wb_en(ID_wb_en), .ID_wmem_en(ID_wmem_en));

ALU_stage ALU_block (.clk(clk), .reset(reset), .ALU_enable(ID_wb_en), .ID_function_bit(ID_function_bit), .ID_rD(ID_rD), .ID_PPPWW(ID_PPPWW),
 	.ID_rA_data(ID_rA_data), .ID_rB_data(ID_rB_data), .ALU_output(ALU_output), .ALU_PPPWW(ALU_PPPWW), .ALU_rD(ALU_rD));

WB_stage WB_block (.clk(clk), .rst(reset), .WB_en(ID_wb_en), .WB_rD(ALU_rD), .WB_PPPWW(ALU_PPPWW), .WB_data(WB_data));

	always@(*)begin
		if(ID_function_bit[0:1]==2'b01) WB_data <= dataIn;
		else WB_data <= ALU_output;
	end

	assign dataOut = ID_rA_data;
	assign memAddr = {16'b0, ID_rB_data[48:63]};
	assign memEn = ID_wb_en;
	assign memWrEn = ID_wmem_en;
