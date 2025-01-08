module RegisterGroup(
    input Wren,                // 写使能信号，当为 1 时允许写入寄存器
    input Clk,                 // 时钟信号
    input [4:0] Regs,          // 读寄存器地址1（5 位，用于选择寄存器组中的一个寄存器）
    input [4:0] Regt,          // 读寄存器地址2（5 位，用于选择寄存器组中的另一个寄存器）
    input [4:0] Regw,          // 写寄存器地址（5 位，用于选择要写入数据的寄存器）
    input [31:0] wBus,         // 要写入寄存器的数据（32 位）
    output [31:0] outputReg1,  // 从寄存器 Regs 中读取的 32 位数据
    output [31:0] outputReg2   // 从寄存器 Regt 中读取的 32 位数据
);

    // 定义一个 32 个 32 位寄存器的数组
    reg [31:0] innerReg[0:31];

    // 寄存器的初始化，所有寄存器初始值为 0
    integer index;
    initial
    begin
        for(index = 0; index < 32; index = index + 1)
            innerReg[index] <= 0;
    end

    // 输出寄存器数据
    assign outputReg1 = innerReg[Regs];   // 根据 Regs 地址输出对应寄存器的数据
    assign outputReg2 = innerReg[Regt];   // 根据 Regt 地址输出对应寄存器的数据

    // 在时钟上升沿时进行写操作
    always@(posedge Clk)
    begin
        // 寄存器 0（$zero）永远为 0，不能写入
        if (Wren && Regw != 0)  // 如果写使能信号为 1 且目标寄存器地址不为 0
        begin
            innerReg[Regw] <= wBus;  // 将 wBus 的值写入 Regw 寄存器
        end
    end
endmodule
