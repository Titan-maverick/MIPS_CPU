module EnterInteger(
    input clk,                  // 时钟信号输入
    input [7:0] RandomNumber,   // 8 位随机数输入
    output reg [7:0] OutputRandomNumber // 8 位输出随机数
);

// 在每个时钟上升沿时，将输入的随机数 `RandomNumber` 存储到输出 `OutputRandomNumber`
always @(posedge clk)  // 每当时钟信号 `clk` 上升沿到达时触发
begin
    OutputRandomNumber <= RandomNumber;  // 将输入的随机数赋值给输出变量
end

endmodule
