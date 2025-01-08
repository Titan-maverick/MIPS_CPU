module ROM1P (
    address,    // 输入：指令存储器地址，5 位地址
    clock,      // 输入：时钟信号
    q           // 输出：32 位数据，从 ROM 中读取的指令
);

    input [4:0] address;   // 5 位地址输入，用于指示要访问的内存位置
    input clock;            // 时钟信号，用于同步 ROM 操作
    output [31:0] q;        // 32 位输出，ROM 返回的指令数据

    `ifndef ALTERA_RESERVED_QIS
    `endif
    tri1 clock;             // 使时钟信号变为 tri1 类型，确保其为高阻态

    // 声明内部信号
    wire [31:0] sub_wire0;  // 从 ROM 中读取的数据
    wire [31:0] q = sub_wire0[31:0];  // 输出信号，将读取的 ROM 数据传递到输出端口 q

    // 使用 Altera 提供的 altsyncram 模块实现 ROM
    altsyncram altsyncram_component (
        .address_a (address),           // 输入：ROM 地址信号
        .clock0 (clock),                // 输入：时钟信号
        .q_a (sub_wire0),               // 输出：从 ROM 中读取的数据
        .aclr0 (1'b0),                  // 清除信号，未启用（保持为 0）
        .aclr1 (1'b0),                  // 清除信号，未启用（保持为 0）
        .address_b (1'b1),              // 地址 b 未启用
        .addressstall_a (1'b0),         // 地址停滞信号，未启用（保持为 0）
        .addressstall_b (1'b0),         // 地址停滞信号，未启用（保持为 0）
        .byteena_a (1'b1),              // 字节使能信号，启用
        .byteena_b (1'b1),              // 字节使能信号，未启用（保持为 1）
        .clock1 (1'b1),                 // 时钟 1，未启用（保持为 1）
        .clocken0 (1'b1),               // 时钟使能信号，启用
        .clocken1 (1'b1),               // 时钟使能信号，启用
        .clocken2 (1'b1),               // 时钟使能信号，启用
        .clocken3 (1'b1),               // 时钟使能信号，启用
        .data_a ({32{1'b1}}),          // 数据输入端 a，设置为 1 的常数数据
        .data_b (1'b1),                // 数据输入端 b，未启用（保持为 1）
        .eccstatus (),                 // ECC 状态，未启用
        .q_b (),                       // 输出 b，未启用
        .rden_a (1'b1),                // 读使能信号 a，启用
        .rden_b (1'b1),                // 读使能信号 b，启用
        .wren_a (1'b0),                // 写使能信号 a，未启用
        .wren_b (1'b0)                 // 写使能信号 b，未启用
    );

    // 设置 ROM 模块的参数
    defparam
        altsyncram_component.address_aclr_a = "NONE",           // 地址端口 a 无清除功能
        altsyncram_component.clock_enable_input_a = "BYPASS",   // 输入 a 端口的时钟使能功能被旁路
        altsyncram_component.clock_enable_output_a = "BYPASS",  // 输出 a 端口的时钟使能功能被旁路
        altsyncram_component.init_file = "rom.mif",             // ROM 的初始化文件
        altsyncram_component.intended_device_family = "Cyclone IV E", // 目标设备系列为 Cyclone IV E
        altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",  // 禁用运行时修改
        altsyncram_component.lpm_type = "altsyncram",            // 模块类型为 altsyncram
        altsyncram_component.numwords_a = 32,                    // ROM 中的字数为 32
        altsyncram_component.operation_mode = "ROM",             // 模式为 ROM，只读存储器
        altsyncram_component.outdata_aclr_a = "NONE",            // 输出数据无清除功能
        altsyncram_component.outdata_reg_a = "UNREGISTERED",     // 输出不注册
        altsyncram_component.widthad_a = 5,                       // 地址宽度为 5 位
        altsyncram_component.width_a = 32,                        // 数据宽度为 32 位
        altsyncram_component.width_byteena_a = 1;                // 字节使能宽度为 1

endmodule
