module clock(
	input clk_1Hz,
	input sys_rsn,
	output [4:0]  hour,
	output [5:0]  min,
	output [5:0]  s
);
reg	[4:0] cnt_hour;
reg   [5:0] cnt_min;
reg   [5:0] cnt_s;

assign hour=cnt_hour;
assign min=cnt_min;
assign s=cnt_s;

always @( posedge clk_1Hz or negedge sys_rsn)
	if(!sys_rsn) 
		cnt_s<=6'b0;
	else if(cnt_s==6'd59)
		cnt_s<=6'b0;
	else
		cnt_s<=cnt_s+6'd1;
		

always @(posedge clk_1Hz or negedge sys_rsn ) 
	if(!sys_rsn)
	   cnt_min<=6'b0;
	else if(cnt_s==6'd59 && cnt_min==6'd59)
		cnt_min<=6'd0;
	else if(cnt_s==6'd59)
	   cnt_min<=cnt_min+6'd1;
	else
		cnt_min<=cnt_min;
		
always @(posedge clk_1Hz or negedge sys_rsn )
	if(!sys_rsn)
	   cnt_hour<=5'd0;
	else if(cnt_s==6'd59 && cnt_min==6'd59 && cnt_hour==5'd23)
		cnt_hour<=5'd0;
	else if(cnt_s==6'd59 && cnt_min==6'd59)
	   cnt_hour<=cnt_hour+5'd1;
	else
		cnt_hour<=cnt_hour;	

endmodule