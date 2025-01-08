module InstructionCut(
    input myreset,                  // 复位信号，未使用
    input [31:0] Inst,              // 输入的32位指令
    output reg [5:0] OP,            // 操作码 (Opcode)，6位
    output reg [5:0] FUNC,          // 功能码 (Function code)，6位
    output reg [4:0] SHMAT,         // 移位量 (Shift amount)，5位
    output reg [4:0] RS,            // 源寄存器 (Source Register)，5位
    output reg [4:0] RT,            // 目标寄存器 (Target Register)，5位
    output reg [4:0] RD,            // 结果寄存器 (Destination Register)，5位
    output reg [15:0] IMME,         // 立即数 (Immediate)，16位
    output reg [25:0] ADDR          // 地址 (Address)，26位 (用于J型指令)
);

always@(Inst)
begin
    // 指令解析
    // 提取操作码、寄存器、移位量、功能码、立即数和地址

    // R型指令: OP + RS + RT + RD + SHAMT + FUNC
    OP = Inst[31:26];       // 提取操作码 OP
    RS = Inst[25:21];       // 提取源寄存器 RS
    RT = Inst[20:16];       // 提取目标寄存器 RT
    RD = Inst[15:11];       // 提取结果寄存器 RD
    SHMAT = Inst[10:6];     // 提取移位量 SHAMT
    FUNC = Inst[5:0];       // 提取功能码 FUNC

    // I型指令: OP + RS + RT + IMME
    IMME = Inst[15:0];      // 提取立即数 IMME

    // J型指令: OP + ADDR
    ADDR = Inst[25:0];      // 提取地址 ADDR

end

endmodule
