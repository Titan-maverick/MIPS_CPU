// 执行算术和逻辑操作（如加法、减法、与、或等），并生成计算结果
module ALU(
    input clk,                // 时钟信号
    input CLK_1,              // 第二时钟信号，实际未使用
    input alu_src_a,            // ALU操作数A的选择控制信号
    input alu_src_b,            // ALU操作数B的选择控制信号
    input [31:0] read_data_1,   // 数据输入端口1（通常是rs寄存器的值）
    input [31:0] read_data_2,   // 数据输入端口2（通常是rt寄存器的值）
    input [4:0] shift_amount,           // 移位操作中的移位量
    input [31:0] immediate_extend,      // 扩展数据，通常用于立即数扩展
    input [4:0] alu_operation,        // ALU操作的控制信号（5位，确定具体的ALU操作）
    output reg zero_flag,          // 输出零标志，当结果为零时为1
    output reg [31:0]computation_result // ALU运算结果
);

	// 内部寄存器定义
	 reg [31:0] A;
	 reg [31:0] B;
	 reg [63:0] extresult;
	 reg [31:0] resulthi;
	 reg [31:0] resultlo;
  	 initial begin
		 resulthi<=0;
		 resultlo<=0;
		 extresult<=0;
	 end

	// 在时钟的下降沿触发ALU操作	 
	always@(negedge CLK_1)
	if(clk)
	begin
		// 根据alu_src_a和alu_src_b的值选择操作数A和B
        A = (alu_src_a == 0) ? read_data_1 : shift_amount;  // A选择：read_data_1（寄存器数据）或shift_amount（移位量）
        B = (alu_src_b == 0) ? read_data_2 : immediate_extend;  // B选择：read_data_2（寄存器数据）或immediate_extend（立即数扩展）

        // 根据alu_operation的值执行不同的算术/逻辑操作
        case (alu_operation)
            // 1. add
            5'b00001: begin
               computation_result= A + B;  // 加法
            end
            // 2. and
            5'b00010: begin
               computation_result= A & B;  // 位与运算
            end
            // 3. nor
            5'b00011: begin
               computation_result= ~(A | B);  // 位或取反（NOR）
            end
            // 4. or
            5'b00100: begin
               computation_result= A | B;  // 位或运算
                zero_flag = (computation_result == 0) ? 1 : 0;  // 如果结果为0，则zero_flag标志为1
            end
            // 5. slt (Set Less Than)
            5'b00101: begin
               computation_result= (A < B) ? 1 : 0;  // 如果A小于B，返回1，否则返回0
            end
            // 6. sll (Shift Left Logical)
            5'b00110: begin
               computation_result= B << shift_amount;  // B左移shift_amount位
            end
            // 7. srl (Shift Right Logical)
            5'b00111: begin
               computation_result= B >>> shift_amount;  // B右移shift_amount位（逻辑右移）
            end
            // 8. sub
            5'b01000: begin
               computation_result= A - B;  // 减法
            end
            // 9. div (除法)
            5'b01001: begin
                resulthi = A / B;  // 除法商
                resultlo = A % B;  // 除法余数
            end
            // 10. mfhi (Move from HI)
            5'b01010: begin
               computation_result= resulthi;  // 从HI寄存器获取结果（商）
            end
            // 11. mflo (Move from L0)
            5'b01011: begin
               computation_result= resultlo;  // 从寄存器0获取结果（余数）
            end
            // 12. mult (乘法)
            5'b01100: begin
                extresult = A * B;  // 乘法
                resulthi = extresult[63:32];  // 高32位结果
                resultlo = extresult[31:0];  // 低32位结果
                computation_result= extresult[31:0];  // 返回低32位结果
            end
            // 13. sra (Shift Right Arithmetic)
            5'b01101: begin
               computation_result= B >> shift_amount;  // 算术右移
            end
            // 14. addi (加法立即数)
            5'b01110: begin
               computation_result= A + B;  // 加法，B为立即数
            end
            // 15. bne (Branch Not Equal)
            5'b01111: begin
               computation_result= A - B;  // 减法，判断是否不相等
            end
            // 16. lw (Load Word)
            5'b10000: begin
               computation_result= A + B;  // 加法，计算地址
            end
            // 17. sw (Store Word)
            5'b10001: begin
               computation_result= A + B;  // 加法，计算地址
            end
            // 18. 中断（全亮）
            5'b10010: begin
               computation_result= 32'b11111111111111111111111111111111;  // 全为1
            end
            // 21. addu (加法无符号)
            5'b10101: begin
               computation_result= A + B;  // 无符号加法
            end
            // 22. xor (异或)
            5'b10110: begin
               computation_result= A ^ B;  // 位异或运算
            end
            // 23. bltz (Branch on Less Than Zero)
            5'b10111: begin
                if (A < 0)  // 如果A小于0
                   computation_result= 0;  // 设置结果为0
                else  // 如果A大于等于0
                   computation_result= 1;  // 设置结果为1
            end
            // 24. bgez (Branch on Greater or Equal to Zero)
            5'b11000: begin
                if (A < 0)  // 如果A小于0
                   computation_result= 0;  // 设置结果为0
                else  // 如果A大于等于0
                   computation_result= 1;  // 设置结果为1
            end
            // 25. beq (Branch Equal)
            5'b11001: begin
               computation_result= A - B;  // 减法，判断是否相等
            end
            // 26. slti (Set Less Than Immediate)
            5'b11010: begin
               computation_result= (A < B) ? 1 : 0;  // 如果A小于B，返回1，否则返回0
            end
            // 27. ori (OR Immediate)
            5'b11011: begin
               computation_result= A | B;  // 位或运算
            end
        endcase
		  
		  // 根据运算结果判断zero_flag标志位，结果为零时设置为1
        zero_flag = (computation_result == 0) ? 1 : 0;
	end
endmodule
