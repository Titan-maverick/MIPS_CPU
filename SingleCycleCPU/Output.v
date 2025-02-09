module Output( 
    input [31:0] result,   // 32位输入数据
    output reg [6:0] out1, // 七段显示器1
    output reg [6:0] out2, // 七段显示器2
    output reg [6:0] out3, // 七段显示器3
    output reg [6:0] out4, // 七段显示器4
    output reg [6:0] out5, // 七段显示器5
    output reg [6:0] out6, // 七段显示器6
    output reg [6:0] out7, // 七段显示器7
    output reg [6:0] out8  // 七段显示器8
);

// 内部寄存器，用于存储每一位的十进制数字
reg [3:0] digit [7:0];  // 存储千万位到个位的数字
reg [31:0] temp;        // 临时变量存储输入数据

// 十进制数字转换为七段显示格式的函数
function [6:0] binToSeg;
    input [3:0] num;
    begin
        case (num)
            4'd0: binToSeg = 7'b1000000;
            4'd1: binToSeg = 7'b1111001;
            4'd2: binToSeg = 7'b0100100;
            4'd3: binToSeg = 7'b0110000;
            4'd4: binToSeg = 7'b0011001;
            4'd5: binToSeg = 7'b0010010;
            4'd6: binToSeg = 7'b0000010;
            4'd7: binToSeg = 7'b1111000;
            4'd8: binToSeg = 7'b0000000;
            4'd9: binToSeg = 7'b0010000;
            default: binToSeg = 7'b1111111; // 默认关闭
        endcase
    end
endfunction

// 总是块
always @(*) begin
    // 初始化数字寄存器，默认值为0
    digit[0] = 4'd0;
    digit[1] = 4'd0;
    digit[2] = 4'd0;
    digit[3] = 4'd0;
    digit[4] = 4'd0;
    digit[5] = 4'd0;
    digit[6] = 4'd0;
    digit[7] = 4'd0;

    // 将32位输入数据转换为十进制数字，并拆解成每一位
    temp = result;         // 将输入数据赋值给临时变量
    digit[7] = temp / 10000000; // 千万位数字
    temp = temp % 10000000;  // 获取剩余部分
    digit[6] = temp / 1000000; // 百万位数字
    temp = temp % 1000000;   // 获取剩余部分
    digit[5] = temp / 100000; // 十万位数字
    temp = temp % 100000;    // 获取剩余部分
    digit[4] = temp / 10000; // 万位数字
    temp = temp % 10000;     // 获取剩余部分
    digit[3] = temp / 1000;  // 千位数字
    temp = temp % 1000;      // 获取剩余部分
    digit[2] = temp / 100;   // 百位数字
    temp = temp % 100;       // 获取剩余部分
    digit[1] = temp / 10;    // 十位数字
    digit[0] = temp % 10;    // 个位数字

    // 将每一位的数字转换为七段显示器格式
    out1 = binToSeg(digit[0]); // 个位数
    out2 = binToSeg(digit[1]); // 十位数
    out3 = binToSeg(digit[2]); // 百位数
    out4 = binToSeg(digit[3]); // 千位数
    out5 = binToSeg(digit[4]); // 万位数
    out6 = binToSeg(digit[5]); // 十万位数
    out7 = binToSeg(digit[6]); // 百万位数
    out8 = binToSeg(digit[7]); // 千万位数
end

endmodule
