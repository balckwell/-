module vga_colorbar(
	input clk_4Hz,
	input key_in0,
	input key_in1,
	input key_in2,
	input sys_clk,
	input sys_rstn,
	output hsync,
	output vsync,
	output [2:0] vga_rgb
);

//PLL锁相环
wire clk_1Hz;
wire vga_clk;
wire locked;
wire rstn;
assign rstn=(sys_rstn && locked);

//像素数据
wire [10:0] pix_x;
wire [10:0] pix_y;
wire [2:0] pix_data;

//按键切换
wire key0;
wire [3:0] state;

//数字时钟
wire [4:0] hour;
wire [5:0] min;
wire [5:0] s;

//弹球游戏
wire key1;
wire key2;

clk_gen clk_gen_inst (
	.areset ( ~sys_rstn ),
	.inclk0 ( sys_clk ),
	.c0 ( vga_clk ),
	.locked ( locked )
	);

vga_ctrl vga_ctrl_inst(
   .vga_clk(vga_clk),
   .sys_rstn(rstn),
   .pix_data(pix_data),
   .pix_x(pix_x),
   .pix_y(pix_y),
   .hsync(hsync),
   .vsync(vsync),
   .vga_rgb(vga_rgb)
);

vga_pic vga_pic_inst(
	.key1(key1),
	.key2(key2),
	.hour(hour),
	.min(min),
	.s(s),
   .vga_clk(vga_clk),
   .sys_rstn(rstn),
   .pix_x(pix_x),
   .pix_y(pix_y),
   .pix_data(pix_data),
	.state(state)
);

key_filter key_filter_inst0(
	 .sys_clk(sys_clk),
	 .sys_rstn(sys_rstn),
	 .key_in(key_in0),
	 .key(key0)
);

key_filter key_filter_inst1(
	 .sys_clk(sys_clk),
	 .sys_rstn(sys_rstn),
	 .key_in(key_in1),
	 .key(key1)
);

key_filter key_filter_inst2(
	 .sys_clk(sys_clk),
	 .sys_rstn(sys_rstn),
	 .key_in(key_in2),
	 .key(key2)
);

vga_state vga_state_inst(
	.sys_clk(sys_clk),
	.sys_rstn(rstn),
	.key(key0),
	.state(state)
);

clk_div4 clk_div4_inst(
	.clk_4Hz(clk_4Hz),
	.sys_rsn(rstn),
	.clk_1Hz(clk_1Hz)
);

clock clock_inst(
	.hour(hour),
	.min(min),
	.s(s),
	.clk_1Hz(clk_1Hz),
	.sys_rsn(rstn)
);

endmodule