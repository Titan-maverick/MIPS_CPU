//用于将输入的时钟信号转换为 CPU 需要的时钟信号
module CLKmode(  
    input clk_1,    // 输入时钟信号 CLK_1
    output reg clk  // 输出时钟信号 CLK
);

    // 初始化块，在仿真开始时将 CLK 设置为 0
    initial begin
        clk = 0;   // 初始化时钟信号为 0
    end

    // 时钟反转逻辑：每当输入时钟 CLK_1 上升沿到来时，反转输出时钟 CLK
    always @(posedge clk_1) begin
        clk = ~clk;  // 反转输出时钟 CLK
    end

endmodule
