module waveform_gen(
    input wire vga_clk,
    input wire sys_rstn,
    input wire [10:0] pix_x,
    output reg [10:0] waveform_y_sine,
    output reg [10:0] waveform_y_triangle,
    output reg [10:0] waveform_y_square
);

parameter AMPLITUDE   = 11'd50;          // 振幅
parameter BASELINE    = 11'd10;         // 第一个波形的基线高度
parameter TABLE_SIZE  = 8'd255;             // 查找表大小
parameter UPDATE_RATE = 19'd416_666;     // 相位更新速率

reg [7:0] phase_index;         // 相位索引
reg [18:0] clk_divider;        // 时钟分频器计数器
reg [15:0] sine_table     [0:TABLE_SIZE-1]; // 正弦波查找表
reg [15:0] triangle_table [0:TABLE_SIZE-1]; // 三角波查找表
reg [15:0] square_table   [0:TABLE_SIZE-1]; // 矩形波查找表

integer i;

// 初始化查找表
initial begin
    // 从文件中读取正弦波查找表
    $readmemh("sine_table.mem", sine_table);
    // 从文件中读取三角波查找表
    $readmemh("triangle_table.mem", triangle_table);
    // 从文件中读取矩形波查找表
    $readmemh("square_table.mem", square_table);
end

// 时钟分频器和相位索引更新
always @(posedge vga_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        clk_divider <= 19'd0;
        phase_index <= 8'd0;
    end else begin
        if (clk_divider >= UPDATE_RATE - 1) begin
            clk_divider <= 19'd0;
            phase_index <= phase_index + 8'd1; // 更新相位索引
        end else begin
            clk_divider <= clk_divider + 19'd1;
        end
    end
end

// 波形生成
always @(posedge vga_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        waveform_y_sine     <= BASELINE;
        waveform_y_triangle <= BASELINE + 200; // 垂直偏移，避免重叠
        waveform_y_square   <= BASELINE + 200*2;
    end else begin
        // 正弦波
        waveform_y_sine <= BASELINE + sine_table[(pix_x + phase_index) % TABLE_SIZE];
        // 三角波
        waveform_y_triangle <= BASELINE + 200 + triangle_table[(pix_x + phase_index) % TABLE_SIZE];
        // 矩形波
        waveform_y_square <= BASELINE + 400 + square_table[(pix_x + phase_index) % TABLE_SIZE];
    end
end

endmodule