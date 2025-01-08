module Extend(
    input [15:0] imme,           // 16 位立即数输入
    output reg [31:0] extendImme // 32 位扩展后的立即数输出
);

// 该模块用于将 16 位立即数 `imme` 扩展为 32 位，执行符号扩展操作
always @(imme)  // 每当 `imme` 变化时触发
begin
    extendImme[15:0] = imme; // 将 16 位立即数直接赋值给 `extendImme` 的低 16 位

    // 如果立即数的最高位（即符号位）为 1，表示负数，进行符号扩展
    if (imme[15] == 1) 
    begin
        extendImme[31:16] = 16'hFFFF; // 高 16 位赋值为 1，表示负数扩展
    end
    else
    begin
        extendImme[31:16] = 16'h0000; // 高 16 位赋值为 0，表示正数扩展
    end
end

endmodule
