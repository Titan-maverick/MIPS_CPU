module sMUX2to1(
    input [4:0] True,      // 输入 True，当选择信号为 1 时输出该值
    input [4:0] Fales,     // 输入 Fales，当选择信号为 0 时输出该值
    input Sign,            // 选择信号，当 Sign 为 1 时选择 True，否则选择 Fales
    output wire [4:0] Get  // 输出选择的 5 位数据
);

assign Get = Sign ? True : Fales;  // 使用条件操作符根据 Sign 值选择输出 True 或 Fales

endmodule
