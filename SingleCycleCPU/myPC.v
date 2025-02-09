module myPC(
    input clk,           // 时钟信号，用于触发时序操作
    input reset,         // 复位信号，当为低电平时，清零当前 PC 值
    input Pcwre,         // PC 写使能信号，控制是否更新 PC
    input [31:0] nextPc, // 下一个 PC 的值，用于跳转到下一个地址
    output reg [31:0] curPc // 当前 PC 值，用于存储当前的程序计数器地址
);

always@(posedge clk or negedge reset)
begin
    if(!reset) // 如果复位信号为低电平，清空当前 PC
    begin
        curPc <= 0;  // 将当前 PC 设置为 0
    end
    else
    begin
        // 如果 Pcwre 为 1，则更新 PC 值为 nextPc+4
        // 否则保持当前的 PC 不变
        if(Pcwre)
            curPc <= nextPc + 4;  // 设置当前 PC 为下一个地址（nextPc），并加上 4
        else
            curPc <= curPc;  // 如果 Pcwre 为 0，保持当前 PC 不变
    end
end

endmodule
