module DataMem(
    input Wren,             // 写使能信号，当为 1 时表示允许写操作
    input Read,             // 读使能信号，当为 1 时表示允许读操作
    input [31:0] DAddr,     // 地址输入，用于指定读写的内存位置
    input [31:0] Data,      // 数据输入，在写操作时用于存储的数据
    output reg [31:0] Mout  // 数据输出，读取内存时的输出结果
);

    // 定义一个 32 字节的 RAM，每个内存单元 8 位，存储 32 个字节
    reg [7:0] Ram[0:31];   // 32 个 8 位宽度的存储单元

    integer i;  // 用于初始化内存的循环变量
    // 初始化块：将 Ram 中的每个字节初始化为 0
    initial
    begin
        for(i=0;i<32;i=i+1)
            Ram[i] <= 0;  // 初始化内存，将所有存储单元的值设置为 0
    end

    // always 块：在 DAddr, Wren, Read, 或 Data 改变时触发
    always@(DAddr or Wren or Read or Data)
    begin
        // 读操作：lw (load word)
        if(Read)
        begin
            // 从 Ram 中读取数据，按字节顺序将 4 字节的数据拼接成 32 位输出
            Mout[7:0] = Ram[DAddr+3];    // 读取地址 DAddr+3 存储的字节到 Mout[7:0]
            Mout[15:8] = Ram[DAddr+2];   // 读取地址 DAddr+2 存储的字节到 Mout[15:8]
            Mout[23:16] = Ram[DAddr+1];  // 读取地址 DAddr+1 存储的字节到 Mout[23:16]
            Mout[31:24] = Ram[DAddr];    // 读取地址 DAddr 存储的字节到 Mout[31:24]
        end
        
        // 写操作：sw (store word)
        if(Wren)
        begin
            // 将数据 Data 的每个字节写入到 Ram 中，按字节顺序存储
            Ram[DAddr+3] = Data[7:0];    // 将 Data 的最低字节写入 Ram[DAddr+3]
            Ram[DAddr+2] = Data[15:8];   // 将 Data 的第二字节写入 Ram[DAddr+2]
            Ram[DAddr+1] = Data[23:16];  // 将 Data 的第三字节写入 Ram[DAddr+1]
            Ram[DAddr] = Data[31:24];    // 将 Data 的最高字节写入 Ram[DAddr]
        end
    end

endmodule
