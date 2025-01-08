module MyAdd(
    input [31:0] A,          // 输入的 32 位 A 操作数
    input [31:0] B,          // 输入的 32 位 B 操作数
    output reg [31:0] sum    // 输出的 32 位和
);

    // 每当 A 或 B 改变时，计算它们的和
    always @(A or B)
    begin
        sum = A + B;         // 将 A 和 B 相加并赋值给 sum
    end

endmodule
