module key_filter#(
	//parameter cnt_max=20'd1_000_000 //50Mhz->20ns   20ns*10^6=20ms
	parameter cnt_max=20'd50_000
)(
    input sys_clk,
    input sys_rstn,
    input key_in,
    output reg key
);

reg [19:0] cnt_20ms;

always@(posedge sys_clk or negedge sys_rstn)
    if(!sys_rstn)
        cnt_20ms<=20'd0;
    else if(key_in==1'b0)
        cnt_20ms<=20'd0;
    else if(cnt_20ms == cnt_max)
        cnt_20ms<=cnt_max;
    else    
        cnt_20ms<=cnt_20ms+20'd1;

always@(posedge sys_clk or negedge sys_rstn)
    if(!sys_rstn)
        key<=1'b0;
    else if(cnt_20ms==(cnt_max-20'd1))
        key<=1'b1;
    else
        key<=1'b0;

endmodule


