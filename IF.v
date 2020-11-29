`timescale 1ns/10ps
`include "imem.v"

module IF(clk, rst, IF_instruction);

input clk, rst;
output [0:31] IF_instruction;
wire clk, rst;
reg [0:31] IF_instruction;
reg [0:31] pc;

imem imem1 (.memAddr(pc[0:8]), .dataOut(IF_instruction));

always @(posedge clk)
begin
	if(rst == 1)
	begin
		pc <= 0;
	end
	else
	begin
		pc <= pc + 4;
	end
end

endmodule