module ControlUnit(
    input [5:0] op,    // 输入操作码 (op)，6位
    input [5:0] func,  // 输入功能码 (func)，6位
    
    output reg [4:0] ALUOp,  // ALU 操作码，5位
    
    output reg jump,       // J型指令的跳转控制信号
    output reg Branch,     // 分支指令控制信号
    // 控制信号
    output reg Memwre,     // 存储器写使能信号
    output reg Memread,    // 存储器读使能信号
    output reg Regwre,     // 寄存器写使能信号
    // 选择信号
    output reg ALUsrc,     // ALU操作数来源选择，0表示从寄存器读取，1表示从立即数读取
    output reg RegDst,     // 寄存器选择信号，0表示写入rd寄存器，1表示写入rt寄存器
    output reg MemtoReg,   // 存储器数据写入寄存器还是ALU结果写入寄存器
    output reg Pcwre       // 程序计数器写使能信号，0表示停机，1表示不停机
);

// 根据输入的op和func信号控制各个输出信号
always @(op or func) begin
    // 判断是否是JUMP指令（op=6'b000010）
    jump = (op == 6'b000010) ? 1 : 0;

    // 判断是否是分支指令，BEQ (op=6'b000100) 或 BNE (op=6'b000101)
    Branch = (op == 6'b000100 || op == 6'b000101) ? 1 : 0;

    // 判断是否是存储器写指令 (sw)，即op为6'b101011
    Memwre = (op == 6'b101011) ? 1 : 0;

    // 判断是否是存储器读指令 (lw, sw)，op为6'b100011或6'b101010
    Memread = (op == 6'b100011 || op == 6'b101010) ? 1 : 0;

    // 判断是否需要写寄存器，R型指令 (op=6'b000000)，lw指令 (op=6'b100011)，addi指令 (op=6'b001000)
    Regwre = (op == 6'b000000 || op == 6'b100011 || op == 6'b001000 || op == 6'b101010) ? 1 : 0;

    // ALUsrc选择信号，判断是否是从寄存器读取或立即数扩展
    ALUsrc = (op == 6'b000000 || op == 6'b000100 || op == 6'b000101) ? 1 : 0;

    // RegDst选择信号，判断是否是R型指令，如果是，寄存器写入rd，否则写入rt
    RegDst = (op == 6'b000000) ? 0 : 1;

    // MemtoReg选择信号，lw指令和sw指令时需要从存储器读取数据，否则从ALU结果中写入
    MemtoReg = (op == 6'b100011 || op == 6'b101010) ? 1 : 0;

    // Pcwre控制信号，判断是否停机，op为6'b111111时停机
    Pcwre = (op == 6'b111111) ? 0 : 1;

    // R型指令（op为6'b000000）的具体操作
    if (op == 6'b000000) begin
        case (func)
            6'b100000: ALUOp = 5'b00000; // sll (逻辑左移)
            6'b100001: ALUOp = 5'b00001; // sra (算术右移)
            6'b100010: ALUOp = 5'b00010; // srl (逻辑右移)
            6'b100011: ALUOp = 5'b00011; // 加法
            6'b100100: ALUOp = 5'b00100; // 减法
            6'b100101: ALUOp = 5'b00101; // 按位与
            6'b100110: ALUOp = 5'b00110; // 按位或
            6'b100111: ALUOp = 5'b00111; // 按位异或
            6'b101000: ALUOp = 5'b01000; // 按位取反
            6'b101001: ALUOp = 5'b01001; // 小于
            6'b101010: ALUOp = 5'b01010; // 无符号小于
            6'b101011: ALUOp = 5'b01011; // 保留
            6'b101100: ALUOp = 5'b01100; // 保留
            6'b101101: ALUOp = 5'b01101; // 乘法
            6'b101110: ALUOp = 5'b01110; // 除法
        endcase
    end else begin
        // 非R型指令（例如：BEQ，BNE，lw，sw，addi等）
        case (op)
            6'b000100: ALUOp = 5'b00100; // BEQ，执行减法并检查是否为0
            6'b000101: ALUOp = 5'b01111; // BNE，不相等跳转
            6'b100011: ALUOp = 5'b00011; // lw，计算地址并读取数据
            6'b101011: ALUOp = 5'b00011; // sw，计算地址并存储数据
            6'b001000: ALUOp = 5'b00011; // addi，执行加法
        endcase
    end
end

endmodule
