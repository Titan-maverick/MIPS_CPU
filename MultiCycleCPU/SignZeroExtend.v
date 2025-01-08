// 用于对立即数进行符号扩展或零扩展，确保运算时使用正确的数据宽度。
module SignZeroExtend(
    input wire [15:0] immediate_value,  // 16位立即数输入
    input extend_select,                 // 扩展选择信号，'0'表示零扩展，'1'表示符号扩展
    output [31:0] extended_immediate // 扩展后的32位立即数输出
);

	// 在每次 `extended_immediate` 变化时，打印其最高位（符号位或零扩展部分）
	always@(extended_immediate)
	begin
		 $display("%d", extended_immediate[31]);  // 输出扩展后的最高位值
	end
		// 连接立即数的低16位到扩展后的32位的低16位部分
		assign extended_immediate[15:0] = immediate_value;

		// 根据 `extend_select` 的值选择扩展类型
		// 如果 extend_select 为1（符号扩展），则如果原立即数的最高位（immediate_value[15]）为1，则扩展为全1（符号扩展）
		// 如果 extend_select 为0（零扩展），则高16位填充0（零扩展）
		assign extended_immediate[31:16] = extend_select ? (immediate_value[15] ? 16'hffff : 16'h0000) : 16'h0000;

	endmodule
