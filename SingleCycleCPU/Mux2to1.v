module Mux2to1(
    // 输入信号
    input [31:0] DataA,  // 32 位输入信号 A
    input [31:0] DataB,  // 32 位输入信号 B
    input sign,           // 选择信号（1 或 0）

    // 输出信号
    output wire [31:0] OData4  // 32 位输出信号
);

// 根据选择信号 sign 选择输出数据
// 如果 sign 为 1，则输出 DataA；否则输出 DataB
assign OData4 = sign ? DataA : DataB;

endmodule
