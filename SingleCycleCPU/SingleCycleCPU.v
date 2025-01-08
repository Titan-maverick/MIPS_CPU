module SingleCycleCPU(
    input wire clk, // 时钟信号
    input wire reset, // 重置信号
    input wire myreset, // 自定义重置信号
    input [7:0] RandomNumber, // 输入的随机数
    output [7:0] OutputRandomNumber, // 输出的随机数
    output [31:0] ExtendedRandomNumber, // 扩展的随机数
    output [31:0] ALUResult, // ALU计算结果
    output [31:0] RegOutput, // 寄存器的输出
    output [6:0] Display1, // 用于显示的数码管输出1
    output [6:0] Display2, // 用于显示的数码管输出2
    output [6:0] Display3, // 用于显示的数码管输出3
    output [6:0] Display4, // 用于显示的数码管输出4
    output [6:0] Display5, // 用于显示的数码管输出5
    output [6:0] Display6, // 用于显示的数码管输出6
    output [6:0] Display7, // 用于显示的数码管输出7
    output [6:0] Display8 // 用于显示的数码管输出8
);

		// 内部信号声明
		wire [31:0] MemOutput; // 存储器输出数据
		wire [31:0] InstructionReg; // 指令寄存器
		wire PCWriteEnable; // PC写使能
		wire [31:0] NextPC; // 下一个PC地址
		wire RegWriteEnable; // 寄存器写使能
		wire [4:0] RegFileAddress; // 寄存器文件地址
		wire [4:0] RegWriteData;
		wire [5:0] FuncCode; // 功能字段
		wire [5:0] Opcode; // 操作码
		wire [31:0] JumpControl; // 用于跳转的信号
		wire JumpCondition; // 信号，用于控制跳转
		wire [31:0] AddressCalc; // 计算中间地址的信号
		wire [31:0] ALUResultWire; // ALU操作结果
		wire ALUSrc; // ALU源选择信号
		wire [31:0] ALUInput2; // ALU第二个操作数
		wire [31:0] ImmediateValue; // 立即数
		wire RegWriteBack; // 寄存器写回选择信号
		wire [4:0] RegDest; // 寄存器目标操作数
		wire [31:0] FinalResult; // ALU或存储器输出的最终结果
		wire [31:0] ALUInput1; // ALU的输入信号
		wire ZeroFlag; // ALU零标志
		wire BranchControl; // 条件跳转信号
		wire [4:0] RegSource; // 寄存器源操作数
		wire [15:0] Immediate16Bit; // 16位立即数
		wire [4:0] ALUOpCode; // ALU操作码
		wire [31:0] RegData1; // 寄存器数据输出1
		wire [31:0] OperandData; // 立即数或者寄存器操作数
		wire [4:0] ShiftAmount; // 移位操作数
		wire MemWriteEnable; // 存储器写使能
		wire MemReadEnable; // 存储器读使能
		wire [31:0] MemOperand; // 存储器操作数
		wire DataSelect; // 数据选择信号

// ALU运算模块：执行ALU运算
MyALU ALUUnit(
    .ALUOp(ALUOpCode),
    .ReadData1(RegData1),
    .ReadData2(OperandData),
    .sa(ShiftAmount),
    .zero(ZeroFlag),
    .result(ALUResult) // 输出ALU结果
);

// 存储器模块：读写数据
DataMem DataMemory(
    .Wren(MemWriteEnable),
    .Read(MemReadEnable),
    .DAddr(ALUResult),
    .Data(ALUInput2),
    .Mout(MemOutput) // 存储器输出
);

// 存储器和ALU结果选择模块
Mux2to1 MemALUMux(
    .sign(DataSelect),
    .DataA(ExtendedRandomNumber),
    .DataB(ALUResult),
    .OData4(FinalResult) // 选择存储器数据或ALU结果
);


// 指令内存模块：存储和读取指令
InstructionMem InstrMemory(
    .Addr(AddressCalc),
    .Iout(InstructionReg) // 指令输出
);

// 随机数输入模块：生成随机数
EnterInteger RandomInput(
    .clk(clk),
    .RandomNumber(RandomNumber),
    .OutputRandomNumber(OutputRandomNumber) // 随机数输出
);

