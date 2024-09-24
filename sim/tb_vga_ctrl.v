`timescale 1ns/1ns
module tb_vga_ctrl();

reg sys_clk;
reg sys_rstn;
reg [2:0] pix_data;

wire vga_clk;
wire locked;
wire rstn;

wire [10:0] pix_x;
wire [10:0] pix_y;
wire hsync;
wire vsync;
wire [2:0] vga_rgb;

initial begin
    sys_clk=1'b1;
    sys_rstn<=1'b0;
    #20
    sys_rstn<=1'b1;
end

always #10 sys_clk=~sys_clk;

assign rstn=(sys_rstn && locked);

always@(posedge vga_clk or negedge sys_rstn)
    if(sys_rstn==1'b0)
        pix_data<=16'h0000;
    else if (pix_x>=11'd0 && pix_x<11'd800  && pix_y>=11'd0 && pix_y<11'd600)
        pix_data<=3'h111;
    else
        pix_data<=3'h000;


clk_gen	clk_gen_inst (
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

endmodule

