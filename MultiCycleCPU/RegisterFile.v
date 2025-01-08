// 寄存器组模块，负责存储和读取32个32位的寄存器
module RegisterFile(
      input clk,               // 时钟信号
      input [4:0] read_register_1,    // 第一个寄存器地址输入端口 (rs)
      input [4:0] read_register_2,    // 第二个寄存器地址输入端口 (rt)
      input [31:0] write_data,  // 要写入寄存器的数据输入端口
      input [4:0] write_register,    // 写入的目标寄存器地址 (rt 或 rd)
      input register_write_enable,            // 写使能信号（写使能），为1时在时钟边沿触发写操作
      output reg [31:0] read_data_1,  // 读取的第一个寄存器数据输出端口 (rs)
      output reg [31:0] read_data_2   // 读取的第二个寄存器数据输出端口 (rt)
);

  // 初始值设置，保证在复位时寄存器数据初始化为0
  initial begin
    read_data_1 <= 0;
    read_data_2 <= 0;
  end

  // 寄存器文件，定义了32个32位寄存器
  reg [31:0] regFile [0:31];  // 32个32位的寄存器（编号0到31）

  integer i;
  // 初始化所有寄存器为0
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      regFile[i] <= 0;  // 将所有寄存器初始化为0
    end
  end

  // 组合逻辑块：根据read_register_1和read_register_2的地址读取对应的寄存器数据
  always @(read_register_1 or read_register_2) begin
    read_data_1 = regFile[read_register_1];  // 从寄存器文件中读取第一个寄存器的数据
    read_data_2 = regFile[read_register_2];  // 从寄存器文件中读取第二个寄存器的数据
  end


	always@(negedge clk)
	begin
		//$0恒为0,所以写入寄存器的地址不能为0
		if(register_write_enable && write_register)
		begin
			regFile[write_register] <= write_data;
		end
	end
	
endmodule