// 随机数扩展模块
EnterExtend RandomExtend(
    .RandomNumber(OutputRandomNumber),
    .outputNumber(ExtendedRandomNumber) // 扩展后的随机数
);

// 结果模块：处理CPU执行结果并输出
Output DisplayResult(
    .result(RegOutput), // 计算结果输出
    .out1(Display1), .out2(Display2), .out3(Display3), .out4(Display4), 
    .out5(Display5), .out6(Display6), .out7(Display7), .out8(Display8) // 数码管显示的输出
);

// 控制模块：解析指令并生成控制信号
ControlUnit ControlUnitInst(
    .func(FuncCode), 
	 .op(Opcode),
    .Branch(BranchControl), // 跳转信号
    .Memwre(MemWriteEnable), // 存储器写使能
    .Memread(MemReadEnable), // 存储器读使能
    .Regwre(RegWriteEnable), // 寄存器写使能
    .ALUsrc(ALUSrc), // ALU第二操作数源选择
    .RegDst(RegWriteBack), // 寄存器目标选择
    .MemtoReg(DataSelect), // 数据从存储器写回寄存器
    .Pcwre(PCWriteEnable), // PC写使能
    .ALUOp(ALUOpCode) // ALU操作码
);

// MUX模块：多路选择器，用于选择数据来源
Mux2to1 OperandMux(
    .sign(JumpCondition),
    .DataA(ALUResultWire),
    .DataB(AddressCalc),
    .OData4(NextPC) // 选择操作数
);

// 立即数扩展模块：扩展立即数为32位
Mux2to1 ImmediateMux(
    .sign(ALUSrc),
    .DataA(ALUInput2),
    .DataB(ImmediateValue),
    .OData4(OperandData) // 选择扩展后的立即数或寄存器数据
);

// 寄存器文件选择模块
Mux2to1_5 RegFileMux(
    .sign(RegWriteBack),
    .dataA(RegDest),
    .dataB(RegSource),
    .Odata(RegWriteData) // 选择目标寄存器
);

// 立即数扩展模块实例化
Extend ImmediateExtend(
    .imme(Immediate16Bit),
    .extendImme(ImmediateValue) // 立即数扩展
);

// 加法器模块，执行两个输入的加法运算
Add Adder(
    .DataA(AddressCalc),        // 加法输入A
    .DataB(ALUInput1),        // 加法输入B
    .sum(ALUResultWire)            // 加法结果输出
);

// 计算跳转条件模块，计算跳转信号
assign JumpCondition = ZeroFlag & BranchControl; // AND操作，生成跳转条件

// 左移模块，执行左移操作
ShiftLeft2 LeftShift2 (
    .datain(ImmediateValue),                      // 输入数据（立即数）
    .dataout(ALUInput1)      // 输出数据（左移结果）
);

// 程序计数器模块：控制程序执行顺序
myPC ProgramCounter(
    .clk(clk),
    .reset(reset),
    .Pcwre(PCWriteEnable),
    .nextPc(NextPC),
    .curPc(AddressCalc) // 当前PC地址
);

// 指令解析模块：提取指令的各个部分
InstructionCut InstructionParser(
    .myreset(myreset),
    .Inst(InstructionReg),
    .FUNC(FuncCode),
    .IMME(Immediate16Bit),
    .OP(Opcode),
    .RD(RegSource),
    .RS(RegFileAddress),
    .RT(RegDest),
    .SHMAT(ShiftAmount) // 提取寄存器字段
);

// 寄存器文件模块，负责读取和写入寄存器
RegFile RegisterFile (
	 .myreset(myreset),                  // 自定义重置信号
    .clk(clk),                          // 时钟信号
    .Regwre(RegWriteEnable),       // 寄存器写使能信号
    .Regs(RegFileAddress),         // 寄存器源操作数1
    .Regt(RegDest),         // 寄存器源操作数2
    .Regw(RegWriteData),                     // 寄存器目标操作数
    .wdata(FinalResult),                    // 写入数据
    .outputReg1(RegData1),         // 寄存器输出1
    .outputReg2(ALUInput2),  // 寄存器输出2
    .outputReg3(RegOutput)            // 寄存器输出3
);

endmodule
