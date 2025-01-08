module Add(
    input [31:0] DataA,     // 输入数据A，32位宽度
    input [31:0] DataB,     // 输入数据B，32位宽度
    output reg [31:0] sum   // 输出和，32位宽度
);

    // 在 DataA 或 DataB 发生变化时触发此模块的行为
    always @(DataA or DataB)
    begin
        sum = DataA + DataB;  // 执行加法操作，并将结果存储在 sum 输出中
    end

endmodule
