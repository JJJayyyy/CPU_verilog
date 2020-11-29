`timescale 1ns/10ps

module IF(clk, rst, pc);

input clk, rst;
output [0:31] pc;
wire clk, rst;
reg [0:31] pc;

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