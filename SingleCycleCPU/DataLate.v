timescale 1ns / 1ps
module DataLate(
    input [31:0] i_data,   // 输入数据
    input clk,              // 时钟信号
    output reg [31:0] o_data // 输出数据
);

    always @(negedge clk) begin
        o_data <= i_data;  // 在时钟的负边沿，传递输入数据到输出
    end

endmodule
