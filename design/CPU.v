module cardinal_processor(clk, reset, instruction, dataIn, pc, dataOut, memAddr, memEn, memWrEn);           


input clk; 			// System Clock
input reset; 		// System Reset
input [0:31] instruction;  // Instruction from Instruction Memory
input [0:63] dataIn;       // Data from Data Memory
output [0:31] pc;           // Program Counter
output [0:63] dataOut;      // Write Data to Data Memory
output [0:31] memAddr;      // Write Address for Data Memory 
output memEn;        // Data Memory Enable
output memWrEn;      // Data Memory Write Enable

wire ALU_WB_en, ID_wmem_en, ID_WB_en;
wire[0:63] WB_data, ALU_output;

/*---IF stage---*/
// output: pc
IF IF_block (
	.clk(clk), .rst(reset), 
	.pc(pc));

/*---ID stage---*/
wire[0:63] ID_rA_data, ID_rB_data;
wire[0:5] ID_function_bit, ALU_function_bit;
wire[0:4] WB_rD, WB_PPPWW, ID_rD, ID_PPPWW, ALU_rD, ALU_PPPWW;


ID ID_block (
// output: ID_function_bit, ID_rD, ID_PPPWW, ID_rA_data, ID_rB_data, ID_WB_en, ID_wmem_en
	.clk(clk), .rst(reset), 
	.ALU_WB_en(ALU_WB_en), 
	.WB_rD(ALU_rD), 
	.WB_PPPWW(ALU_PPPWW), 
	.WB_data(WB_data), 
	.IF_instruction(instruction), 
	.ID_function_bit(ID_function_bit), 
	.ID_rD(ID_rD), 
	.ID_PPPWW(ID_PPPWW), 
	.ID_rA_data(ID_rA_data), 
	.ID_rB_data(ID_rB_data), 
	.ID_WB_en(ID_WB_en), 
	.ID_wmem_en(ID_wmem_en));

/*---EXMEM stage---*/
ALU ALU_block (
	.clk(clk), .reset(reset), 
	.ID_function_bit(ID_function_bit), 
	.ID_rD(ID_rD), 
	.ID_PPPWW(ID_PPPWW), 
	.ID_rA_data(ID_rA_data), 
	.ID_rB_data(ID_rB_data), 
	.ID_WB_en(ID_WB_en), 
	.ALU_function_bit(ALU_function_bit), 
	.ALU_output_up(ALU_output), 
	.ALU_PPPWW(ALU_PPPWW), 
	.ALU_rD(ALU_rD), 
	.ALU_WB_en(ALU_WB_en));

assign WB_data = (ALU_function_bit[0:1]==2'b01) ? dataIn : ALU_output;
assign dataOut = ID_rA_data;
assign memAddr = {16'b0, ID_rB_data[48:63]};
assign memEn = 1'b1;
assign memWrEn = ID_wmem_en;

endmodule