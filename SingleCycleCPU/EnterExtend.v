module EnterExtend(
    input [7:0] RandomNumber,  // 8 位随机数输入
    output reg [31:0] outputNumber // 32 位扩展后的输出数
);

// 该模块将 8 位的输入 `RandomNumber` 扩展为 32 位，低 8 位为输入数，其他高 24 位填充为零
always @(RandomNumber)  // 每当 `RandomNumber` 变化时触发
begin
    outputNumber = {24'b0, RandomNumber}; // 将高 24 位设置为 0，低 8 位赋值为 `RandomNumber`
end

endmodule
