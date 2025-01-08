// PC地址生成模块，用于控制程序计数器（PC）在不同操作下的跳转地址
module PCAddr(
	input clk,
	input [2:0] pc_source,
	input [31:0] immediate_value,
	input [25:0] jump_address,
	input [31:0] current_pc,
	output reg [31:0] next_pc
);

	reg [31:0] stayPC;//记录中断时当前指令地址
	initial begin
	next_pc <= 0;
	end

always @(negedge clk) 
begin
	if (pc_source==0) next_pc<=current_pc;
	else if (pc_source==1) begin next_pc<=current_pc+immediate_value*4; end 
	
	
	else if(pc_source==3)//中断
		begin
			stayPC<=current_pc;
			next_pc<=44;
		end
	else if(pc_source==4)//关中断
		begin
			next_pc<=stayPC;
		end
end


endmodule
