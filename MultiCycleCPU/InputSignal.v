// 输入数字信号
module InputSignal(
    input [3:0] input_signal,             // 4位输入 input_signal，用于存储外部传入的数据
    input input_number_select,        // 输入控制信号，当为1时，表示输入数据
    input output_number_select,       // 输出控制信号，当为1时，表示显示结果
    output reg [3:0] input_data,    // 输出寄存器，存储输入的4位数据
    output reg show_computation_result     // 输出寄存器，指示是否显示结果
);

// 初始块，初始化寄存器值
initial begin
    input_data <= 0;              // 将 input_data 初始化为 0
    show_computation_result = 0;         // 将 show_computation_result 初始化为 0
end

// 根据输入控制信号来更新输出信号
always@(input_number_select or output_number_select) begin
    // 当 input_number_select 为 1 时，将输入 input_signal 的值赋给 input_data
    if(input_number_select)
        input_data = input_signal;

    // 当 output_number_select 为 1 时，设置 show_computation_result 为 1，表示显示结果
    if(output_number_select)
        show_computation_result = 1;
end

endmodule
