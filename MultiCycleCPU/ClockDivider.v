// 用于对时钟信号进行分频，产生一个时钟信号 rco，以便分配给其他模块。
module ClockDivider(clk,rco,enable); 
	 // 输入时钟信号clk和使能信号enable
	input clk,enable;
	// 输出信号rco（通常用于频率分频产生周期性信号）
	output rco;
	
	 // 寄存器tmp用于存储计数值
	reg rco;
	reg tmp;
	
	always @(posedge clk or posedge enable)  // 在clk的上升沿或enable的上升沿触发
		if(enable)  // 当enable信号为高时，重置计数器
			begin
				tmp<=0; // 将tmp寄存器清零
				rco<=0; // 将rco寄存器清零
			end
		else
		if (tmp==1)  // 如果计数器tmp的值为1
			begin
				tmp<=0;  // 将tmp清零
				rco<=~rco;  // 反转rco输出信号的值，实现分频
			end
			
		else
			tmp<=tmp+1;  // 否则，tmp计数器加1
endmodule
