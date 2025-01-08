module MyALU(
    // 输入信号
    input [31:0] ReadData1,  // 数据 A
    input [31:0] ReadData2,  // 数据 B
    input [4:0] sa,          // 移动的位数，用于移位操作
    input [4:0] ALUOp,       // 控制信号，确定执行的运算类型

    // 输出信号
    output reg zero,         // 零标志位，表示结果是否为零
    output reg [31:0] result // ALU 运算结果
);

reg [31:0] A;  // 临时存储输入数据 A
reg [31:0] B;  // 临时存储输入数据 B

always @(ReadData1 or ReadData2 or ALUOp or sa)
begin
    // 将输入数据赋给临时变量 A 和 B
    A = ReadData1;
    B = ReadData2;

    // 根据 ALUOp 的值选择执行的运算类型
    case (ALUOp)
        // sll (逻辑左移)
        5'b00000:
            result = B << sa;

        // sra (算术右移)
        5'b00001:
            result = B >> sa;

        // srl (逻辑右移)
        5'b00010:
            result = B >>> sa;

        // add (加法)
        5'b00011:
            result = A + B;

        // sub (减法)
        5'b00100:
            result = A - B;

        // and (按位与)
        5'b00101:
            result = A & B;

        // or (按位或)
        5'b00110:
            result = A | B;

        // xor (按位异或)
        5'b00111:
            result = A ^ B;

        // ~| (按位或的按位取反)
        5'b01000:
            result = ~(A | B);

        // sltu (无符号小于比较)
        5'b01001:
            result = (A < B) ? 1 : 0;

        // slt (有符号小于比较)
        5'b01010:
            if (A[31] == B[31])  // 如果符号位相同，进行无符号比较
                result = (A < B) ? 1 : 0;
            else
                result = A[31];  // 如果符号位不同，结果由符号位决定

        // bne (不等于，跳转判断)
        5'b01111:
            result = A - B;

        // 乘法操作
        5'b01101:
            result = A * B;

        // 默认情况
        default:
            result = 0;
    endcase

    // 根据 ALU 运算结果更新零标志位
    // 如果执行的是 bne 指令（ALUOp 为 5'b01111），
    // 只有当 result 不为 0 时 zero 为 1，表示不等
    if (ALUOp == 5'b01111)
        zero = (result == 0) ? 0 : 1;
    else
        zero = (result == 0) ? 1 : 0; // 其他运算如果结果为 0，zero 为 1，表示等于
end

endmodule
