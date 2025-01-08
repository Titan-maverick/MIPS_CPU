// 提供数据存储器的读写操作
module DataMemory(
    // 输入端口
    input memory_read,          // 数据存储器读控制信号，memory_read为1时进行读取
    input memory_write,         // 数据存储器写控制信号，memory_write为1时进行写入
    input clk,              // 时钟信号，用于同步控制
    input db_data_source,        // 数据源选择，决定data_bus的值是data_address还是data_out
    input [31:0] data_address,     // 数据存储器地址输入端口，用于指定存储器的读写地址
    input [31:0] data_in,    // 数据存储器数据输入端口，用于写入数据
    output reg [31:0] data_out, // 数据存储器数据输出端口，用于读取数据
    output reg [31:0] data_bus     // 数据输出端口（data_bus），值是data_address或data_out
);
  
	// 初始化，设置data_bus初值为0
	initial
	begin
		 data_bus <= 16'b0;  // data_bus初值为0
	end

// 内部存储器定义，使用reg类型定义8位宽的RAM，共32个单元（地址范围0到31）
reg [7:0]  ram [0:31];  // 存储器数组

// 读操作
always@(memory_read or data_address or db_data_source)
begin
    // 读取数据，按照字节顺序拼接为32位数据
    // 使用memory_read信号判断是否进行读操作
    data_out[7:0]   = memory_read ? ram[data_address + 3] : 8'bz;  // 读取data_address+3处的数据
    data_out[15:8]  = memory_read ? ram[data_address + 2] : 8'bz;  // 读取data_address+2处的数据
    data_out[23:16] = memory_read ? ram[data_address + 1] : 8'bz;  // 读取data_address+1处的数据
    data_out[31:24] = memory_read ? ram[data_address]     : 8'bz;  // 读取data_address处的数据

    // 根据db_data_source的值决定data_bus的来源
    data_bus = (db_data_source == 0) ? data_address : data_out; // 如果db_data_source为0，data_bus为data_address，否则为data_out
end
  
// 写操作
always@(negedge clk)  // 在时钟的下降沿触发
begin
    // 如果memory_write为1，则执行写操作
    if(memory_write) begin
        ram[data_address]     = data_in[31:24]; // 将data_in的高8位写入ram[data_address]
        ram[data_address + 1] = data_in[23:16]; // 将data_in的中高8位写入ram[data_address+1]
        ram[data_address + 2] = data_in[15:8];  // 将data_in的中低8位写入ram[data_address+2]
        ram[data_address + 3] = data_in[7:0];   // 将data_in的低8位写入ram[data_address+3]
    end
end

endmodule
