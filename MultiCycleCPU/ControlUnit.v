//根据当前指令的操作码和功能码生成各种控制信号
module ControlUnit(
	input clk,                    // 时钟信号
	input halt_signal,                   // 是否停机信号
	input zero_flag,                   // ALU运算结果是否为0，0为真
	output reg memory_read,           // 数据存储器读控制信号，为1时读
	output reg memory_write,          // 数据存储器写控制信号，为1时写
	output reg input_number_select,      // 是否取输入数据，为1时表示取数据
	output reg output_number_select,     // 是否显示数据的信号，为1时表示显示
	output reg pc_write_enable,             // PC是否可以更新的信号，为0时不更新
	output reg extend_select,            // 是否进行立即数扩展，为1时表示扩展
	output reg instruction_mem_rw,         // 指令存储器读写控制，为0时读，为1时写
	output reg register_destination,            // 寄存器地址选择信号，为1时来自rd，为0时来自rt
	output reg register_write_enable,            // 寄存器写使能信号，为1时可以写
	output reg alu_src_a,           // ALU数据A的选择信号，为1时来自输入
	output reg alu_src_b,           // ALU数据B的选择信号，为1时来自立即数
	output reg [2:0] pc_source,       // PC选择器信号，决定下一个PC值
	output reg [4:0] alu_operation,       // ALU运算操作选择信号，决定ALU的运算类型
	output wire [2:0] current_state,  // 状态输出，表示当前控制单元的状态
	input [5:0] opcode,               // 指令操作码 (opcode)
	input [5:0] function_code,            // 指令功能码 (function_code)
	output reg db_data_source          // 数据保存源选择信号，为1时来自数据存储器
);

	// 初始化信号
	initial begin
		instruction_mem_rw = 1;
		pc_write_enable = 1;
		memory_read = 0;
		memory_write = 0;
		db_data_source = 0;
		input_number_select = 0;
		output_number_select = 0;
	end

	// 定义状态机的各个状态
	parameter IF = 0, ID = 1, EXE = 2, MEM = 3, WB = 4, HALT = 5;
	// 当前状态与下一个状态
	reg [2:0]state,next_state; //000:if 001:ID 010:exe 011:mem 100:wb 101:HALT	  
	
	initial begin
		state <= IF; // 初始状态为IF（取指阶段）
	end
	
	// 时钟上升沿更新状态
	always @(posedge clk) 
	begin
		state <= next_state;
	end
	
	// 状态转移逻辑
	always @(state or opcode or function_code or halt_signal)
	begin
		case(state)
			IF: // 取指阶段
				begin
					next_state <= ID; // 进入ID阶段
				end
					
			ID: // 解码阶段
				begin
					case(opcode)
						6'b000010: // j指令
							begin
								if(halt_signal)
									next_state <= HALT;  // 如果halt_signal信号为1，转到HALT状态
								else
									next_state <= IF;    // 否则，继续取指阶段
							end
						6'b111111: // halt_signal指令
							begin
								if(halt_signal)
									next_state <= HALT;  // 停机状态
								else
									next_state <= IF;    // 否则继续取指
							end
						default: 
							begin
								next_state <= EXE;    // 默认进入执行阶段
							end
					endcase
				end
					
			EXE: // 执行阶段
				begin
					case (opcode)
						6'b101011: // lw指令
							begin
								next_state <= MEM;  // 进入MEM阶段
							end
						6'b100011: // sw指令
							begin
								next_state <= MEM;  // 进入MEM阶段
							end						
						default:
							begin
								next_state <= WB;   // 默认进入写回阶段
							end
					endcase
				end
			
			MEM: // 数据存取阶段
				begin
					if(opcode == 6'b101011)  // lw指令
						begin
							next_state <= WB;  // 进入写回阶段
						end
					else // sw指令
						begin
							if(halt_signal)
								next_state <= HALT;  // 停机状态
							else
								next_state <= IF;    // 否则进入取指阶段
						end			
				end
					
			WB: // 写回阶段
				begin
					if(halt_signal)
						next_state <= HALT;  // 停机状态
					else
						next_state <= IF;    // 否则进入取指阶段
				end
			
			HALT: // 停机状态
				begin
					next_state <= IF;    // 进入取指阶段
				end
		endcase
	end
		
			
		
	// 控制信号的生成
	always @(opcode or zero_flag or function_code)
	begin	
		if(opcode == 6'b000001) output_number_select = 1;  // 处理输出数据
		if(opcode == 6'b000011) input_number_select = 1;   // 处理输入数据
		pc_write_enable = (opcode == 6'b111111) ? 0 : 1;      // 如果是halt_signal指令，则不更新PC
		alu_src_b = (opcode == 6'b001000 || opcode == 6'b100011 || opcode == 6'b101011) ? 1 : 0;  // ALU的B输入来自立即数
		alu_src_a = ((opcode == 6'b000000 && function_code == 6'b000000) || (opcode == 6'b000000 && function_code == 6'b0000010) || (opcode == 6'b000000 && function_code == 6'b010011)) ? 1 : 0; // ALU的A输入来自sa
		db_data_source = (opcode == 6'b100011) ? 1 : 0;  // 数据来自内存
		register_write_enable = (opcode == 6'b101011 || opcode == 6'b000101 || opcode == 6'b000101 || opcode == 6'b101011) ? 0 : 1;  // 如果是sw指令或条件跳转指令，则不写回寄存器
		memory_write = (opcode == 6'b100011) ? 1 : 0;   // 如果是sw指令，则写内存
		memory_read = (opcode == 6'b101011) ? 1 : 0;    // 如果是lw指令，则读内存
		extend_select = (opcode == 6'b000000) ? 0 : 1;      // 立即数扩展
		register_destination = (opcode == 6'b000000) ? 1 : 0;      // 寄存器地址选择来自rd
	end
	
	// 处理PC的选择
	always @(opcode or zero_flag or function_code or halt_signal)
	begin
		if (opcode == 6'b000101 && zero_flag == 0)  pc_source = 1;  // bne指令
		else if(halt_signal)                       pc_source = 3;  // 停机
		else if (opcode == 6'b000010)           pc_source = 2;  // j指令
		else if (opcode == 6'b111110)           pc_source = 4;  // 关中断
		else                                pc_source = 0;  // 默认PC选择为0
	end
	 
	 // 根据指令选择ALU运算操作
	 always @(opcode or function_code or alu_operation)
	 begin
	 if (opcode == 6'b000000&&function_code==6'b100000)   alu_operation=1;   		//add
	 else if (opcode == 6'b000000&&function_code==6'b100100)   alu_operation=2;  //&
	 else if (opcode == 6'b000000&&function_code==6'b100111)   alu_operation=3;  //nor
	 else if (opcode == 6'b000000&&function_code==6'b100101)   alu_operation=4;	//or
	 else if (opcode == 6'b000000&&function_code==6'b101010)   alu_operation=5;	//slt
	 else if (opcode == 6'b000000&&function_code==6'b000000)   alu_operation=6;	//sll
	 else if (opcode == 6'b000000&&function_code==6'b000010)   alu_operation=7;	//srl
	 else if (opcode == 6'b000000&&function_code==6'b100010)   alu_operation=8;	//sub	
	 else if (opcode == 6'b000000&&function_code==6'b011010)   alu_operation=9;	//div
	 else if (opcode == 6'b000000&&function_code==6'b010000)   alu_operation=10;	//mfhi
	 else if (opcode == 6'b000000&&function_code==6'b010010)   alu_operation=11;	//mflo
	 else if (opcode == 6'b000000&&function_code==6'b011000)   alu_operation=12;	//mult
	 else if (opcode == 6'b000000&&function_code==6'b000011)   alu_operation=13;	//sra
	 else if (opcode == 6'b000000&&function_code==6'b010101)   alu_operation=21;//ddu
	 else if (opcode == 6'b000000&&function_code==6'b011010)   alu_operation=22;//or
	 else if (opcode == 6'b001000)   alu_operation=14;							//addi
	 else if (opcode == 6'b000101)   alu_operation=15;							//bne
	 else if (opcode == 6'b100011)   alu_operation=16;							//lw
	 else if (opcode == 6'b101011)   alu_operation=17;							//sw
	 else if (opcode == 6'b110011)   alu_operation=18;            //中断，全亮
	 else if (opcode == 2'h08)   alu_operation=23;							//bltz
	 else if (opcode == 2'h05)   alu_operation=24;							//bgez
	 else if (opcode == 2'h23)   alu_operation=25;							//beq
	 else if (opcode == 2'h2b)   alu_operation=26;							//slti
	 else if (opcode == 6'h01)   alu_operation=27;//ori
	 end
	 
	 // 输出当前状态
    assign current_state = state;
endmodule
