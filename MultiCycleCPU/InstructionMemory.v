 //  从内存中读取指令
module InstructionMemory(
    input [31:0] address,         // 输入的指令地址
    input instruction_mem_rw,            // 指令存储器读/写使能信号
    input clk,                  // 时钟信号
    input [3:0] input_data,          // 输入数据，用于修改指令
    input input_number_select,         
    output reg [31:0] instruction_data_out  // 输出的指令数据
);

    wire [31:0] rom_data;       // 用于存储从 ROM 读取的数据

    // ROM 模块实例，读取指令存储器中的数据
    ROM1P ROM (
        .address(address[6:2]),    // 使用地址的低 5 位作为 ROM 地址
        .clock(clk),             // 时钟信号
        .q(rom_data)             // 输出从 ROM 中读取的指令数据
    );

    // 根据 instruction_mem_rw 和 address 修改指令数据
    always @(*) begin
        if (instruction_mem_rw) begin    // 如果 instruction_mem_rw 为 1，表示允许读取指令

            if (address == 'd12) begin  // 如果指令地址为 12，则修改指令的最低 8 位
                // 修改指令数据的低 8 位，保留高 24 位
                instruction_data_out[31:8] = rom_data[31:8];  
                instruction_data_out[7:0] = {rom_data[7:4], input_data};  // 修改最低 4 位
            end else begin
                instruction_data_out = rom_data;  // 其他情况下，直接输出从 ROM 读取的数据
            end

        end
    end

endmodule
