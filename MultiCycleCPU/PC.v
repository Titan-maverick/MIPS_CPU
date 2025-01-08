// 控制程序的流动，决定下一条指令的地址
module PC(
    input clk,                // 输入时钟信号
    input reset,              // 复位信号，0 表示初始化 PC，1 表示接受新地址
    input pc_write_enable,              // PC 写使能信号，1 表示可以更新 PC 地址
    input [2:0] pc_source,        // 控制 PC 地址来源的信号
    input [31:0] next_pc,      // 新的指令地址（下一条指令地址）
    output reg [31:0] current_pc   // 当前指令的地址
);

    // 初始块，仿真开始时将 PC 地址设置为 0
    initial begin
        current_pc <= 0;  // 初始化 PC 地址为 0
    end

    // 时序逻辑块，控制 PC 地址的更新
    always @(posedge clk or negedge reset) begin
        if (!reset) begin  // 如果 reset 信号为低（0），则重置 PC
            current_pc <= 0;     // 重置当前 PC 地址为 0
        end
        else begin
            if (pc_write_enable) begin  // 如果 pc_write_enable 为高（1），则更新 PC 地址
                current_pc <= next_pc + 4;  // 当前 PC 地址设为 next_pc + 4，指向下一条指令
            end
            else begin  // 如果 pc_write_enable 为低（0），PC 地址不更新，保持不变
                current_pc <= current_pc;  // 保持当前 PC 地址不变
            end
        end
    end

endmodule
