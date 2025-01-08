// 指令分割模块，解析输入的指令并提取各个字段
module InstructionDecoder(
    input [31:0] instruction,  // 输入指令，32位
    output reg [5:0] opcode,       // 操作码，指令的高6位
    output reg [4:0] rs,       // 源寄存器，指令的第6到第10位
    output reg [4:0] rt,       // 目标寄存器，指令的第11到第15位
    output reg [4:0] rd,       // 目标寄存器，指令的第16到第20位
    output reg [4:0] shift_amount,       // 移位量，指令的第21到第25位
    output reg [5:0] function_code,    // 功能码，指令的低6位
    output reg [15:0] immediate_value, // 立即数，指令的第16到第31位
    output reg [25:0] jump_address      // 地址字段，指令的第6到第31位
);

    // 每当输入的指令发生变化时，解析该指令的各个字段
    always @(instruction) begin
        opcode = instruction[31:26];           // 提取操作码，指令的高6位
        rs = instruction[25:21];           // 提取源寄存器，指令的第6到第10位
        rt = instruction[20:16];           // 提取目标寄存器，指令的第11到第15位
        rd = instruction[15:11];           // 提取目标寄存器，指令的第16到第20位
        shift_amount = instruction[10:6];            // 提取移位量，指令的第21到第25位
        function_code = instruction[5:0];          // 提取功能码，指令的低6位
        immediate_value = instruction[15:0];     // 提取立即数，指令的低16位
        jump_address = instruction[25:0];          // 提取地址字段，指令的第6到第31位
    end

endmodule
