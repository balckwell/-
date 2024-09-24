`timescale 1ns/1ns
module tb_vga_colorbar();

reg sys_clk;
reg clk_4Hz;
reg sys_rstn;
wire hsync;
wire vsync;
wire [2:0] vga_rgb;
reg key;

initial begin
    sys_clk=1'b1;
	 clk_4Hz=1'b0;
    sys_rstn<=1'b0;
	 key=0;
    #20
    sys_rstn<=1'b1;
	 key=1;
	 #30000
	 key=0;
	 #30000
	 key=1;
	 #30000
	 key=0;
	 /*#30000
	 key=1;
	 #30000
	 key=0;
	 #30000
	 key=1;
	 #30000
	 key=0;
	 #30000
	 key=1;
	 #30000
	 key=0;*/
end

always #10 sys_clk=~sys_clk;
always #20 clk_4Hz=~clk_4Hz;

vga_colorbar vga_colorbar_inst(
	 .clk_4Hz(clk_4Hz),
    .sys_clk(sys_clk),
    .sys_rstn(sys_rstn),
    .hsync(hsync),
    .vsync(vsync),
    .vga_rgb(vga_rgb),
	 .key(key)
);

endmodule


