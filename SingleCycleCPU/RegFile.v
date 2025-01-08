module RegFile(
    input myreset,         // 复位信号，低电平时清除所有寄存器的内容
    input clk,             // 时钟信号，用于同步更新寄存器
    input Regwre,          // 寄存器写使能信号，当为1时，允许向寄存器写入数据
    input [4:0] Regs,      // 读取寄存器rs地址
    input [4:0] Regt,      // 读取寄存器rt地址
    input [4:0] Regw,      // 写入寄存器地址（可能是rt也可能是rd）
    input [31:0] wdata,    // 写数据，向寄存器中写入的数据

    output [31:0] outputReg1,  // 输出寄存器1的数据
    output [31:0] outputReg2,  // 输出寄存器2的数据
    output [31:0] outputReg3   // 输出寄存器3的数据（寄存器 $2）
);

reg [31:0] Regf[0:31];  // 32个32位寄存器，编号从0到31

// 输出寄存器的值
assign outputReg1 = Regf[Regs];  // 根据寄存器地址Regs，输出对应寄存器的值
assign outputReg2 = Regf[Regt];  // 根据寄存器地址Regt，输出对应寄存器的值
assign outputReg3 = Regf[2];     // 输出寄存器 $2 的值（即 $v0）

integer i;  // 整数变量用于循环初始化寄存器

// 寄存器初始化，复位时所有寄存器值设为0
initial begin
    for(i = 0; i < 32; i = i + 1) begin
        Regf[i] = 0;  // 初始化每个寄存器的值为0
    end
end

// 时钟上升沿触发的寄存器写入和复位逻辑
always @(posedge clk) begin
    // 当Regwre为1且Regw不为0时，将wdata写入到寄存器Regf[Regw]中
    if (Regwre && Regw != 0) begin
        Regf[Regw] = wdata;  // 写入寄存器
    end

    // 如果myreset为1，则复位所有寄存器的内容为0
    if (myreset) begin
        for(i = 0; i < 32; i = i + 1) begin
            Regf[i] = 0;  // 清除所有寄存器的值
        end
    end
end

endmodule
