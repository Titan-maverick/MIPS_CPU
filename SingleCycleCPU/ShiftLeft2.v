module ShiftLeft2(
    // 输入信号
    input [31:0] datain,       // 输入的 32 位数据

    // 输出信号
    output reg [31:0] dataout  // 输出的 32 位数据
);

always @(datain)
begin
    // 对输入数据进行左移 2 位操作
    dataout[31:2] = datain[29:0];  // 将输入数据的低 30 位赋给输出数据的高 30 位
    dataout[1:0] = 2'b00;           // 将输出数据的低 2 位置为 00（相当于左移时补零）
end

endmodule
