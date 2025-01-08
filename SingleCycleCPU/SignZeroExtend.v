timescale 1ns / 1ps
module SignZeroExtend(
    input wire [15:0] immediate,  // 输入的16位立即数
    input wire Exsel,             // 控制信号，决定扩展方式
    output reg [31:0] extendImmediate // 输出的32位扩展立即数
);

always @(*) begin
    // 输出当前扩展结果的高位
    $display("%d", extendImmediate[31]); 

    // 进行符号扩展或零扩展
    extendImmediate[15:0] = immediate; // 将输入立即数的低16位赋值
    if (Exsel) begin
        // 如果Exsel为1，进行符号扩展
        extendImmediate[31:16] = immediate[15] ? 16'hFFFF : 16'h0000;
    end else begin
        // 否则进行零扩展
        extendImmediate[31:16] = 16'h0000;
    end
end

endmodule
