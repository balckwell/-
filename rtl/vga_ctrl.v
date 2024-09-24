module vga_ctrl(
    input  vga_clk,
    input  sys_rstn,
    input  [2:0] pix_data,
    output [10:0] pix_x,
    output [10:0] pix_y,
    output hsync,
    output vsync,
    output [2:0] vga_rgb 
    );
    
    parameter H_SYNC=11'd128;
    parameter H_BACK=11'd88;
    parameter H_LEFT=11'd0;
    parameter H_VALID=11'd800;
    parameter H_RIGHT=11'd0;
    parameter H_FRONT=11'd40;
    parameter H_TOTAL=11'd1056;
    
    parameter V_SYNC=11'd4;
    parameter V_BACK=11'd23;
    parameter V_TOP= 11'd0;
    parameter V_VALID=11'd600;
    parameter V_BOTTOM=11'd0;
    parameter V_FRONT=11'd1;
    parameter V_TOTAL=11'd628; 
    
    reg [10:0] cnt_h;
    reg [10:0] cnt_v;
    wire rgb_valid;
    
    always@(posedge vga_clk or negedge sys_rstn)
    if(!sys_rstn)
        cnt_h<=11'd0;
    else if(cnt_h==H_TOTAL-1'd1)
        cnt_h<=11'd0;
    else 
        cnt_h<=cnt_h+1'd1;
	 
    
    always@(posedge vga_clk or negedge sys_rstn)
    if(!sys_rstn)
        cnt_v<=11'd0;
    else if((cnt_h==H_TOTAL-1'd1)&&(cnt_v==V_TOTAL-1'd1))
        cnt_v<=11'd0;
	 else if(cnt_h==H_TOTAL-1'd1)
        cnt_v<=cnt_v+1'd1;
    else
        cnt_v<=cnt_v;
    
	 assign rgb_valid=((cnt_h>=H_SYNC+H_BACK+H_LEFT) &&(cnt_h<H_SYNC+H_BACK+H_LEFT+H_VALID)
                     &&(cnt_v>=V_SYNC+V_BACK+V_TOP)&&(cnt_v<V_SYNC+V_BACK+V_TOP+V_VALID));
	 assign pix_x=(rgb_valid==1'b1)?(cnt_h-(H_SYNC+H_BACK+H_LEFT)):11'd0;
	 assign pix_y=(rgb_valid==1'b1)?(cnt_v-(V_SYNC+V_BACK+V_TOP)):11'd0;
	 assign hsync=(cnt_h<=H_SYNC-1'b1)?1'b1:1'b0;
	 assign vsync=(cnt_v<=V_SYNC-1'b1)?1'b1:1'b0;
	 assign vga_rgb=(rgb_valid==1'b1)?pix_data:3'b000;

endmodule
