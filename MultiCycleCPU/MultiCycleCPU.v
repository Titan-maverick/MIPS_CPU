module MultiCycleCPU(
    input clk_1,                 // 输入时钟信号 CLK1
    input reset,                 // 复位信号
    input enable,                // 启用信号
    input halt_signal,           // 停止信号
    input [3:0] input_signal,   // 输入信号 x
    output wire [2:0] current_state, // 输出当前状态信号
    output [31:0] computation_result, // 计算结果输出
    output [6:0] display_out_1, display_out_2, display_out_3, display_out_4, 
                  display_out_5, display_out_6, display_out_7, display_out_8 // 显示结果输出
);

    // 内部信号定义
    wire clk;                     // 处理器时钟信号
    wire zero_flag;               // ALU的零标志，用于判断运算结果是否为零
    wire pc_write_enable;         // PC写使能信号
    wire show_computation_result; // 控制是否显示计算结果
    wire input_number_select, output_number_select; // 控制输入输出
    wire extend_select;           // 扩展选择信号，用于选择是否进行符号扩展
    wire instruction_mem_rw;      // 指令内存读写信号
    wire register_destination;    // 寄存器写回目标选择信号
    wire register_write_enable;   // 寄存器写使能信号
    wire alu_src_a, alu_src_b;    // ALU输入源选择信号   
    wire memory_read, memory_write; // 数据存储器的读写信号
    wire db_data_source; 	 // 数据总线源选择信号
	 wire [2:0] pc_source;         // PC选择信号，控制跳转或顺序执行
    wire [3:0] input_data;        // 输入信号
	 wire [4:0] rs, rt, rd;        // 寄存器操作数
	 wire [4:0] alu_operation;     // ALU操作码
    wire [4:0] shift_amount;      // 位移量（移位操作时使用）
	 wire [5:0] opcode;            // 操作码
    wire [5:0] function_code;     // 功能码
    wire [15:0] immediate_value;  // 立即数
    wire [25:0] jump_address;     // 跳转地址
	 wire [31:0] immediate_extend; // 扩展的立即数
    wire [31:0] data_memory_out;  // 数据存储器输出
	 wire [31:0] current_pc;       // 当前程序计数器 (PC) 值
    wire [31:0] next_pc;          // 下一个程序计数器 (PC) 值
    wire [31:0] instruction;      // 当前指令
	 wire [31:0] data_bus;         // 数据总线
    wire [31:0] register_a, register_b; // 两个寄存器的值

	    // 输入输出模块，处理外部输入和输出信号
    InputSignal InputSignal_module(
        .input_signal(input_signal), // 输入信号
        .input_number_select(input_number_select), // 输入信号
        .output_number_select(output_number_select), // 输出信号
        .input_data(input_data),     // 输入信号
        .show_computation_result(show_computation_result) // 是否显示计算结果
    );
	 
    // 显示模块，将计算结果输出到显示器
    Display display_module(
        .computation_result(computation_result), // 计算结果
        .display_out_1(display_out_1),           // 显示输出1
        .display_out_2(display_out_2),           // 显示输出2
        .display_out_3(display_out_3),           // 显示输出3
        .display_out_4(display_out_4),           // 显示输出4
        .display_out_5(display_out_5),           // 显示输出5
        .display_out_6(display_out_6),           // 显示输出6
        .display_out_7(display_out_7),           // 显示输出7
        .display_out_8(display_out_8)            // 显示输出8
    );
	 
    // 时钟生成模块，将输入时钟信号转换为处理器时钟
    CLKmode clk_generator(
        .clk_1(rco),            // 输入时钟信号
        .clk(clk)                  // 输出处理器时钟
    );

    // 寄存器文件，存储寄存器的数据
    RegisterFile register_file(
        .clk(clk),                  // 时钟信号
        .read_register_1(rs),       // 读取寄存器1
        .read_register_2(rt),       // 读取寄存器2
        .write_data(data_bus),      // 写入数据
        .write_register(register_destination ? rd : rt), // 寄存器写回目标
        .register_write_enable(register_write_enable), // 寄存器写使能
        .read_data_1(register_a),   // 输出读取寄存器1的值
        .read_data_2(register_b)    // 输出读取寄存器2的值
    );

    // 程序计数器 (PC) 模块，控制程序流
    PC program_counter(
        .clk(clk),                // 时钟信号
        .reset(reset),            // 复位信号
        .pc_write_enable(pc_write_enable), // PC写使能信号
        .pc_source(pc_source),    // PC选择信号
        .next_pc(next_pc),        // 下一个PC值
        .current_pc(current_pc)   // 当前PC值
    );

    // 指令内存模块，从内存中读取指令
    InstructionMemory instruction_memory( 
        .address(next_pc + 4),    // 指令地址，通常是PC + 4
        .instruction_mem_rw(instruction_mem_rw),  // 指令内存读写信号
        .input_data(input_data),  // 输入信号
        .clk(clk_1),              // 时钟信号
        .input_number_select(input_number_select), // 输入信号
        .instruction_data_out(instruction) // 输出指令
    );

    // 指令解码模块，将指令分解为不同的操作字段
    InstructionDecoder instruction_decoder(
        .instruction(instruction), // 输入指令
        .opcode(opcode),           // 操作码
        .rs(rs),                   // 源寄存器1
        .rt(rt),                   // 源寄存器2
        .rd(rd),                   // 目标寄存器
        .shift_amount(shift_amount), // 位移量
        .function_code(function_code), // 功能码
        .immediate_value(immediate_value), // 立即数
        .jump_address(jump_address)  // 跳转地址
    );

	    // 时钟分频模块
    ClockDivider counter_divider(
        .clk(clk_1),              // 输入时钟
        .enable(enable),          // 启用信号
        .rco(rco)                 // 计数器输出
    );
	 
    // 控制单元，负责生成各个控制信号
    ControlUnit control_unit(
        .clk(clk),                // 时钟信号
        .halt_signal(halt_signal),  // 停止信号
        .zero_flag(zero_flag),      // ALU零标志
        .opcode(opcode),            // 操作码
        .function_code(function_code), // 功能码
        .input_number_select(input_number_select), // 输入信号
        .output_number_select(output_number_select), // 输出信号
        .pc_write_enable(pc_write_enable), // PC写使能信号
        .extend_select(extend_select),   // 扩展选择信号
        .instruction_mem_rw(instruction_mem_rw), // 指令内存读写信号
        .register_destination(register_destination), // 寄存器写回目标选择信号
        .register_write_enable(register_write_enable), // 寄存器写使能信号
        .alu_src_a(alu_src_a),        // ALU输入A选择
        .alu_src_b(alu_src_b),        // ALU输入B选择
        .pc_source(pc_source),        // PC选择信号
        .alu_operation(alu_operation), // ALU操作码
        .memory_read(memory_read),    // 数据存储器读信号
        .memory_write(memory_write),  // 数据存储器写信号
        .current_state(current_state), // 当前状态输出
        .db_data_source(db_data_source) // 数据总线源选择信号
    );


    // ALU模块，进行算术和逻辑运算
    ALU alu_module(
        .clk(clk),                  // 时钟信号
		  .CLK_1(rco),               // 时钟信号
        .alu_src_a(alu_src_a),      // ALU输入A选择
        .alu_src_b(alu_src_b),      // ALU输入B选择
        .read_data_1(register_a),   // ALU输入1
        .read_data_2(register_b),   // ALU输入2
        .shift_amount(shift_amount), // 位移量
        .immediate_extend(immediate_extend), // 扩展的立即数
        .alu_operation(alu_operation), // ALU操作码
        .zero_flag(zero_flag),      // ALU零标志
        .computation_result(computation_result) // ALU计算结果
    );

    // PC地址计算模块，用于计算下一个PC的值
    PCAddr  pc_address_module(
        .clk(clk),                  // 时钟信号
        .pc_source(pc_source),      // PC选择信号
        .immediate_value(immediate_extend), // 扩展的立即数
        .jump_address(jump_address), // 跳转地址
        .current_pc(current_pc),    // 当前PC值
        .next_pc(next_pc)           // 下一个PC值
    );

    // 数据存储器模块，负责数据的读取和写入
    DataMemory data_memory(
        .memory_read(memory_read),  // 数据存储器读信号
        .memory_write(memory_write), // 数据存储器写信号
        .clk(clk),                  // 时钟信号
        .db_data_source(db_data_source), // 数据总线源选择信号
        .data_address(computation_result), // 数据地址
        .data_in(register_b),       // 输入数据
        .data_out(data_memory_out), // 输出数据
        .data_bus(data_bus)         // 数据总线
    );

    // 符号扩展模块，用于处理立即数的符号扩展
    SignZeroExtend sign_zero_extend(
        .immediate_value(immediate_value), // 立即数
        .extend_select(extend_select),     // 扩展选择信号
        .extended_immediate(immediate_extend) // 扩展后的立即数
    );




endmodule
