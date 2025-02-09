module Mux2to1_5(
    // 输入信号
    input [4:0] dataA,  // 5 位输入信号 A
    input [4:0] dataB,  // 5 位输入信号 B
    input sign,          // 选择信号（1 或 0）

    // 输出信号
    output wire [4:0] Odata  // 5 位输出信号
);

// 根据选择信号 sign 选择输出数据
// 如果 sign 为 1，则输出 dataA；否则输出 dataB
assign Odata = sign ? dataA : dataB;

endmodule
