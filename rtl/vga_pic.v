module vga_pic(
   input vga_clk,
   input sys_rstn,
   input [10:0] pix_x,
   input [10:0] pix_y,
	input [3:0] state,
	input [5:0]  s,
	input [5:0]  min,
	input [4:0]  hour,
	input key1,
	input key2,
   output reg [2:0] pix_data
);

//RGB三色
parameter H_VALID=11'd800;
parameter V_VALID=11'd600;
parameter RED=		3'b100;
parameter YELLOW= 3'b110;
parameter GREEN=	3'b010;
parameter BLUE=	3'b001;
parameter PURPPLE=3'b101;
parameter BLACK=	3'b000;
parameter WHITE=	3'b111;
parameter QING=	3'b011;

//字符显示
parameter CHAR = 11'd64;
parameter CHAR_B_H = (H_VALID-CHAR*9)/2;
parameter CHAR_B_V = (V_VALID-CHAR)/2;
parameter CHAR_H = CHAR*9;
parameter CHAR_V = CHAR;
wire [10:0] char_x;
wire [10:0] char_y;
wire [575:0] char_data [63:0];
assign char_x=((pix_x >= CHAR_B_H) && (pix_x < CHAR_B_H + CHAR_H) && (pix_y >= CHAR_B_V) && (pix_y < CHAR_B_V + CHAR_V))
				?(pix_x-CHAR_B_H):11'd0;
assign char_y=((pix_x >= CHAR_B_H) && (pix_x < CHAR_B_H + CHAR_H) && (pix_y >= CHAR_B_V) && (pix_y < CHAR_B_V + CHAR_V))
				?(pix_y-CHAR_B_V):11'd0;
				
//静态图片
parameter pic_h = 16'd250;
parameter pic_v = 16'd250;
parameter pic_size = pic_h*pic_v; 
reg [15:0] cnt16;
wire rd_en; 
wire [2:0] pic_data;
reg [15:0] pic_adr;
assign rd_en = pix_x>=(H_VALID - pic_h)/2 && pix_x<(H_VALID - pic_h)/2+pic_h
					&& pix_y>=(V_VALID - pic_v)/2 && pix_y<(V_VALID - pic_v)/2+pic_v;

//数字时钟
parameter colon1_x=hour1xh+20;
parameter colon1_y=hour1yl+19;

parameter colon2_x=min1xh+20;
parameter colon2_y=min1yl+19;

parameter s2xl=640;
parameter s2xh=703;
parameter s2yl=20;
parameter s2yh=147;

parameter s1xl=720;
parameter s1xh=783;
parameter s1yl=20;
parameter s1yh=147;


parameter min2xl=440;
parameter min2xh=503;
parameter min2yl=20;
parameter min2yh=147;

parameter min1xl=520;
parameter min1xh=583;
parameter min1yl=20;
parameter min1yh=147;


parameter hour2xl=240;
parameter hour2xh=303;
parameter hour2yl=20;
parameter hour2yh=147;

parameter hour1xl=320;
parameter hour1xh=383;
parameter hour1yl=20;
parameter hour1yh=147;

wire  [63:0]  char_1 [127:0];
wire  [63:0]  char_2 [127:0];
wire  [63:0]  char_3 [127:0];
wire  [63:0]  char_4 [127:0];
wire  [63:0]  char_5 [127:0];
wire  [63:0]  char_6 [127:0];
wire  [63:0]  char_7 [127:0];
wire  [63:0]  char_8 [127:0];
wire  [63:0]  char_9 [127:0];
wire  [63:0]  char_0 [127:0];

wire  [10:0] s1char_x;
wire	[10:0] s1char_y;
wire  [10:0] s2char_x;
wire	[10:0] s2char_y;

wire  [10:0] min1char_x;
wire	[10:0] min1char_y;
wire  [10:0] min2char_x;
wire	[10:0] min2char_y;

wire  [10:0] hour1char_x;
wire	[10:0] hour1char_y;
wire  [10:0] hour2char_x;
wire	[10:0] hour2char_y;

wire  [3:0] s1;
wire	[3:0] s2;
wire	[3:0] min1;
wire	[3:0] min2;
wire	[3:0] hour1;
wire	[3:0]	hour2;

assign s1=s%10;
assign s2=(s/10)%10;

assign min1=min%10;
assign min2=(min/10)%10;

assign hour1=hour%10;
assign hour2=(hour/10)%10;

assign s1char_x = (pix_x >=s1xl && pix_x <s1xh && pix_y >= s1yl && pix_y < s1yh )? pix_x -s1xl : 11'b0;
assign s1char_y = (pix_x >=s1xl && pix_x <s1xh && pix_y >= s1yl && pix_y < s1yh )? pix_y -s1yl : 11'b0;

assign s2char_x = (pix_x >=s2xl && pix_x <s2xh && pix_y >= s2yl && pix_y < s2yh )? pix_x -s2xl : 11'b0;
assign s2char_y = (pix_x >=s2xl && pix_x <s2xh && pix_y >= s2yl && pix_y < s2yh )? pix_y -s2yl : 11'b0;

assign min1char_x = (pix_x >=min1xl && pix_x <min1xh && pix_y >= min1yl && pix_y < min1yh )? pix_x -min1xl : 11'b0;
assign min1char_y = (pix_x >=min1xl && pix_x <min1xh && pix_y >= min1yl && pix_y < min1yh )? pix_y -min1yl : 11'b0;

assign min2char_x = (pix_x >=min2xl && pix_x <min2xh && pix_y >= min2yl && pix_y < min2yh )? pix_x -min2xl : 11'b0;
assign min2char_y = (pix_x >=min2xl && pix_x <min2xh && pix_y >= min2yl && pix_y < min2yh )? pix_y -min2yl : 11'b0;

assign hour1char_x = (pix_x >=hour1xl && pix_x <hour1xh && pix_y >= hour1yl && pix_y < hour1yh )? pix_x -hour1xl : 11'b0;
assign hour1char_y = (pix_x >=hour1xl && pix_x <hour1xh && pix_y >= hour1yl && pix_y < hour1yh )? pix_y -hour1yl : 11'b0;

assign hour2char_x = (pix_x >=hour2xl && pix_x <hour2xh && pix_y >= hour2yl && pix_y < hour2yh )? pix_x -hour2xl : 11'b0;
assign hour2char_y = (pix_x >=hour2xl && pix_x <hour2xh && pix_y >= hour2yl && pix_y < hour2yh )? pix_y -hour2yl : 11'b0;

//弹球游戏
reg       		game_flag;
reg	[10:0]	x_move; 
reg	[10:0]	y_move;
reg		 		x_flag; 
reg 				y_flag; 
reg 	[2:0]		x_speed;
reg 	[2:0] 	y_speed;

reg	[10:0]	bat_x;
wire	[10:0]	ball_x;
reg  blocks [BLOCK_ROWS-1:0][BLOCK_COLS-1:0];

parameter ball_len=11'd20;
assign 	 ball_x=x_move+ball_len/2;

parameter bat_move=11'd50;
parameter bat_len=11'd300;
parameter bat_high=11'd15;

parameter BLOCK_ROWS = 6'd4; 
parameter BLOCK_COLS = 6'd20; 
parameter BLOCK_WIDTH = 6'd40; 
parameter BLOCK_HEIGHT = 6'd40; 

//游戏开始结束标志
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		game_flag<=1'b1;
	else if(y_move>=V_VALID-ball_len-1'b1 && y_move<V_VALID+ball_len)
		game_flag<=1'b0;
	else
		game_flag<=1'b1;

//小球移速
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		x_speed<=3'd2;
	else if(y_move>=V_VALID-ball_len-bat_high-1'b1)
		if(ball_x-bat_x <= bat_len/4 || bat_x-ball_x <= bat_len/4)
			x_speed<=3'd2;
		else if(ball_x-bat_x <= bat_len*3/8 || bat_x-ball_x <= bat_len*3/8)
			x_speed<=3'd4;
		else if(ball_x-bat_x <= bat_len/2+ball_len/2 || bat_x-ball_x <= bat_len/2+ball_len/2)
			x_speed<=3'd6;
		else if(game_flag==1'b0)
			x_speed<=3'd2;
		
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		y_speed<=3'd4;
	else if(y_move>=V_VALID-ball_len-bat_high-1'b1)
		if(ball_x-bat_x <= bat_len/4 || bat_x-ball_x <= bat_len/4)
			y_speed<=3'd6;
		else if(ball_x-bat_x <= bat_len*3/8 || bat_x-ball_x <= bat_len*3/8)
			y_speed<=3'd4;
		else if(ball_x-bat_x <= bat_len/2+ball_len/2 || bat_x-ball_x <= bat_len/2+ball_len/2)
			y_speed<=3'd2;
		else if(game_flag==1'b0)
			y_speed<=3'd4;

//方块刷新检测
integer i, j;
wire [5:0] block_x;
wire [5:0] block_y;
assign block_x = x_move / BLOCK_WIDTH;  
assign block_y = y_move / BLOCK_HEIGHT;

always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		for (i = 0; i < BLOCK_ROWS; i = i + 1)
			for (j = 0; j < BLOCK_COLS; j = j + 1)
				blocks[i][j] <= 1'b1;
	else if (y_move < BLOCK_ROWS * BLOCK_HEIGHT && blocks[block_y][block_x] == 1'b1) 
		blocks[block_y][block_x] <= 1'b0;
	else if(game_flag==1'b0)
		for (i = 0; i < BLOCK_ROWS; i = i + 1)
			for (j = 0; j < BLOCK_COLS; j = j + 1)
				blocks[i][j] <= 1'b1;
	else
		blocks[block_y][block_x] <= blocks[block_y][block_x];	
			
			
//小球转向		
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		x_flag<=1'b0;
	else if(x_move<=11'd0)
		x_flag<=1'b0;
	else if(x_move>=H_VALID-ball_len-1'b1 && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)
		x_flag<=1'b1;
	else if(y_move>=V_VALID-ball_len-bat_high-1'b1 && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)
		if(x_flag==1'b0)
			if(ball_x>=bat_x-bat_len/2 && ball_x<bat_x)
				x_flag<=1'b1;
			else if(ball_x>=bat_x && ball_x<bat_x+bat_len/2)
				x_flag<=1'b0;
			else	
				x_flag<=x_flag;
		else if(x_flag==1'b1)
			if(ball_x>=bat_x-bat_len/2 && ball_x<bat_x)
				x_flag<=1'b1;
			else if(ball_x>=bat_x && ball_x<bat_x+bat_len/2)
				x_flag<=1'b0;
	else if(game_flag==1'b0)
		x_flag<=1'b0;
		
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn) 
		y_flag<=1'b0;
	else if(y_move==11'd0)
		y_flag<=1'b0;
	else if(y_move>=V_VALID-ball_len-bat_high-1'b1 && ball_x+ball_len/2 > bat_x-bat_len/2 && ball_x-ball_len/2 < bat_x+bat_len/2
			  && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)  //判断是否打到球拍上
		y_flag<=1'b1;
	/*else if(y_move>=V_VALID-ball_len-1'b1 && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)  //测试用
		y_flag<=1'b1; */ 
	else if (y_move < BLOCK_ROWS * BLOCK_HEIGHT && blocks[block_y][block_x] == 1'b1) 
      y_flag <= ~y_flag; 
	else if(game_flag==1'b0)
		y_flag<=1'b0 ;

//小球移动
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		x_move<=11'd80;
	else if(x_flag==1'b0 && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)
		x_move<=x_move+x_speed;
	else if(x_flag==1'b1 && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)
		x_move<=x_move-x_speed;
	else if(x_move>=H_VALID)
		x_move<=11'd0;
	else if(game_flag==1'b0)
		x_move<=11'd80;

always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		y_move<=11'd160;
	else if(y_flag==1'b0 && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)
		y_move<=y_move+y_speed;
	else if(y_flag==1'b1 && pix_x==H_VALID-1'b1 && pix_y==V_VALID-1'b1)
		y_move<=y_move-y_speed;
	else if(y_move>=V_VALID)
		y_move<=11'd0;
	else if(game_flag==1'b0)
		y_move<=11'd160;

//球拍
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn)
		bat_x<=11'd400;
	else if(key1==1'b1)
		bat_x<=bat_x-bat_move;
	else if(key2==1'b1)
		bat_x<=bat_x+bat_move;
	else if(bat_x-bat_len/2>11'd2048-bat_len)
		bat_x<=H_VALID-bat_len/2;
	else if(bat_x+bat_len/2>H_VALID)
		bat_x<=bat_len/2;
	else if(game_flag==1'b0)
		bat_x<=11'd400;

// 声明波形生成模块的输出
wire [10:0] waveform_y_sine;
wire [10:0] waveform_y_triangle;
wire [10:0] waveform_y_square;
wire [2:0] clock_pix_data;

reg [4:0] x_grid;
reg [4:0] y_grid;
reg [2:0] sum_mod8;

// 实例化波形生成模块
waveform_gen waveform_inst(
    .vga_clk(vga_clk),
    .sys_rstn(sys_rstn),
    .pix_x(pix_x),
    .waveform_y_sine(waveform_y_sine),
    .waveform_y_triangle(waveform_y_triangle),
    .waveform_y_square(waveform_y_square)
);

//实例化模拟时钟
clock_display clock_display_inst(
    .vga_clk(vga_clk),         // VGA 时钟信号
    .sys_rstn(sys_rstn),       // 系统复位信号，低电平有效
    .pix_x(pix_x),             // 当前像素的横坐标
    .pix_y(pix_y),             // 当前像素的纵坐标
    .pix_data(clock_pix_data)  // 输出像素数据（颜色）
);	
		
//状态切换		
always@(posedge vga_clk or negedge sys_rstn)
	case(state)
		4'b0000: 
			begin
				if(sys_rstn==1'b0)
					pix_data<=BLACK;
				else if(pix_x>=0 && pix_x<((H_VALID/8)*1))
					pix_data<=RED;
				else if(pix_x>=0 && pix_x<((H_VALID/8)*2))
					pix_data<=YELLOW;
				else if(pix_x>=0 && pix_x<((H_VALID/8)*3))
					pix_data<=GREEN; 
				else if(pix_x>=0 && pix_x<((H_VALID/8)*4))
					pix_data<=BLUE;
				else if(pix_x>=0 && pix_x<((H_VALID/8)*5))
					pix_data<=PURPPLE;
				else if(pix_x>=0 && pix_x<((H_VALID/8)*6))
					pix_data<=BLACK; 
				else if(pix_x>=0 && pix_x<((H_VALID/8)*7))
					pix_data<=WHITE; 
				else if(pix_x>=0 && pix_x<((H_VALID/8)*8))
					pix_data<=QING;  
				else 
					pix_data<=BLACK;
				end
		4'b0001:
			begin
				if(sys_rstn==1'b0)
					pix_data<=BLACK;
				else if(pix_y>=0 && pix_y<((V_VALID/8)*1))
					pix_data<=RED;
				else if(pix_y>=0 && pix_y<((V_VALID/8)*2))
					pix_data<=YELLOW;
				else if(pix_y>=0 && pix_y<((V_VALID/8)*3))
					pix_data<=GREEN; 
				else if(pix_y>=0 && pix_y<((V_VALID/8)*4))
					pix_data<=BLUE;
				else if(pix_y>=0 && pix_y<((V_VALID/8)*5))
					pix_data<=PURPPLE;
				else if(pix_y>=0 && pix_y<((V_VALID/8)*6))
					pix_data<=BLACK; 
				else if(pix_y>=0 && pix_y<((V_VALID/8)*7))
					pix_data<=WHITE; 
				else if(pix_y>=0 && pix_y<((V_VALID/8)*8))
					pix_data<=QING;  
				else 
					pix_data<=BLACK;
			end
		4'b0010:
			begin
				if(sys_rstn==1'b0)
					pix_data<=BLACK;
				else if(pix_y%2==0 && pix_x>=0 && pix_x<50 && pix_y>=0 && pix_y<50)
					pix_data<=BLACK;
				else if(((pix_x/50)%2+(pix_y/50)%2)%2==0 && pix_x>=0 && pix_x<H_VALID && pix_y>=0 && pix_y<V_VALID)
					pix_data<=WHITE;
				else 
					pix_data<=BLACK;
			end
		4'b0011:
			begin
				if(pix_x < H_VALID && pix_y < V_VALID) // 位于有效区域，彩色棋盘格
					begin
						x_grid = pix_x/40;
						y_grid = pix_y/40;
						sum_mod8 = (x_grid+y_grid)%8;
					
						case(sum_mod8)
							3'd0: pix_data <= RED;
							3'd1: pix_data <= YELLOW;
							3'd2: pix_data <= GREEN;
							3'd3: pix_data <= BLUE;
							3'd4: pix_data <= PURPPLE;
							3'd5: pix_data <= QING;
							3'd6: pix_data <= WHITE;
							3'd7: pix_data <= BLACK;
							default: pix_data <= BLACK;
						endcase
					end
				else
					pix_data <= BLACK;
			 end
		4'b0100:
			begin
				if(!sys_rstn)
					pix_data<=BLACK;
				else if(pix_x>=CHAR_B_H && pix_x<CHAR_B_H+CHAR_H && pix_y>=CHAR_B_V && pix_y<CHAR_B_V+CHAR_V && char_data[char_y][11'd575-char_x]==1'b1)
					pix_data<=BLACK;
				else
					pix_data<=WHITE;
			end
		4'b0101: 
				if(!sys_rstn) begin
					pic_adr<=16'b0;
					pix_data<=BLACK;
				end
				else if(rd_en) begin
					pic_adr<=cnt16;
					pix_data<=pic_data;
				end
				else begin
					pic_adr<=16'b0;
					pix_data<=WHITE;
				end
		4'b0110:
				 if(!sys_rstn)
					  pix_data <= BLACK;
				 else if(pix_x >=s1xl && pix_x <s1xh && pix_y >= s1yl && pix_y < s1yh )
					 case (s1)
							4'd1:
									if(char_1[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd2:
									if(char_2[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd3:
									if(char_3[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd4:
									if(char_4[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd5:
									if(char_5[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd6:
									if(char_6[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						   4'd7:
									if(char_7[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						   4'd8:
									if(char_8[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						   4'd9:
									if(char_9[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						   4'd0:
						 			if(char_0[s1char_y][11'd63-s1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						   default:
									pix_data<=WHITE;
						endcase
				 else if(pix_x >=s2xl && pix_x <s2xh && pix_y >= s2yl && pix_y < s2yh )
					 case (s2)
							4'd1:
									if(char_1[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd2:
									if(char_2[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd3:
									if(char_3[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd4:
									if(char_4[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd5:
									if(char_5[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd6:
									if(char_6[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd7:
									if(char_7[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd8:
									if(char_8[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd9:
									if(char_9[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd0:
									if(char_0[s2char_y][11'd63-s2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							default:
									pix_data<=WHITE;
						endcase
				 else if(pix_x >=min1xl && pix_x <min1xh && pix_y >= min1yl && pix_y < min1yh )
					 case (min1)
							4'd1:
									if(char_1[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd2:
									if(char_2[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd3:
									if(char_3[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd4:
									if(char_4[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd5:
									if(char_5[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd6:
									if(char_6[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd7:
									if(char_7[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd8:
									if(char_8[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd9:
									if(char_9[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd0:
									if(char_0[min1char_y][11'd63-min1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							default:
									pix_data<=WHITE;
						endcase
				 else if(pix_x >=min2xl && pix_x <min2xh && pix_y >= min2yl && pix_y < min2yh )
					 case (min2)
							4'd1:
									if(char_1[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd2:
									if(char_2[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd3:
									if(char_3[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd4:
									if(char_4[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd5:
									if(char_5[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd6:
									if(char_6[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd7:
									if(char_7[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd8:
									if(char_8[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd9:
									if(char_9[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd0:
									if(char_0[min2char_y][11'd63-min2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							default:
									pix_data<=WHITE;
						endcase
				 else if(pix_x >=hour1xl && pix_x <hour1xh && pix_y >= hour1yl && pix_y < hour1yh )
					 case (hour1)
							4'd1:
									if(char_1[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd2:
									if(char_2[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd3:
									if(char_3[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd4:
									if(char_4[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd5:
								begin
									if(char_5[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
								end
							4'd6:
								begin
									if(char_6[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
								end
						  4'd7:
								begin
									if(char_7[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
								end
						  4'd8:
								begin
									if(char_8[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
								end
						  4'd9:
								begin
									if(char_9[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
								end
						  4'd0:
								begin
									if(char_0[hour1char_y][11'd63-hour1char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
								end
						default:
									pix_data<=WHITE;
						endcase
				 else if(pix_x >=hour2xl && pix_x <hour2xh && pix_y >= hour2yl && pix_y < hour2yh )
					 case (hour2)
							4'd1:
									if(char_1[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd2:
									if(char_2[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd3:
									if(char_3[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd4:
									if(char_4[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd5:
									if(char_5[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							4'd6:
									if(char_6[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd7:
									if(char_7[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd8:
									if(char_8[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd9:
									if(char_9[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
						  4'd0:
									if(char_0[hour2char_y][11'd63-hour2char_x]==1'b1)
									pix_data <= BLACK;
									else
									pix_data<=WHITE;
							default:
									pix_data<=WHITE;
						endcase
				 else if(pix_x >=colon1_x&&pix_x<(colon1_x+15))
					if(pix_y>=colon1_y&&pix_y<(colon1_y+15))
						pix_data<=BLACK;
					else if(pix_y>=colon1_y + 15+48 &&pix_y<(colon1_y + 15+48+15)) 
						pix_data<=BLACK;
					else
						pix_data<=WHITE;
				 else if(pix_x >=colon2_x&&pix_x<(colon2_x+15))
					if(pix_y>=colon2_y&&pix_y<(colon2_y+15))
						pix_data<=BLACK;
					else if(pix_y>=colon2_y + 15+48&&pix_y<(colon2_y + 15+48+15)) 
						pix_data<=BLACK;
					else
						pix_data<=WHITE;
				 else 
					  pix_data <= WHITE;
		4'b0111:
			begin
				if(sys_rstn==1'b0)
					pix_data<=BLACK;
				else if(pix_x>=x_move && pix_x<x_move+ball_len && pix_y>=y_move && pix_y<y_move+ball_len)
					pix_data<=BLACK;
				else if(pix_x>=bat_x-bat_len/2 && pix_x<bat_x+bat_len/2 && pix_y>=V_VALID-bat_high && pix_y<V_VALID)
					pix_data<=BLACK;
				else begin
					integer pix_block_x, pix_block_y;
					pix_block_x = pix_x / BLOCK_WIDTH;  
					pix_block_y = pix_y / BLOCK_HEIGHT; 
					
					if (pix_y < BLOCK_ROWS * BLOCK_HEIGHT && blocks[pix_block_y][pix_block_x] == 1'b1) 
						pix_data <= BLACK;
					else 
						pix_data <= WHITE;
				end
			end
		4'b1000:
			begin
				pix_data <= clock_pix_data;
			end
		4'b1001:
			begin
				if(sys_rstn==1'b0)
					 pix_data<=BLACK;
				// 控制宽度
				else if(pix_y >= waveform_y_sine && pix_y <= waveform_y_sine+1)
					 pix_data <= BLACK;   
				else if(pix_y >= waveform_y_triangle && pix_y <= waveform_y_triangle+1)
					 pix_data <= BLACK;  
				else if(pix_y >= waveform_y_square && pix_y <= waveform_y_square+1)
					 pix_data <= BLACK;   
				else
					 pix_data <= WHITE;  
			end
		4'b1010:
			begin
				pix_data<=WHITE;
			end
		default: 
				pix_data<=BLACK;
	endcase

//存储静态图片rom地址的计数器
always@(posedge vga_clk or negedge sys_rstn)
	if(!sys_rstn) 
		cnt16<=16'b0;
	else if(rd_en)
		cnt16<=cnt16+16'b1;
	else if(cnt16==16'd62500)
		cnt16<=16'b0;
	else 
		cnt16<=cnt16;

pic_rom	pic_rom_inst (
	.address(pic_adr),
	.clock(vga_clk),
	.rden(rd_en),
	.q(pic_data)
 );

 assign	char_data[ 0]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 1]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 2]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 3]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 4]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 5]=576'h000000000001800000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 6]=576'h000000000003F0000001F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 7]=576'h000000000001FC000000F800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 8]=576'h00007C000001FE000000FC000000000000000000000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[ 9]=576'h00007F000000FE000000F8000000000000060000001F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[10]=576'h00007FC00000FE0000007800001F80000007C00000FF800000000000000000000007F0000007C0000007F0000007F0000007F0000000E0000000E0000007C000000000000003C000,
			char_data[11]=576'h00003FC00000FC000000780000FF80000007E0001FFFC0000000000000000000003FFC00001FF800003FFC00003FFC00003FFC000001E0000001E000007FF800007FF800003FFC00,
			char_data[12]=576'h00001FE00000FC000000700207FC00000003F01FFE1FC000000000000000000000FFFF00007FFC0000FFFF0000FFFF0000FFFF000001E0000001E00001FFFE0000FFFE00007FFF00,
			char_data[13]=576'h00000FE000007C0000007003FFC000000001F00FE01F0000000000000000000001FFFF8000FFFE0001FFFF8001FFFF8001FFFF800003E0000003E00003FFFF0003FFFF0000FFFF80,
			char_data[14]=576'h000003C000007C0000007003F80000000001F001003C0000000000000000000003FFFFC001FFFF0003FFFFC003FFFFC003FFFFC00007E0000007E00007FFFF8003FFFF8001FFFFC0,
			char_data[15]=576'h000001C000007C0000007001C00000000000F00000380000000000000000000007F81FC003F83F8007F81FC007F81FC007F81FC0000FE000000FE0000FF87FC007F01FC003F01FC0,
			char_data[16]=576'h0000000000007C0000007001C0000000000060000070000000000000000000000FE00FE007F00FC00FE00FE00FE00FE00FE00FE0001FE000001FE0001FC01FE00FC00FE007E007E0,
			char_data[17]=576'h00000007E0007C0000007001C0000000000000000060000000000000000000000FC007E007E007C00FC007E00FC007E00FC007E0003FE000003FE0001F800FE00F8007E007C007E0,
			char_data[18]=576'h0000007FF7C07C0000007001C00000000000000000C0000000000000000000001F8003E00FC007E01F8003E01F8003E01F8003E000FFE00000FFE0003F0007F01F0003E00F8003E0,
			char_data[19]=576'h000003FFF7E07C0000007381C00E0000000000000980000000000000000000001F0003F00FC003E01F0003F01F0003F01F0003F001FBE00001FBE0003F0003F01F0003E00F8003F0,
			char_data[20]=576'h00003FFFC3F87C0000007F81C07F0000000000001F00800000000000000000003F0003F00F8003E03F0003F03F0003F03F0003F003F3E00003F3E0003E0003F01F0003E01F0003F0,
			char_data[21]=576'h0007FFFE03F87C000000FF81C3FE0000000000000F81E00000000000000000003E0003F01F8001F03E0003F03E0003F03E0003F003E3E00003E3E0003E0001F01F0003E01F0001F0,
			char_data[22]=576'h00FFFFFC01F87C000003FE01DFF00000000000000F81F0000000000000000000000003F01F8001F0000003F0000003F0000003F003C3E00003C3E0007E0001F01F0003E0000003F0,
			char_data[23]=576'h01FFFE3E01F07C00001FF801FF00000001C000000703F0000000000000000000000003F01F0001F0000003F0000003F0000003F00303E0000303E0007E0001F01F0003E0000003E0,
			char_data[24]=576'h00FFE03F01F07C0001FFF003C000000001F0001E0707C0000000000000000000000003E01F0001F0000003E0000003E0000003E00203E0000203E0007E0001F01F0003E0000003E0,
			char_data[25]=576'h001E003F01F07C0001F870038000000001F8001F870F00000000000000000000000003E01F0001F0000003E0000003E0000003E00003E0000003E0007E0003F00F8007E0000007E0,
			char_data[26]=576'h0000003F01F07C00000070038000600000F8000FC71C00000000000000000000000007E03F0001F0000007E0000007E0000007E00003E0000003E0007E0003F00FC00FC0000007C0,
			char_data[27]=576'h0000007E01F07C00000070038003F800007C0007C73000000000000000000000000007C03F0000F8000007C0000007C0000007C00003E0000003E0007E0003F007E01FC000001FC0,
			char_data[28]=576'h0006007E01F07C0000007003801FF80000780003C7400000000000000000000000000FC03E0000F800000FC000000FC000000FC00003E0000003E0003E0003E007FFFF8000007F80,
			char_data[29]=576'h0007807C01F07C000000700380FFC00000380001C7800000000000000000000000000F803E0000F800000F8000000F8000000F800003E0000003E0003F0007E003FFFF000007FF00,
			char_data[30]=576'h0003E0FC01F07C00000071030FFC00000000000007001C00000000000000000000001F803E0000F800001F8000001F8000001F800003E0000003E0003F000FE000FFFC000007FC00,
			char_data[31]=576'h0001F0F801F07C0000007607FFC1C000000000001F000F00000000000000000000003F003E0000F800003F0000003F0000003F000003E0000003E0001F801FC001FFFC000007FE00,
			char_data[32]=576'h0000FCF801F07C0000007C07F801F0000000000067FC0F80000000000000000000003F003E0000F800003F0000003F0000003F000003E0000003E0001FE03FC003FFFF000007FF00,
			char_data[33]=576'h00007FF001F07C00000078073801F00000004000C73F0F80000000000000000000007E003E0000F800007E0000007E0000007E000003E0000003E0000FFBFF8007FFFFC00000FF80,
			char_data[34]=576'h00003FF003F07C000001F0073C03C00000004803871F8F0000000000000000000000FC003E0000F80000FC000000FC000000FC000003E0000003E00007FFFF800FE01FE000001FC0,
			char_data[35]=576'h00001FF003F07C000003F00E3E0380000000CE070707CF0000000000000000000001F8003E0000F80001F8000001F8000001F8000003E0000003E00003FFFF001FC007E0000007E0,
			char_data[36]=576'h00000FE003F07C00000FF00E3F07000000018F3F0703CF0000000000000000000001F8003E0000F80001F8000001F8000001F8000003E0000003E00000FFFF001F8003F0000003E0,
			char_data[37]=576'h000007F003E07C00003F700E3B8E0000000187BE0701CF0000000000000000000003F0003E0000F00003F0000003F0000003F0000003E0000003E000001FFE003F0001F0000003F0,
			char_data[38]=576'h00000FF803E07C0000FC701C39EC00000003871C07804F0000000000000000000007E0003F0001F00007E0000007E0000007E0000003E0000003E00000007E003E0001F0000001F0,
			char_data[39]=576'h00000FF803E07C0003F8701C38F800000003071C07800F000000000000000000000FC0001F0001F0000FC000000FC000000FC0000003E0000003E0000000FC003E0000F8000001F0,
			char_data[40]=576'h00001FFC01E07C001FE0703838780000000707000F800F000000000000000000001F80001F0001F0001F8000001F8000001F80000003E0000003E0000000F8003E0000F8000001F0,
			char_data[41]=576'h00003FFE01C07C001FC07038381E0000000F07007F000F000000000000000000001F80001F0001F0001F8000001F8000001F80000003E0000003E0000001F8003E0000F8000001F0,
			char_data[42]=576'h00007E7F00007C000F807070380F8000000E07001F000E000000000000000000003F00001F8001F0003F0000003F0000003F00000003E0000003E0000001F0003E0000F80E0001F0,
			char_data[43]=576'h00007C3F00007C00070070603807E000001E07000F000E000000000000000000007E00000F8003E0007E0000007E0000007E00000003E0000003E0000003F0003E0001F81F0001F0,
			char_data[44]=576'h0000FC3F80007C00000070E03803F800001C070007000E00000000000000000000FC00000F8003E000FC000000FC000000FC00000003E0000003E0000003E0003E0001F01F0003F0,
			char_data[45]=576'h0001F81F80007C00000070C03801FF00003C070006000E00000000000000000001F800000FC007E001F8000001F8000001F800000003E0000003E0000007E0003F0001F01F8003F0,
			char_data[46]=576'h0003F00F80007C00000071803800FFE000780700000FFE00000000000000000003F0000007E007C003F0000003F0000003F000000003E0000003E000000FC0003F0003F00F8007E0,
			char_data[47]=576'h0007E00F80007C000000730038087FFC01F807000FFFDE00000000000000000007F0000007F00FC007F0000007F0000007F000000003E0000003E000000F80001F8007E00FC00FE0,
			char_data[48]=576'h000FC00780007C000000720038303FF001F80F07FFF01E0000000000000000000FE0000003F81F800FE000000FE000000FE000000003E0000003E000001F80001FC00FE007F01FC0,
			char_data[49]=576'h001F00078030FC000000740038E0000001F00FFFFE001E0000000000000000000FFFFFF001FFFF800FFFFFF00FFFFFF00FFFFFF00003E0000003E000001F00000FFFFFC007FFFFC0,
			char_data[50]=576'h007E0000003FFC000018F0007BC0000000F01FFF80001E0000000000000000001FFFFFF001FFFF001FFFFFF01FFFFFF01FFFFFF00003E0000003E000003F000007FFFFC003FFFF80,
			char_data[51]=576'h00FC0000001FFC00000FF0007F80000000F01FF000001C0000000000000000001FFFFFF0007FFE001FFFFFF01FFFFFF01FFFFFF00003E0000003E000003E000003FFFF8001FFFE00,
			char_data[52]=576'h03F00000000FFC000007F0007F00000000700F8000001C0000000000000000001FFFFFF0003FFC001FFFFFF01FFFFFF01FFFFFF00003E0000003E000007E000001FFFE00007FFC00,
			char_data[53]=576'h078000000007FC000007E000FE00000000300E0000001C0000000000000000001FFFFFF0000FF0001FFFFFF01FFFFFF01FFFFFF00003E0000003E00000FC0000003FF800001FF000,
			char_data[54]=576'h000000000003F8000003E000FC0000000000000000001C00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[55]=576'h000000000003F8000001E000F80000000000000000001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[56]=576'h000000000001F0000001C000F00000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[57]=576'h000000000001F00000008000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[58]=576'h000000000000E00000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[59]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[60]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[61]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[62]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
			char_data[63]=576'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

assign char_0[ 0 ]=64'h0000000000000000,
		 char_0[ 1 ]=64'h0000000000000000,
		 char_0[ 2 ]=64'h0000000000000000,
		 char_0[ 3 ]=64'h0000000000000000,
		 char_0[ 4 ]=64'h0000000000000000,
		 char_0[ 5 ]=64'h0000000000000000,
		 char_0[ 6 ]=64'h0000000000000000,
		 char_0[ 7 ]=64'h0000000000000000,
		 char_0[ 8 ]=64'h0000000000000000,
		 char_0[ 9 ]=64'h0000000000000000,
		 char_0[10 ]=64'h0000000000000000,
		 char_0[11 ]=64'h0000000000000000,
		 char_0[12 ]=64'h0000000000000000,
		 char_0[13 ]=64'h0000000000000000,
		 char_0[14 ]=64'h0000000000000000,
		 char_0[15 ]=64'h0000000000000000,
		 char_0[16 ]=64'h0000000000000000,
		 char_0[17 ]=64'h0000000000000000,
		 char_0[18 ]=64'h0000000000000000,
		 char_0[19 ]=64'h0000000000000000,
		 char_0[20 ]=64'h0000000000000000,
		 char_0[21 ]=64'h0000001FF0000000,
		 char_0[22 ]=64'h000000FFFE000000,
		 char_0[23 ]=64'h000003FFFF800000,
		 char_0[24 ]=64'h000007FFFFE00000,
		 char_0[25 ]=64'h00001FF81FF00000,
		 char_0[26 ]=64'h00003FE007F80000,
		 char_0[27 ]=64'h00007FC003FC0000,
		 char_0[28 ]=64'h0000FF8001FE0000,
		 char_0[29 ]=64'h0000FF0000FF0000,
		 char_0[30 ]=64'h0001FE00007F0000,
		 char_0[31 ]=64'h0003FE00007F8000,
		 char_0[32 ]=64'h0003FC00003FC000,
		 char_0[33 ]=64'h0007FC00003FC000,
		 char_0[34 ]=64'h000FF800001FE000,
		 char_0[35 ]=64'h000FF800001FE000,
		 char_0[36 ]=64'h001FF000001FF000,
		 char_0[37 ]=64'h001FF000000FF000,
		 char_0[38 ]=64'h003FF000000FF800,
		 char_0[39 ]=64'h003FE000000FF800,
		 char_0[40 ]=64'h003FE0000007FC00,
		 char_0[41 ]=64'h007FE0000007FC00,
		 char_0[42 ]=64'h007FC0000007FC00,
		 char_0[43 ]=64'h007FC0000007FC00,
		 char_0[44 ]=64'h00FFC0000007FE00,
		 char_0[45 ]=64'h00FFC0000003FE00,
		 char_0[46 ]=64'h00FF80000003FE00,
		 char_0[47 ]=64'h00FF80000003FE00,
		 char_0[48 ]=64'h01FF80000003FF00,
		 char_0[49 ]=64'h01FF80000003FF00,
		 char_0[50 ]=64'h01FF80000003FF00,
		 char_0[51 ]=64'h01FF80000003FF00,
		 char_0[52 ]=64'h01FF80000003FF00,
		 char_0[53 ]=64'h01FF80000001FF00,
		 char_0[54 ]=64'h01FF00000001FF00,
		 char_0[55 ]=64'h03FF00000001FF80,
		 char_0[56 ]=64'h03FF00000001FF80,
		 char_0[57 ]=64'h03FF00000001FF80,
		 char_0[58 ]=64'h03FF00000001FF80,
		 char_0[59 ]=64'h03FF00000001FF80,
		 char_0[60 ]=64'h03FF00000001FF80,
		 char_0[61 ]=64'h03FF00000001FF80,
		 char_0[62 ]=64'h03FF00000001FF80,
		 char_0[63 ]=64'h03FF00000001FF80,
		 char_0[64 ]=64'h03FF00000001FF80,
		 char_0[65 ]=64'h03FF00000001FF80,
		 char_0[66 ]=64'h03FF00000001FF80,
		 char_0[67 ]=64'h03FF00000001FF80,
		 char_0[68 ]=64'h03FF00000001FF80,
		 char_0[69 ]=64'h03FF00000001FF80,
		 char_0[70 ]=64'h03FF00000001FF80,
		 char_0[71 ]=64'h03FF00000001FF80,
		 char_0[72 ]=64'h03FF00000001FF80,
		 char_0[73 ]=64'h03FF00000001FF80,
		 char_0[74 ]=64'h03FF00000001FF80,
		 char_0[75 ]=64'h01FF00000001FF00,
		 char_0[76 ]=64'h01FF00000001FF00,
		 char_0[77 ]=64'h01FF80000003FF00,
		 char_0[78 ]=64'h01FF80000003FF00,
		 char_0[79 ]=64'h01FF80000003FF00,
		 char_0[80 ]=64'h01FF80000003FF00,
		 char_0[81 ]=64'h01FF80000003FF00,
		 char_0[82 ]=64'h00FF80000003FE00,
		 char_0[83 ]=64'h00FF80000003FE00,
		 char_0[84 ]=64'h00FFC0000003FE00,
		 char_0[85 ]=64'h00FFC0000007FE00,
		 char_0[86 ]=64'h007FC0000007FC00,
		 char_0[87 ]=64'h007FC0000007FC00,
		 char_0[88 ]=64'h007FE0000007FC00,
		 char_0[89 ]=64'h003FE000000FF800,
		 char_0[90 ]=64'h003FE000000FF800,
		 char_0[91 ]=64'h003FE000000FF800,
		 char_0[92 ]=64'h001FF000000FF000,
		 char_0[93 ]=64'h001FF000001FF000,
		 char_0[94 ]=64'h000FF800001FE000,
		 char_0[95 ]=64'h000FF800001FE000,
		 char_0[96 ]=64'h0007F800003FC000,
		 char_0[97 ]=64'h0007FC00003FC000,
		 char_0[98 ]=64'h0003FE00007F8000,
		 char_0[99 ]=64'h0001FE0000FF0000,
		 char_0[100]=64'h0000FF0000FF0000,
		 char_0[101]=64'h0000FF8001FE0000,
		 char_0[102]=64'h00007FC003FC0000,
		 char_0[103]=64'h00003FE007F80000,
		 char_0[104]=64'h00000FF81FF00000,
		 char_0[105]=64'h000007FFFFE00000,
		 char_0[106]=64'h000003FFFF800000,
		 char_0[107]=64'h000000FFFE000000,
		 char_0[108]=64'h0000001FF0000000,
		 char_0[109]=64'h0000000000000000,
		 char_0[110]=64'h0000000000000000,
		 char_0[111]=64'h0000000000000000,
		 char_0[112]=64'h0000000000000000,
		 char_0[113]=64'h0000000000000000,
		 char_0[114]=64'h0000000000000000,
		 char_0[115]=64'h0000000000000000,
		 char_0[116]=64'h0000000000000000,
		 char_0[117]=64'h0000000000000000,
		 char_0[118]=64'h0000000000000000,
		 char_0[119]=64'h0000000000000000,
		 char_0[120]=64'h0000000000000000,
		 char_0[121]=64'h0000000000000000,
		 char_0[122]=64'h0000000000000000,
		 char_0[123]=64'h0000000000000000,
		 char_0[124]=64'h0000000000000000,
		 char_0[125]=64'h0000000000000000,
		 char_0[126]=64'h0000000000000000,
		 char_0[127]=64'h0000000000000000;

assign char_1[ 0 ]=64'h0000000000000000,
		char_1[ 1 ]=64'h0000000000000000,
		char_1[ 2 ]=64'h0000000000000000,
		char_1[ 3 ]=64'h0000000000000000,
		char_1[ 4 ]=64'h0000000000000000,
		char_1[ 5 ]=64'h0000000000000000,
		char_1[ 6 ]=64'h0000000000000000,
		char_1[ 7 ]=64'h0000000000000000,
		char_1[ 8 ]=64'h0000000000000000,
		char_1[ 9 ]=64'h0000000000000000,
		char_1[10 ]=64'h0000000000000000,
		char_1[11 ]=64'h0000000000000000,
		char_1[12 ]=64'h0000000000000000,
		char_1[13 ]=64'h0000000000000000,
		char_1[14 ]=64'h0000000000000000,
		char_1[15 ]=64'h0000000000000000,
		char_1[16 ]=64'h0000000000000000,
		char_1[17 ]=64'h0000000000000000,
		char_1[18 ]=64'h0000000000000000,
		char_1[19 ]=64'h0000000000000000,
		char_1[20 ]=64'h0000000000000000,
		char_1[21 ]=64'h0000000018000000,
		char_1[22 ]=64'h0000000038000000,
		char_1[23 ]=64'h0000000078000000,
		char_1[24 ]=64'h0000000078000000,
		char_1[25 ]=64'h00000001F8000000,
		char_1[26 ]=64'h00000003F8000000,
		char_1[27 ]=64'h0000000FF8000000,
		char_1[28 ]=64'h0000007FF8000000,
		char_1[29 ]=64'h0001FFFFF8000000,
		char_1[30 ]=64'h0001FFFFF8000000,
		char_1[31 ]=64'h0001FFFFF8000000,
		char_1[32 ]=64'h0000001FF8000000,
		char_1[33 ]=64'h0000000FF8000000,
		char_1[34 ]=64'h00000007F8000000,
		char_1[35 ]=64'h00000007F8000000,
		char_1[36 ]=64'h00000007F8000000,
		char_1[37 ]=64'h00000007F8000000,
		char_1[38 ]=64'h00000007F8000000,
		char_1[39 ]=64'h00000007F8000000,
		char_1[40 ]=64'h00000007F8000000,
		char_1[41 ]=64'h00000007F8000000,
		char_1[42 ]=64'h00000007F8000000,
		char_1[43 ]=64'h00000007F8000000,
		char_1[44 ]=64'h00000007F8000000,
		char_1[45 ]=64'h00000007F8000000,
		char_1[46 ]=64'h00000007F8000000,
		char_1[47 ]=64'h00000007F8000000,
		char_1[48 ]=64'h00000007F8000000,
		char_1[49 ]=64'h00000007F8000000,
		char_1[50 ]=64'h00000007F8000000,
		char_1[51 ]=64'h00000007F8000000,
		char_1[52 ]=64'h00000007F8000000,
		char_1[53 ]=64'h00000007F8000000,
		char_1[54 ]=64'h00000007F8000000,
		char_1[55 ]=64'h00000007F8000000,
		char_1[56 ]=64'h00000007F8000000,
		char_1[57 ]=64'h00000007F8000000,
		char_1[58 ]=64'h00000007F8000000,
		char_1[59 ]=64'h00000007F8000000,
		char_1[60 ]=64'h00000007F8000000,
		char_1[61 ]=64'h00000007F8000000,
		char_1[62 ]=64'h00000007F8000000,
		char_1[63 ]=64'h00000007F8000000,
		char_1[64 ]=64'h00000007F8000000,
		char_1[65 ]=64'h00000007F8000000,
		char_1[66 ]=64'h00000007F8000000,
		char_1[67 ]=64'h00000007F8000000,
		char_1[68 ]=64'h00000007F8000000,
		char_1[69 ]=64'h00000007F8000000,
		char_1[70 ]=64'h00000007F8000000,
		char_1[71 ]=64'h00000007F8000000,
		char_1[72 ]=64'h00000007F8000000,
		char_1[73 ]=64'h00000007F8000000,
		char_1[74 ]=64'h00000007F8000000,
		char_1[75 ]=64'h00000007F8000000,
		char_1[76 ]=64'h00000007F8000000,
		char_1[77 ]=64'h00000007F8000000,
		char_1[78 ]=64'h00000007F8000000,
		char_1[79 ]=64'h00000007F8000000,
		char_1[80 ]=64'h00000007F8000000,
		char_1[81 ]=64'h00000007F8000000,
		char_1[82 ]=64'h00000007F8000000,
		char_1[83 ]=64'h00000007F8000000,
		char_1[84 ]=64'h00000007F8000000,
		char_1[85 ]=64'h00000007F8000000,
		char_1[86 ]=64'h00000007F8000000,
		char_1[87 ]=64'h00000007F8000000,
		char_1[88 ]=64'h00000007F8000000,
		char_1[89 ]=64'h00000007F8000000,
		char_1[90 ]=64'h00000007F8000000,
		char_1[91 ]=64'h00000007F8000000,
		char_1[92 ]=64'h00000007F8000000,
		char_1[93 ]=64'h00000007F8000000,
		char_1[94 ]=64'h00000007F8000000,
		char_1[95 ]=64'h00000007F8000000,
		char_1[96 ]=64'h00000007F8000000,
		char_1[97 ]=64'h00000007F8000000,
		char_1[98 ]=64'h00000007F8000000,
		char_1[99 ]=64'h00000007F8000000,
		char_1[100]=64'h00000007F8000000,
		char_1[101]=64'h0000000FFC000000,
		char_1[102]=64'h0000000FFC000000,
		char_1[103]=64'h0000001FFE000000,
		char_1[104]=64'h0000003FFF000000,
		char_1[105]=64'h000000FFFFE00000,
		char_1[106]=64'h0001FFFFFFFFF000,
		char_1[107]=64'h0001FFFFFFFFF000,
		char_1[108]=64'h0001FFFFFFFFF000,
		char_1[109]=64'h0000000000000000,
		char_1[110]=64'h0000000000000000,
		char_1[111]=64'h0000000000000000,
		char_1[112]=64'h0000000000000000,
		char_1[113]=64'h0000000000000000,
		char_1[114]=64'h0000000000000000,
		char_1[115]=64'h0000000000000000,
		char_1[116]=64'h0000000000000000,
		char_1[117]=64'h0000000000000000,
		char_1[118]=64'h0000000000000000,
		char_1[119]=64'h0000000000000000,
		char_1[120]=64'h0000000000000000,
		char_1[121]=64'h0000000000000000,
		char_1[122]=64'h0000000000000000,
		char_1[123]=64'h0000000000000000,
		char_1[124]=64'h0000000000000000,
		char_1[125]=64'h0000000000000000,
		char_1[126]=64'h0000000000000000,
		char_1[127]=64'h0000000000000000;
		
assign  char_2[ 0 ]=64'h0000000000000000,
		char_2[ 1 ]=64'h0000000000000000,
		char_2[ 2 ]=64'h0000000000000000,
		char_2[ 3 ]=64'h0000000000000000,
		char_2[ 4 ]=64'h0000000000000000,
		char_2[ 5 ]=64'h0000000000000000,
		char_2[ 6 ]=64'h0000000000000000,
		char_2[ 7 ]=64'h0000000000000000,
		char_2[ 8 ]=64'h0000000000000000,
		char_2[ 9 ]=64'h0000000000000000,
		char_2[10 ]=64'h0000000000000000,
		char_2[11 ]=64'h0000000000000000,
		char_2[12 ]=64'h0000000000000000,
		char_2[13 ]=64'h0000000000000000,
		char_2[14 ]=64'h0000000000000000,
		char_2[15 ]=64'h0000000000000000,
		char_2[16 ]=64'h0000000000000000,
		char_2[17 ]=64'h0000000000000000,
		char_2[18 ]=64'h0000000000000000,
		char_2[19 ]=64'h0000000000000000,
		char_2[20 ]=64'h0000000000000000,
		char_2[21 ]=64'h0000003FFC000000,
		char_2[22 ]=64'h000001FFFFC00000,
		char_2[23 ]=64'h00000FFFFFF00000,
		char_2[24 ]=64'h00001FFFFFFC0000,
		char_2[25 ]=64'h00007FE00FFF0000,
		char_2[26 ]=64'h0001FF0001FF8000,
		char_2[27 ]=64'h0003FC00007FC000,
		char_2[28 ]=64'h0007F000003FC000,
		char_2[29 ]=64'h000FE000001FE000,
		char_2[30 ]=64'h001FC000000FF000,
		char_2[31 ]=64'h001FC000000FF000,
		char_2[32 ]=64'h003F80000007F800,
		char_2[33 ]=64'h003F80000007F800,
		char_2[34 ]=64'h007F80000003FC00,
		char_2[35 ]=64'h007F80000003FC00,
		char_2[36 ]=64'h007F80000003FC00,
		char_2[37 ]=64'h00FF80000003FE00,
		char_2[38 ]=64'h00FF80000001FE00,
		char_2[39 ]=64'h00FF80000001FE00,
		char_2[40 ]=64'h00FFC0000001FE00,
		char_2[41 ]=64'h00FFE0000001FE00,
		char_2[42 ]=64'h00FFE0000001FE00,
		char_2[43 ]=64'h00FFF0000001FE00,
		char_2[44 ]=64'h00FFF0000001FE00,
		char_2[45 ]=64'h00FFF0000001FE00,
		char_2[46 ]=64'h007FF0000001FE00,
		char_2[47 ]=64'h007FF0000001FE00,
		char_2[48 ]=64'h003FE0000003FC00,
		char_2[49 ]=64'h000FC0000003FC00,
		char_2[50 ]=64'h000000000003FC00,
		char_2[51 ]=64'h000000000003F800,
		char_2[52 ]=64'h000000000007F800,
		char_2[53 ]=64'h000000000007F800,
		char_2[54 ]=64'h00000000000FF000,
		char_2[55 ]=64'h00000000000FF000,
		char_2[56 ]=64'h00000000001FE000,
		char_2[57 ]=64'h00000000001FE000,
		char_2[58 ]=64'h00000000003FC000,
		char_2[59 ]=64'h00000000003F8000,
		char_2[60 ]=64'h00000000007F8000,
		char_2[61 ]=64'h0000000000FF0000,
		char_2[62 ]=64'h0000000000FE0000,
		char_2[63 ]=64'h0000000001FC0000,
		char_2[64 ]=64'h0000000003F80000,
		char_2[65 ]=64'h0000000007F00000,
		char_2[66 ]=64'h0000000007E00000,
		char_2[67 ]=64'h000000000FC00000,
		char_2[68 ]=64'h000000001F800000,
		char_2[69 ]=64'h000000003F000000,
		char_2[70 ]=64'h000000007E000000,
		char_2[71 ]=64'h00000000FC000000,
		char_2[72 ]=64'h00000001F8000000,
		char_2[73 ]=64'h00000003F0000000,
		char_2[74 ]=64'h00000007E0000000,
		char_2[75 ]=64'h0000000FC0000000,
		char_2[76 ]=64'h0000001F80000000,
		char_2[77 ]=64'h0000003F00000000,
		char_2[78 ]=64'h0000007E00000000,
		char_2[79 ]=64'h000000FC00000000,
		char_2[80 ]=64'h000001F800000000,
		char_2[81 ]=64'h000003F000000000,
		char_2[82 ]=64'h000007E000000000,
		char_2[83 ]=64'h000007C000000000,
		char_2[84 ]=64'h00000F8000000000,
		char_2[85 ]=64'h00001F8000000000,
		char_2[86 ]=64'h00003F0000000000,
		char_2[87 ]=64'h00007E0000000700,
		char_2[88 ]=64'h0000FC0000000700,
		char_2[89 ]=64'h0001F80000000700,
		char_2[90 ]=64'h0003F00000000F00,
		char_2[91 ]=64'h0003E00000000E00,
		char_2[92 ]=64'h0007C00000000E00,
		char_2[93 ]=64'h000FC00000001E00,
		char_2[94 ]=64'h001F800000001E00,
		char_2[95 ]=64'h001F000000003E00,
		char_2[96 ]=64'h003E000000003E00,
		char_2[97 ]=64'h007C000000007E00,
		char_2[98 ]=64'h007C00000000FC00,
		char_2[99 ]=64'h00F800000001FC00,
		char_2[100]=64'h01F000000007FC00,
		char_2[101]=64'h01FFFFFFFFFFFC00,
		char_2[102]=64'h01FFFFFFFFFFFC00,
		char_2[103]=64'h01FFFFFFFFFFFC00,
		char_2[104]=64'h01FFFFFFFFFFFC00,
		char_2[105]=64'h01FFFFFFFFFFFC00,
		char_2[106]=64'h01FFFFFFFFFFF800,
		char_2[107]=64'h01FFFFFFFFFFF800,
		char_2[108]=64'h01FFFFFFFFFFF800,
		char_2[109]=64'h0000000000000000,
		char_2[110]=64'h0000000000000000,
		char_2[111]=64'h0000000000000000,
		char_2[112]=64'h0000000000000000,
		char_2[113]=64'h0000000000000000,
		char_2[114]=64'h0000000000000000,
		char_2[115]=64'h0000000000000000,
		char_2[116]=64'h0000000000000000,
		char_2[117]=64'h0000000000000000,
		char_2[118]=64'h0000000000000000,
		char_2[119]=64'h0000000000000000,
		char_2[120]=64'h0000000000000000,
		char_2[121]=64'h0000000000000000,
		char_2[122]=64'h0000000000000000,
		char_2[123]=64'h0000000000000000,
		char_2[124]=64'h0000000000000000,
		char_2[125]=64'h0000000000000000,
		char_2[126]=64'h0000000000000000,
		char_2[127]=64'h0000000000000000;

assign  char_3[ 0 ]=64'h0000000000000000,
		char_3[ 1 ]=64'h0000000000000000,
		char_3[ 2 ]=64'h0000000000000000,
		char_3[ 3 ]=64'h0000000000000000,
		char_3[ 4 ]=64'h0000000000000000,
		char_3[ 5 ]=64'h0000000000000000,
		char_3[ 6 ]=64'h0000000000000000,
		char_3[ 7 ]=64'h0000000000000000,
		char_3[ 8 ]=64'h0000000000000000,
		char_3[ 9 ]=64'h0000000000000000,
		char_3[10 ]=64'h0000000000000000,
		char_3[11 ]=64'h0000000000000000,
		char_3[12 ]=64'h0000000000000000,
		char_3[13 ]=64'h0000000000000000,
		char_3[14 ]=64'h0000000000000000,
		char_3[15 ]=64'h0000000000000000,
		char_3[16 ]=64'h0000000000000000,
		char_3[17 ]=64'h0000000000000000,
		char_3[18 ]=64'h0000000000000000,
		char_3[19 ]=64'h0000000000000000,
		char_3[20 ]=64'h0000000000000000,
		char_3[21 ]=64'h0000007FF0000000,
		char_3[22 ]=64'h000003FFFF000000,
		char_3[23 ]=64'h00001FFFFFC00000,
		char_3[24 ]=64'h00007FFFFFF00000,
		char_3[25 ]=64'h0000FF803FF80000,
		char_3[26 ]=64'h0001FC0007FC0000,
		char_3[27 ]=64'h0007F00003FE0000,
		char_3[28 ]=64'h0007C00000FF0000,
		char_3[29 ]=64'h000FC000007F8000,
		char_3[30 ]=64'h001F8000007FC000,
		char_3[31 ]=64'h003F8000003FC000,
		char_3[32 ]=64'h003F8000001FE000,
		char_3[33 ]=64'h003F8000001FE000,
		char_3[34 ]=64'h007F8000000FF000,
		char_3[35 ]=64'h007F8000000FF000,
		char_3[36 ]=64'h007FC000000FF000,
		char_3[37 ]=64'h007FC000000FF800,
		char_3[38 ]=64'h007FE0000007F800,
		char_3[39 ]=64'h007FE0000007F800,
		char_3[40 ]=64'h007FE0000007F800,
		char_3[41 ]=64'h007FE0000007F800,
		char_3[42 ]=64'h003FE0000007F800,
		char_3[43 ]=64'h001FC0000007F800,
		char_3[44 ]=64'h000F80000007F800,
		char_3[45 ]=64'h000000000007F800,
		char_3[46 ]=64'h000000000007F000,
		char_3[47 ]=64'h00000000000FF000,
		char_3[48 ]=64'h00000000000FF000,
		char_3[49 ]=64'h00000000000FE000,
		char_3[50 ]=64'h00000000001FE000,
		char_3[51 ]=64'h00000000001FC000,
		char_3[52 ]=64'h00000000003FC000,
		char_3[53 ]=64'h00000000003F8000,
		char_3[54 ]=64'h00000000007F0000,
		char_3[55 ]=64'h0000000000FE0000,
		char_3[56 ]=64'h0000000001FC0000,
		char_3[57 ]=64'h0000000007F80000,
		char_3[58 ]=64'h000000001FE00000,
		char_3[59 ]=64'h00000001FFC00000,
		char_3[60 ]=64'h0000007FFE000000,
		char_3[61 ]=64'h0000007FFC000000,
		char_3[62 ]=64'h0000007FFF800000,
		char_3[63 ]=64'h0000007FFFE00000,
		char_3[64 ]=64'h00000000FFF00000,
		char_3[65 ]=64'h0000000007FC0000,
		char_3[66 ]=64'h0000000001FE0000,
		char_3[67 ]=64'h00000000007F8000,
		char_3[68 ]=64'h00000000003FC000,
		char_3[69 ]=64'h00000000001FC000,
		char_3[70 ]=64'h00000000000FE000,
		char_3[71 ]=64'h000000000007F000,
		char_3[72 ]=64'h000000000007F800,
		char_3[73 ]=64'h000000000003F800,
		char_3[74 ]=64'h000000000003FC00,
		char_3[75 ]=64'h000000000001FC00,
		char_3[76 ]=64'h000000000001FC00,
		char_3[77 ]=64'h000000000001FE00,
		char_3[78 ]=64'h000000000000FE00,
		char_3[79 ]=64'h000000000000FE00,
		char_3[80 ]=64'h000000000000FF00,
		char_3[81 ]=64'h000000000000FF00,
		char_3[82 ]=64'h000000000000FF00,
		char_3[83 ]=64'h000000000000FF00,
		char_3[84 ]=64'h000000000000FF00,
		char_3[85 ]=64'h000F80000000FF00,
		char_3[86 ]=64'h001FC0000000FF00,
		char_3[87 ]=64'h003FE0000000FF00,
		char_3[88 ]=64'h007FE0000000FF00,
		char_3[89 ]=64'h007FF0000000FF00,
		char_3[90 ]=64'h00FFF0000001FE00,
		char_3[91 ]=64'h00FFF0000001FE00,
		char_3[92 ]=64'h00FFF0000001FE00,
		char_3[93 ]=64'h00FFF0000001FC00,
		char_3[94 ]=64'h00FFE0000003FC00,
		char_3[95 ]=64'h00FFE0000003F800,
		char_3[96 ]=64'h007FC0000003F800,
		char_3[97 ]=64'h007FC0000007F000,
		char_3[98 ]=64'h003FC0000007F000,
		char_3[99 ]=64'h003FC000000FE000,
		char_3[100]=64'h001FE000001FC000,
		char_3[101]=64'h000FF000003F8000,
		char_3[102]=64'h0007F80000FF0000,
		char_3[103]=64'h0003FE0003FE0000,
		char_3[104]=64'h0001FFC01FFC0000,
		char_3[105]=64'h00007FFFFFF00000,
		char_3[106]=64'h00003FFFFFC00000,
		char_3[107]=64'h000007FFFF000000,
		char_3[108]=64'h000000FFF0000000,
		char_3[109]=64'h0000000000000000,
		char_3[110]=64'h0000000000000000,
		char_3[111]=64'h0000000000000000,
		char_3[112]=64'h0000000000000000,
		char_3[113]=64'h0000000000000000,
		char_3[114]=64'h0000000000000000,
		char_3[115]=64'h0000000000000000,
		char_3[116]=64'h0000000000000000,
		char_3[117]=64'h0000000000000000,
		char_3[118]=64'h0000000000000000,
		char_3[119]=64'h0000000000000000,
		char_3[120]=64'h0000000000000000,
		char_3[121]=64'h0000000000000000,
		char_3[122]=64'h0000000000000000,
		char_3[123]=64'h0000000000000000,
		char_3[124]=64'h0000000000000000,
		char_3[125]=64'h0000000000000000,
		char_3[126]=64'h0000000000000000,
		char_3[127]=64'h0000000000000000;

assign  char_4[ 0 ]=64'h0000000000000000,
		char_4[ 1 ]=64'h0000000000000000,
		char_4[ 2 ]=64'h0000000000000000,
		char_4[ 3 ]=64'h0000000000000000,
		char_4[ 4 ]=64'h0000000000000000,
		char_4[ 5 ]=64'h0000000000000000,
		char_4[ 6 ]=64'h0000000000000000,
		char_4[ 7 ]=64'h0000000000000000,
		char_4[ 8 ]=64'h0000000000000000,
		char_4[ 9 ]=64'h0000000000000000,
		char_4[10 ]=64'h0000000000000000,
		char_4[11 ]=64'h0000000000000000,
		char_4[12 ]=64'h0000000000000000,
		char_4[13 ]=64'h0000000000000000,
		char_4[14 ]=64'h0000000000000000,
		char_4[15 ]=64'h0000000000000000,
		char_4[16 ]=64'h0000000000000000,
		char_4[17 ]=64'h0000000000000000,
		char_4[18 ]=64'h0000000000000000,
		char_4[19 ]=64'h0000000000000000,
		char_4[20 ]=64'h0000000000000000,
		char_4[21 ]=64'h00000000007C0000,
		char_4[22 ]=64'h0000000000FC0000,
		char_4[23 ]=64'h0000000001FC0000,
		char_4[24 ]=64'h0000000001FC0000,
		char_4[25 ]=64'h0000000003FC0000,
		char_4[26 ]=64'h0000000003FC0000,
		char_4[27 ]=64'h0000000007FC0000,
		char_4[28 ]=64'h000000000FFC0000,
		char_4[29 ]=64'h000000000FFC0000,
		char_4[30 ]=64'h000000001FFC0000,
		char_4[31 ]=64'h000000003FFC0000,
		char_4[32 ]=64'h000000003FFC0000,
		char_4[33 ]=64'h000000007FFC0000,
		char_4[34 ]=64'h000000007BFC0000,
		char_4[35 ]=64'h00000000FBFC0000,
		char_4[36 ]=64'h00000001F3FC0000,
		char_4[37 ]=64'h00000001E3FC0000,
		char_4[38 ]=64'h00000003E3FC0000,
		char_4[39 ]=64'h00000003C3FC0000,
		char_4[40 ]=64'h00000007C3FC0000,
		char_4[41 ]=64'h0000000F83FC0000,
		char_4[42 ]=64'h0000000F03FC0000,
		char_4[43 ]=64'h0000001F03FC0000,
		char_4[44 ]=64'h0000003E03FC0000,
		char_4[45 ]=64'h0000003C03FC0000,
		char_4[46 ]=64'h0000007C03FC0000,
		char_4[47 ]=64'h0000007803FC0000,
		char_4[48 ]=64'h000000F803FC0000,
		char_4[49 ]=64'h000001F003FC0000,
		char_4[50 ]=64'h000001E003FC0000,
		char_4[51 ]=64'h000003E003FC0000,
		char_4[52 ]=64'h000007C003FC0000,
		char_4[53 ]=64'h0000078003FC0000,
		char_4[54 ]=64'h00000F8003FC0000,
		char_4[55 ]=64'h00000F0003FC0000,
		char_4[56 ]=64'h00001F0003FC0000,
		char_4[57 ]=64'h00003E0003FC0000,
		char_4[58 ]=64'h00003C0003FC0000,
		char_4[59 ]=64'h00007C0003FC0000,
		char_4[60 ]=64'h0000F80003FC0000,
		char_4[61 ]=64'h0000F00003FC0000,
		char_4[62 ]=64'h0001F00003FC0000,
		char_4[63 ]=64'h0001E00003FC0000,
		char_4[64 ]=64'h0003E00003FC0000,
		char_4[65 ]=64'h0007C00003FC0000,
		char_4[66 ]=64'h0007800003FC0000,
		char_4[67 ]=64'h000F800003FC0000,
		char_4[68 ]=64'h000F000003FC0000,
		char_4[69 ]=64'h001E000003FC0000,
		char_4[70 ]=64'h003E000003FC0000,
		char_4[71 ]=64'h003C000003FC0000,
		char_4[72 ]=64'h007C000003FC0000,
		char_4[73 ]=64'h00F8000003FC0000,
		char_4[74 ]=64'h00F0000003FC0000,
		char_4[75 ]=64'h01F0000003FC0000,
		char_4[76 ]=64'h01E0000003FC0000,
		char_4[77 ]=64'h03C0000003FC0000,
		char_4[78 ]=64'h07C0000003FC0000,
		char_4[79 ]=64'h07FFFFFFFFFFFFF0,
		char_4[80 ]=64'h07FFFFFFFFFFFFF0,
		char_4[81 ]=64'h07FFFFFFFFFFFFF0,
		char_4[82 ]=64'h07FFFFFFFFFFFFF0,
		char_4[83 ]=64'h0000000003FC0000,
		char_4[84 ]=64'h0000000003FC0000,
		char_4[85 ]=64'h0000000003FC0000,
		char_4[86 ]=64'h0000000003FC0000,
		char_4[87 ]=64'h0000000003FC0000,
		char_4[88 ]=64'h0000000003FC0000,
		char_4[89 ]=64'h0000000003FC0000,
		char_4[90 ]=64'h0000000003FC0000,
		char_4[91 ]=64'h0000000003FC0000,
		char_4[92 ]=64'h0000000003FC0000,
		char_4[93 ]=64'h0000000003FC0000,
		char_4[94 ]=64'h0000000003FC0000,
		char_4[95 ]=64'h0000000003FC0000,
		char_4[96 ]=64'h0000000003FC0000,
		char_4[97 ]=64'h0000000003FC0000,
		char_4[98 ]=64'h0000000003FC0000,
		char_4[99 ]=64'h0000000003FC0000,
		char_4[100]=64'h0000000003FC0000,
		char_4[101]=64'h0000000003FC0000,
		char_4[102]=64'h0000000003FE0000,
		char_4[103]=64'h0000000007FE0000,
		char_4[104]=64'h000000000FFF0000,
		char_4[105]=64'h000000003FFFC000,
		char_4[106]=64'h0000007FFFFFFFC0,
		char_4[107]=64'h0000007FFFFFFFC0,
		char_4[108]=64'h0000007FFFFFFFC0,
		char_4[109]=64'h0000000000000000,
		char_4[110]=64'h0000000000000000,
		char_4[111]=64'h0000000000000000,
		char_4[112]=64'h0000000000000000,
		char_4[113]=64'h0000000000000000,
		char_4[114]=64'h0000000000000000,
		char_4[115]=64'h0000000000000000,
		char_4[116]=64'h0000000000000000,
		char_4[117]=64'h0000000000000000,
		char_4[118]=64'h0000000000000000,
		char_4[119]=64'h0000000000000000,
		char_4[120]=64'h0000000000000000,
		char_4[121]=64'h0000000000000000,
		char_4[122]=64'h0000000000000000,
		char_4[123]=64'h0000000000000000,
		char_4[124]=64'h0000000000000000,
		char_4[125]=64'h0000000000000000,
		char_4[126]=64'h0000000000000000,
        char_4[127]=64'h0000000000000000;

assign  char_5[ 0 ]=64'h0000000000000000,
		char_5[ 1 ]=64'h0000000000000000,
		char_5[ 2 ]=64'h0000000000000000,
		char_5[ 3 ]=64'h0000000000000000,
		char_5[ 4 ]=64'h0000000000000000,
		char_5[ 5 ]=64'h0000000000000000,
		char_5[ 6 ]=64'h0000000000000000,
		char_5[ 7 ]=64'h0000000000000000,
		char_5[ 8 ]=64'h0000000000000000,
		char_5[ 9 ]=64'h0000000000000000,
		char_5[10 ]=64'h0000000000000000,
		char_5[11 ]=64'h0000000000000000,
		char_5[12 ]=64'h0000000000000000,
		char_5[13 ]=64'h0000000000000000,
		char_5[14 ]=64'h0000000000000000,
		char_5[15 ]=64'h0000000000000000,
		char_5[16 ]=64'h0000000000000000,
		char_5[17 ]=64'h0000000000000000,
		char_5[18 ]=64'h0000000000000000,
		char_5[19 ]=64'h0000000000000000,
		char_5[20 ]=64'h0000000000000000,
		char_5[21 ]=64'h0000000000000000,
		char_5[22 ]=64'h0003FFFFFFFFFE00,
		char_5[23 ]=64'h0007FFFFFFFFFE00,
		char_5[24 ]=64'h0007FFFFFFFFFE00,
		char_5[25 ]=64'h0007FFFFFFFFFC00,
		char_5[26 ]=64'h0007FFFFFFFFFC00,
		char_5[27 ]=64'h0007FFFFFFFFFC00,
		char_5[28 ]=64'h0007FFFFFFFFFC00,
		char_5[29 ]=64'h0007FFFFFFFFFC00,
		char_5[30 ]=64'h0007800000000000,
		char_5[31 ]=64'h0007800000000000,
		char_5[32 ]=64'h0007800000000000,
		char_5[33 ]=64'h0007800000000000,
		char_5[34 ]=64'h0007800000000000,
		char_5[35 ]=64'h0007800000000000,
		char_5[36 ]=64'h0007800000000000,
		char_5[37 ]=64'h0007800000000000,
		char_5[38 ]=64'h0007800000000000,
		char_5[39 ]=64'h0007000000000000,
		char_5[40 ]=64'h0007000000000000,
		char_5[41 ]=64'h000F000000000000,
		char_5[42 ]=64'h000F000000000000,
		char_5[43 ]=64'h000F000000000000,
		char_5[44 ]=64'h000F000000000000,
		char_5[45 ]=64'h000F000000000000,
		char_5[46 ]=64'h000F000000000000,
		char_5[47 ]=64'h000F000000000000,
		char_5[48 ]=64'h000F000000000000,
		char_5[49 ]=64'h000F000000000000,
		char_5[50 ]=64'h000F000000000000,
		char_5[51 ]=64'h000F000000000000,
		char_5[52 ]=64'h000F000000000000,
		char_5[53 ]=64'h000F0007FE000000,
		char_5[54 ]=64'h000F007FFFC00000,
		char_5[55 ]=64'h000E03FFFFF00000,
		char_5[56 ]=64'h000E07FFFFFC0000,
		char_5[57 ]=64'h000E0FFFFFFE0000,
		char_5[58 ]=64'h000E1FF007FF0000,
		char_5[59 ]=64'h001E3F0001FF8000,
		char_5[60 ]=64'h001E7C00007FC000,
		char_5[61 ]=64'h001EF800003FE000,
		char_5[62 ]=64'h001FF000001FF000,
		char_5[63 ]=64'h001FE000000FF000,
		char_5[64 ]=64'h001FC000000FF800,
		char_5[65 ]=64'h001F80000007F800,
		char_5[66 ]=64'h001F80000007FC00,
		char_5[67 ]=64'h001F00000003FC00,
		char_5[68 ]=64'h000000000003FC00,
		char_5[69 ]=64'h000000000001FE00,
		char_5[70 ]=64'h000000000001FE00,
		char_5[71 ]=64'h000000000001FE00,
		char_5[72 ]=64'h000000000001FE00,
		char_5[73 ]=64'h000000000001FF00,
		char_5[74 ]=64'h000000000000FF00,
		char_5[75 ]=64'h000000000000FF00,
		char_5[76 ]=64'h000000000000FF00,
		char_5[77 ]=64'h000000000000FF00,
		char_5[78 ]=64'h000000000000FF00,
		char_5[79 ]=64'h000000000000FF00,
		char_5[80 ]=64'h000000000000FF00,
		char_5[81 ]=64'h000000000000FF00,
		char_5[82 ]=64'h000000000000FF00,
		char_5[83 ]=64'h000F80000000FF00,
		char_5[84 ]=64'h001FE0000000FF00,
		char_5[85 ]=64'h003FE0000000FF00,
		char_5[86 ]=64'h007FF0000000FF00,
		char_5[87 ]=64'h007FF0000000FE00,
		char_5[88 ]=64'h00FFF0000001FE00,
		char_5[89 ]=64'h00FFF0000001FE00,
		char_5[90 ]=64'h00FFF0000001FE00,
		char_5[91 ]=64'h00FFE0000001FC00,
		char_5[92 ]=64'h00FFE0000001FC00,
		char_5[93 ]=64'h00FFC0000003FC00,
		char_5[94 ]=64'h00FFC0000003F800,
		char_5[95 ]=64'h007F80000007F800,
		char_5[96 ]=64'h007F80000007F800,
		char_5[97 ]=64'h003F8000000FF000,
		char_5[98 ]=64'h003F8000000FF000,
		char_5[99 ]=64'h001FC000001FE000,
		char_5[100]=64'h000FC000003FC000,
		char_5[101]=64'h0007E000007F8000,
		char_5[102]=64'h0003F80000FF8000,
		char_5[103]=64'h0001FE0001FF0000,
		char_5[104]=64'h0000FFE00FFC0000,
		char_5[105]=64'h00003FFFFFF80000,
		char_5[106]=64'h00000FFFFFE00000,
		char_5[107]=64'h000003FFFF800000,
		char_5[108]=64'h0000003FF8000000,
		char_5[109]=64'h0000000000000000,
		char_5[110]=64'h0000000000000000,
		char_5[111]=64'h0000000000000000,
		char_5[112]=64'h0000000000000000,
		char_5[113]=64'h0000000000000000,
		char_5[114]=64'h0000000000000000,
		char_5[115]=64'h0000000000000000,
		char_5[116]=64'h0000000000000000,
		char_5[117]=64'h0000000000000000,
		char_5[118]=64'h0000000000000000,
		char_5[119]=64'h0000000000000000,
		char_5[120]=64'h0000000000000000,
		char_5[121]=64'h0000000000000000,
		char_5[122]=64'h0000000000000000,
		char_5[123]=64'h0000000000000000,
		char_5[124]=64'h0000000000000000,
		char_5[125]=64'h0000000000000000,
		char_5[126]=64'h0000000000000000,
		char_5[127]=64'h0000000000000000;

assign  char_6[ 0 ]=64'h0000000000000000,
		char_6[ 1 ]=64'h0000000000000000,
		char_6[ 2 ]=64'h0000000000000000,
		char_6[ 3 ]=64'h0000000000000000,
		char_6[ 4 ]=64'h0000000000000000,
		char_6[ 5 ]=64'h0000000000000000,
		char_6[ 6 ]=64'h0000000000000000,
		char_6[ 7 ]=64'h0000000000000000,
		char_6[ 8 ]=64'h0000000000000000,
		char_6[ 9 ]=64'h0000000000000000,
		char_6[10 ]=64'h0000000000000000,
		char_6[11 ]=64'h0000000000000000,
		char_6[12 ]=64'h0000000000000000,
		char_6[13 ]=64'h0000000000000000,
		char_6[14 ]=64'h0000000000000000,
		char_6[15 ]=64'h0000000000000000,
		char_6[16 ]=64'h0000000000000000,
		char_6[17 ]=64'h0000000000000000,
		char_6[18 ]=64'h0000000000000000,
		char_6[19 ]=64'h0000000000000000,
		char_6[20 ]=64'h0000000000000000,
		char_6[21 ]=64'h00000000FFC00000,
		char_6[22 ]=64'h0000000FFFF80000,
		char_6[23 ]=64'h0000003FFFFE0000,
		char_6[24 ]=64'h000000FFFFFF0000,
		char_6[25 ]=64'h000003FF00FF8000,
		char_6[26 ]=64'h000007F8007FC000,
		char_6[27 ]=64'h00000FE0003FE000,
		char_6[28 ]=64'h00001FC0003FF000,
		char_6[29 ]=64'h00003F80003FF000,
		char_6[30 ]=64'h00007F00003FF800,
		char_6[31 ]=64'h0000FE00003FF800,
		char_6[32 ]=64'h0001FC00003FF800,
		char_6[33 ]=64'h0003F800003FF800,
		char_6[34 ]=64'h0003F800003FF800,
		char_6[35 ]=64'h0007F000003FF000,
		char_6[36 ]=64'h0007F000001FF000,
		char_6[37 ]=64'h000FE000000FC000,
		char_6[38 ]=64'h000FE00000000000,
		char_6[39 ]=64'h001FE00000000000,
		char_6[40 ]=64'h001FC00000000000,
		char_6[41 ]=64'h003FC00000000000,
		char_6[42 ]=64'h003FC00000000000,
		char_6[43 ]=64'h003FC00000000000,
		char_6[44 ]=64'h007FC00000000000,
		char_6[45 ]=64'h007F800000000000,
		char_6[46 ]=64'h007F800000000000,
		char_6[47 ]=64'h00FF800000000000,
		char_6[48 ]=64'h00FF800000000000,
		char_6[49 ]=64'h00FF800000000000,
		char_6[50 ]=64'h00FF800000000000,
		char_6[51 ]=64'h01FF800000000000,
		char_6[52 ]=64'h01FF000000000000,
		char_6[53 ]=64'h01FF0001FF000000,
		char_6[54 ]=64'h01FF001FFFF00000,
		char_6[55 ]=64'h01FF007FFFFC0000,
		char_6[56 ]=64'h01FF00FFFFFF0000,
		char_6[57 ]=64'h01FF03FFFFFF8000,
		char_6[58 ]=64'h03FF07FE03FFC000,
		char_6[59 ]=64'h03FF0FF000FFE000,
		char_6[60 ]=64'h03FF1FC0003FF000,
		char_6[61 ]=64'h03FF1F00001FF000,
		char_6[62 ]=64'h03FF3E00000FF800,
		char_6[63 ]=64'h03FF7C000007F800,
		char_6[64 ]=64'h03FF78000003FC00,
		char_6[65 ]=64'h03FFF0000003FC00,
		char_6[66 ]=64'h03FFF0000001FE00,
		char_6[67 ]=64'h03FFE0000001FE00,
		char_6[68 ]=64'h03FFC0000001FE00,
		char_6[69 ]=64'h03FFC0000000FF00,
		char_6[70 ]=64'h03FF80000000FF00,
		char_6[71 ]=64'h03FF80000000FF00,
		char_6[72 ]=64'h03FF00000000FF00,
		char_6[73 ]=64'h03FF000000007F80,
		char_6[74 ]=64'h03FF000000007F80,
		char_6[75 ]=64'h03FF000000007F80,
		char_6[76 ]=64'h03FF000000007F80,
		char_6[77 ]=64'h03FF000000007F80,
		char_6[78 ]=64'h03FF000000007F80,
		char_6[79 ]=64'h01FF000000007F80,
		char_6[80 ]=64'h01FF000000007F80,
		char_6[81 ]=64'h01FF000000007F80,
		char_6[82 ]=64'h01FF800000007F80,
		char_6[83 ]=64'h01FF800000007F80,
		char_6[84 ]=64'h01FF800000007F80,
		char_6[85 ]=64'h00FF800000007F80,
		char_6[86 ]=64'h00FF800000007F80,
		char_6[87 ]=64'h00FF800000007F00,
		char_6[88 ]=64'h00FFC0000000FF00,
		char_6[89 ]=64'h007FC0000000FF00,
		char_6[90 ]=64'h007FC0000000FF00,
		char_6[91 ]=64'h007FE0000000FE00,
		char_6[92 ]=64'h003FE0000000FE00,
		char_6[93 ]=64'h003FE0000000FE00,
		char_6[94 ]=64'h001FF0000001FC00,
		char_6[95 ]=64'h001FF0000001FC00,
		char_6[96 ]=64'h000FF8000001FC00,
		char_6[97 ]=64'h000FFC000003F800,
		char_6[98 ]=64'h0007FC000003F000,
		char_6[99 ]=64'h0003FE000007F000,
		char_6[100]=64'h0003FF00000FE000,
		char_6[101]=64'h0001FF80001FC000,
		char_6[102]=64'h0000FFC0003F8000,
		char_6[103]=64'h00007FF0007F0000,
		char_6[104]=64'h00003FFC03FE0000,
		char_6[105]=64'h00000FFFFFF80000,
		char_6[106]=64'h000003FFFFE00000,
		char_6[107]=64'h000000FFFF800000,
		char_6[108]=64'h0000000FFC000000,
		char_6[109]=64'h0000000000000000,
		char_6[110]=64'h0000000000000000,
		char_6[111]=64'h0000000000000000,
		char_6[112]=64'h0000000000000000,
		char_6[113]=64'h0000000000000000,
		char_6[114]=64'h0000000000000000,
		char_6[115]=64'h0000000000000000,
		char_6[116]=64'h0000000000000000,
		char_6[117]=64'h0000000000000000,
		char_6[118]=64'h0000000000000000,
		char_6[119]=64'h0000000000000000,
		char_6[120]=64'h0000000000000000,
		char_6[121]=64'h0000000000000000,
		char_6[122]=64'h0000000000000000,
		char_6[123]=64'h0000000000000000,
		char_6[124]=64'h0000000000000000,
		char_6[125]=64'h0000000000000000,
		char_6[126]=64'h0000000000000000,
		char_6[127]=64'h0000000000000000;
                       
assign  char_7[ 0 ]=64'h0000000000000000,
		char_7[ 1 ]=64'h0000000000000000,
		char_7[ 2 ]=64'h0000000000000000,
		char_7[ 3 ]=64'h0000000000000000,
		char_7[ 4 ]=64'h0000000000000000,
		char_7[ 5 ]=64'h0000000000000000,
		char_7[ 6 ]=64'h0000000000000000,
		char_7[ 7 ]=64'h0000000000000000,
		char_7[ 8 ]=64'h0000000000000000,
		char_7[ 9 ]=64'h0000000000000000,
		char_7[10 ]=64'h0000000000000000,
		char_7[11 ]=64'h0000000000000000,
		char_7[12 ]=64'h0000000000000000,
		char_7[13 ]=64'h0000000000000000,
		char_7[14 ]=64'h0000000000000000,
		char_7[15 ]=64'h0000000000000000,
		char_7[16 ]=64'h0000000000000000,
		char_7[17 ]=64'h0000000000000000,
		char_7[18 ]=64'h0000000000000000,
		char_7[19 ]=64'h0000000000000000,
		char_7[20 ]=64'h0000000000000000,
		char_7[21 ]=64'h0000000000000000,
		char_7[22 ]=64'h001FFFFFFFFFFF00,
		char_7[23 ]=64'h001FFFFFFFFFFF00,
		char_7[24 ]=64'h001FFFFFFFFFFF00,
		char_7[25 ]=64'h001FFFFFFFFFFF00,
		char_7[26 ]=64'h001FFFFFFFFFFE00,
		char_7[27 ]=64'h001FFFFFFFFFFE00,
		char_7[28 ]=64'h003FFFFFFFFFFC00,
		char_7[29 ]=64'h003FFFFFFFFFFC00,
		char_7[30 ]=64'h003FF80000007800,
		char_7[31 ]=64'h003FC0000000F800,
		char_7[32 ]=64'h003F80000000F000,
		char_7[33 ]=64'h003F00000001E000,
		char_7[34 ]=64'h007E00000001E000,
		char_7[35 ]=64'h007C00000003C000,
		char_7[36 ]=64'h007C00000007C000,
		char_7[37 ]=64'h0078000000078000,
		char_7[38 ]=64'h00780000000F8000,
		char_7[39 ]=64'h00700000000F0000,
		char_7[40 ]=64'h00F00000001F0000,
		char_7[41 ]=64'h00F00000001E0000,
		char_7[42 ]=64'h00E00000003E0000,
		char_7[43 ]=64'h00600000003C0000,
		char_7[44 ]=64'h00000000007C0000,
		char_7[45 ]=64'h0000000000780000,
		char_7[46 ]=64'h0000000000F80000,
		char_7[47 ]=64'h0000000000F00000,
		char_7[48 ]=64'h0000000001F00000,
		char_7[49 ]=64'h0000000001E00000,
		char_7[50 ]=64'h0000000003E00000,
		char_7[51 ]=64'h0000000003E00000,
		char_7[52 ]=64'h0000000007C00000,
		char_7[53 ]=64'h0000000007C00000,
		char_7[54 ]=64'h000000000F800000,
		char_7[55 ]=64'h000000000F800000,
		char_7[56 ]=64'h000000001F800000,
		char_7[57 ]=64'h000000001F000000,
		char_7[58 ]=64'h000000003F000000,
		char_7[59 ]=64'h000000003E000000,
		char_7[60 ]=64'h000000007E000000,
		char_7[61 ]=64'h000000007E000000,
		char_7[62 ]=64'h00000000FC000000,
		char_7[63 ]=64'h00000000FC000000,
		char_7[64 ]=64'h00000001FC000000,
		char_7[65 ]=64'h00000001F8000000,
		char_7[66 ]=64'h00000003F8000000,
		char_7[67 ]=64'h00000003F8000000,
		char_7[68 ]=64'h00000003F0000000,
		char_7[69 ]=64'h00000007F0000000,
		char_7[70 ]=64'h00000007F0000000,
		char_7[71 ]=64'h0000000FF0000000,
		char_7[72 ]=64'h0000000FE0000000,
		char_7[73 ]=64'h0000000FE0000000,
		char_7[74 ]=64'h0000001FE0000000,
		char_7[75 ]=64'h0000001FE0000000,
		char_7[76 ]=64'h0000001FE0000000,
		char_7[77 ]=64'h0000003FC0000000,
		char_7[78 ]=64'h0000003FC0000000,
		char_7[79 ]=64'h0000003FC0000000,
		char_7[80 ]=64'h0000007FC0000000,
		char_7[81 ]=64'h0000007FC0000000,
		char_7[82 ]=64'h0000007FC0000000,
		char_7[83 ]=64'h0000007FC0000000,
		char_7[84 ]=64'h000000FFC0000000,
		char_7[85 ]=64'h000000FFC0000000,
		char_7[86 ]=64'h000000FFC0000000,
		char_7[87 ]=64'h000000FFC0000000,
		char_7[88 ]=64'h000001FFC0000000,
		char_7[89 ]=64'h000001FFC0000000,
		char_7[90 ]=64'h000001FFC0000000,
		char_7[91 ]=64'h000001FFC0000000,
		char_7[92 ]=64'h000001FFC0000000,
		char_7[93 ]=64'h000001FFC0000000,
		char_7[94 ]=64'h000003FFC0000000,
		char_7[95 ]=64'h000003FFC0000000,
		char_7[96 ]=64'h000003FFC0000000,
		char_7[97 ]=64'h000003FFC0000000,
		char_7[98 ]=64'h000003FFC0000000,
		char_7[99 ]=64'h000003FFC0000000,
		char_7[100]=64'h000003FFC0000000,
		char_7[101]=64'h000003FFC0000000,
		char_7[102]=64'h000003FFC0000000,
		char_7[103]=64'h000003FFC0000000,
		char_7[104]=64'h000003FFC0000000,
		char_7[105]=64'h000001FFC0000000,
		char_7[106]=64'h000001FF80000000,
		char_7[107]=64'h000000FF80000000,
		char_7[108]=64'h0000003E00000000,
		char_7[109]=64'h0000000000000000,
		char_7[110]=64'h0000000000000000,
		char_7[111]=64'h0000000000000000,
		char_7[112]=64'h0000000000000000,
		char_7[113]=64'h0000000000000000,
		char_7[114]=64'h0000000000000000,
		char_7[115]=64'h0000000000000000,
		char_7[116]=64'h0000000000000000,
		char_7[117]=64'h0000000000000000,
		char_7[118]=64'h0000000000000000,
		char_7[119]=64'h0000000000000000,
		char_7[120]=64'h0000000000000000,
		char_7[121]=64'h0000000000000000,
		char_7[122]=64'h0000000000000000,
		char_7[123]=64'h0000000000000000,
		char_7[124]=64'h0000000000000000,
		char_7[125]=64'h0000000000000000,
		char_7[126]=64'h0000000000000000,
		char_7[127]=64'h0000000000000000;

assign  char_8[ 0 ]=64'h0000000000000000,
		char_8[ 1 ]=64'h0000000000000000,
		char_8[ 2 ]=64'h0000000000000000,
		char_8[ 3 ]=64'h0000000000000000,
		char_8[ 4 ]=64'h0000000000000000,
		char_8[ 5 ]=64'h0000000000000000,
		char_8[ 6 ]=64'h0000000000000000,
		char_8[ 7 ]=64'h0000000000000000,
		char_8[ 8 ]=64'h0000000000000000,
		char_8[ 9 ]=64'h0000000000000000,
		char_8[10 ]=64'h0000000000000000,
		char_8[11 ]=64'h0000000000000000,
		char_8[12 ]=64'h0000000000000000,
		char_8[13 ]=64'h0000000000000000,
		char_8[14 ]=64'h0000000000000000,
		char_8[15 ]=64'h0000000000000000,
		char_8[16 ]=64'h0000000000000000,
		char_8[17 ]=64'h0000000000000000,
		char_8[18 ]=64'h0000000000000000,
		char_8[19 ]=64'h0000000000000000,
		char_8[20 ]=64'h0000000000000000,
		char_8[21 ]=64'h0000003FFC000000,
		char_8[22 ]=64'h000003FFFF800000,
		char_8[23 ]=64'h00000FFFFFF00000,
		char_8[24 ]=64'h00003FFFFFF80000,
		char_8[25 ]=64'h0000FFE00FFE0000,
		char_8[26 ]=64'h0001FF0001FF0000,
		char_8[27 ]=64'h0003FC00007F8000,
		char_8[28 ]=64'h0007F800003FC000,
		char_8[29 ]=64'h000FF000001FE000,
		char_8[30 ]=64'h001FE000000FF000,
		char_8[31 ]=64'h001FE000000FF000,
		char_8[32 ]=64'h003FC0000007F800,
		char_8[33 ]=64'h003FC0000007F800,
		char_8[34 ]=64'h007F80000003FC00,
		char_8[35 ]=64'h007F80000003FC00,
		char_8[36 ]=64'h007F00000003FC00,
		char_8[37 ]=64'h00FF00000001FE00,
		char_8[38 ]=64'h00FF00000001FE00,
		char_8[39 ]=64'h00FF00000001FE00,
		char_8[40 ]=64'h00FF00000001FE00,
		char_8[41 ]=64'h00FF00000001FE00,
		char_8[42 ]=64'h00FF00000001FE00,
		char_8[43 ]=64'h00FF00000001FE00,
		char_8[44 ]=64'h00FF80000001FE00,
		char_8[45 ]=64'h00FF80000001FE00,
		char_8[46 ]=64'h007FC0000001FC00,
		char_8[47 ]=64'h007FC0000003FC00,
		char_8[48 ]=64'h007FE0000003FC00,
		char_8[49 ]=64'h003FF0000003F800,
		char_8[50 ]=64'h003FF8000007F800,
		char_8[51 ]=64'h003FFC000007F000,
		char_8[52 ]=64'h001FFE00000FF000,
		char_8[53 ]=64'h000FFF00000FE000,
		char_8[54 ]=64'h000FFF80001FC000,
		char_8[55 ]=64'h0007FFE0003F8000,
		char_8[56 ]=64'h0003FFF0007F0000,
		char_8[57 ]=64'h0001FFFC00FE0000,
		char_8[58 ]=64'h0000FFFF01FC0000,
		char_8[59 ]=64'h00003FFFC7F00000,
		char_8[60 ]=64'h00001FFFFFE00000,
		char_8[61 ]=64'h000007FFFF800000,
		char_8[62 ]=64'h000003FFFF000000,
		char_8[63 ]=64'h00000FFFFFC00000,
		char_8[64 ]=64'h00001FBFFFE00000,
		char_8[65 ]=64'h00007F0FFFF80000,
		char_8[66 ]=64'h0000FE03FFFC0000,
		char_8[67 ]=64'h0001FC00FFFE0000,
		char_8[68 ]=64'h0003F8003FFF0000,
		char_8[69 ]=64'h0007F0001FFF8000,
		char_8[70 ]=64'h000FE00007FFC000,
		char_8[71 ]=64'h001FE00003FFE000,
		char_8[72 ]=64'h003FC00000FFF000,
		char_8[73 ]=64'h003F8000007FF000,
		char_8[74 ]=64'h007F8000003FF800,
		char_8[75 ]=64'h007F0000001FF800,
		char_8[76 ]=64'h00FF0000000FFC00,
		char_8[77 ]=64'h00FF0000000FFC00,
		char_8[78 ]=64'h01FE00000007FE00,
		char_8[79 ]=64'h01FE00000003FE00,
		char_8[80 ]=64'h01FE00000003FE00,
		char_8[81 ]=64'h01FE00000001FF00,
		char_8[82 ]=64'h03FC00000001FF00,
		char_8[83 ]=64'h03FC00000001FF00,
		char_8[84 ]=64'h03FC00000000FF00,
		char_8[85 ]=64'h03FC00000000FF00,
		char_8[86 ]=64'h03FC00000000FF00,
		char_8[87 ]=64'h03FC00000000FF00,
		char_8[88 ]=64'h03FC00000000FF00,
		char_8[89 ]=64'h03FC00000000FF00,
		char_8[90 ]=64'h03FC00000000FF00,
		char_8[91 ]=64'h03FC00000000FE00,
		char_8[92 ]=64'h01FE00000000FE00,
		char_8[93 ]=64'h01FE00000001FE00,
		char_8[94 ]=64'h01FE00000001FE00,
		char_8[95 ]=64'h00FF00000001FC00,
		char_8[96 ]=64'h00FF00000003FC00,
		char_8[97 ]=64'h007F80000003F800,
		char_8[98 ]=64'h003FC0000007F000,
		char_8[99 ]=64'h003FC000000FF000,
		char_8[100]=64'h001FE000000FE000,
		char_8[101]=64'h000FF800001FC000,
		char_8[102]=64'h0007FC00007F8000,
		char_8[103]=64'h0001FF0001FF0000,
		char_8[104]=64'h0000FFE00FFE0000,
		char_8[105]=64'h00007FFFFFF80000,
		char_8[106]=64'h00001FFFFFE00000,
		char_8[107]=64'h000003FFFF800000,
		char_8[108]=64'h0000003FF8000000,
		char_8[109]=64'h0000000000000000,
		char_8[110]=64'h0000000000000000,
		char_8[111]=64'h0000000000000000,
		char_8[112]=64'h0000000000000000,
		char_8[113]=64'h0000000000000000,
		char_8[114]=64'h0000000000000000,
		char_8[115]=64'h0000000000000000,
		char_8[116]=64'h0000000000000000,
		char_8[117]=64'h0000000000000000,
		char_8[118]=64'h0000000000000000,
		char_8[119]=64'h0000000000000000,
		char_8[120]=64'h0000000000000000,
		char_8[121]=64'h0000000000000000,
		char_8[122]=64'h0000000000000000,
		char_8[123]=64'h0000000000000000,
		char_8[124]=64'h0000000000000000,
		char_8[125]=64'h0000000000000000,
		char_8[126]=64'h0000000000000000,
		char_8[127]=64'h0000000000000000;
                       
assign char_9[ 0 ]=64'h0000000000000000,
		 char_9[ 1 ]=64'h0000000000000000,
		 char_9[ 2 ]=64'h0000000000000000,
		 char_9[ 3 ]=64'h0000000000000000,
		 char_9[ 4 ]=64'h0000000000000000,
		 char_9[ 5 ]=64'h0000000000000000,
		 char_9[ 6 ]=64'h0000000000000000,
		 char_9[ 7 ]=64'h0000000000000000,
		 char_9[ 8 ]=64'h0000000000000000,
		 char_9[ 9 ]=64'h0000000000000000,
		 char_9[10 ]=64'h0000000000000000,
		 char_9[11 ]=64'h0000000000000000,
		 char_9[12 ]=64'h0000000000000000,
		 char_9[13 ]=64'h0000000000000000,
		 char_9[14 ]=64'h0000000000000000,
		 char_9[15 ]=64'h0000000000000000,
		 char_9[16 ]=64'h0000000000000000,
		 char_9[17 ]=64'h0000000000000000,
		 char_9[18 ]=64'h0000000000000000,
		 char_9[19 ]=64'h0000000000000000,
		 char_9[20 ]=64'h0000000000000000,
		 char_9[21 ]=64'h0000007FF0000000,
		 char_9[22 ]=64'h000003FFFF000000,
		 char_9[23 ]=64'h00001FFFFFC00000,
		 char_9[24 ]=64'h00007FFFFFE00000,
		 char_9[25 ]=64'h0000FFC01FF80000,
		 char_9[26 ]=64'h0001FE0007FC0000,
		 char_9[27 ]=64'h0003FC0001FE0000,
		 char_9[28 ]=64'h0007F00000FF0000,
		 char_9[29 ]=64'h000FE000007F8000,
		 char_9[30 ]=64'h001FE000003FC000,
		 char_9[31 ]=64'h001FC000001FC000,
		 char_9[32 ]=64'h003F8000001FE000,
		 char_9[33 ]=64'h003F8000000FF000,
		 char_9[34 ]=64'h007F8000000FF000,
		 char_9[35 ]=64'h007F00000007F800,
		 char_9[36 ]=64'h00FF00000007F800,
		 char_9[37 ]=64'h00FE00000007F800,
		 char_9[38 ]=64'h01FE00000003FC00,
		 char_9[39 ]=64'h01FE00000003FC00,
		 char_9[40 ]=64'h01FE00000003FC00,
		 char_9[41 ]=64'h01FE00000003FE00,
		 char_9[42 ]=64'h01FC00000003FE00,
		 char_9[43 ]=64'h03FC00000001FE00,
		 char_9[44 ]=64'h03FC00000001FF00,
		 char_9[45 ]=64'h03FC00000001FF00,
		 char_9[46 ]=64'h03FC00000001FF00,
		 char_9[47 ]=64'h03FC00000001FF00,
		 char_9[48 ]=64'h03FC00000001FF00,
		 char_9[49 ]=64'h03FC00000001FF00,
		 char_9[50 ]=64'h03FC00000001FF00,
		 char_9[51 ]=64'h03FC00000001FF80,
		 char_9[52 ]=64'h03FC00000001FF80,
		 char_9[53 ]=64'h03FC00000001FF80,
		 char_9[54 ]=64'h03FC00000001FF80,
		 char_9[55 ]=64'h03FC00000003FF80,
		 char_9[56 ]=64'h03FE00000003FF80,
		 char_9[57 ]=64'h01FE00000003FF80,
		 char_9[58 ]=64'h01FE00000007FF80,
		 char_9[59 ]=64'h01FE00000007FF80,
		 char_9[60 ]=64'h01FF0000000FFF80,
		 char_9[61 ]=64'h01FF0000001FFF80,
		 char_9[62 ]=64'h00FF8000001FFF80,
		 char_9[63 ]=64'h00FF8000003DFF80,
		 char_9[64 ]=64'h007FC000007DFF80,
		 char_9[65 ]=64'h007FC00000F9FF80,
		 char_9[66 ]=64'h003FE00001F1FF80,
		 char_9[67 ]=64'h003FF00003F1FF80,
		 char_9[68 ]=64'h001FF80007E1FF80,
		 char_9[69 ]=64'h000FFE001FC1FF80,
		 char_9[70 ]=64'h0007FF807F83FF00,
		 char_9[71 ]=64'h0003FFFFFF03FF00,
		 char_9[72 ]=64'h0001FFFFFE03FF00,
		 char_9[73 ]=64'h00007FFFF803FF00,
		 char_9[74 ]=64'h00001FFFE003FF00,
		 char_9[75 ]=64'h000003FF0003FF00,
		 char_9[76 ]=64'h000000000003FF00,
		 char_9[77 ]=64'h000000000003FE00,
		 char_9[78 ]=64'h000000000003FE00,
		 char_9[79 ]=64'h000000000007FE00,
		 char_9[80 ]=64'h000000000007FE00,
		 char_9[81 ]=64'h000000000007FC00,
		 char_9[82 ]=64'h000000000007FC00,
		 char_9[83 ]=64'h000000000007FC00,
		 char_9[84 ]=64'h00000000000FFC00,
		 char_9[85 ]=64'h00000000000FF800,
		 char_9[86 ]=64'h00000000000FF800,
		 char_9[87 ]=64'h00000000000FF800,
		 char_9[88 ]=64'h00000000001FF000,
		 char_9[89 ]=64'h00000000001FF000,
		 char_9[90 ]=64'h00000000001FE000,
		 char_9[91 ]=64'h00000000003FE000,
		 char_9[92 ]=64'h0003E000003FC000,
		 char_9[93 ]=64'h0007F800003FC000,
		 char_9[94 ]=64'h000FF800007F8000,
		 char_9[95 ]=64'h000FF800007F8000,
		 char_9[96 ]=64'h001FFC0000FF0000,
		 char_9[97 ]=64'h001FFC0000FE0000,
		 char_9[98 ]=64'h001FFC0001FE0000,
		 char_9[99 ]=64'h001FFC0003FC0000,
		 char_9[100]=64'h001FFC0007F80000,
		 char_9[101]=64'h000FFC000FF00000,
		 char_9[102]=64'h000FFE001FE00000,
		 char_9[103]=64'h0007FE003FC00000,
		 char_9[104]=64'h0003FF01FF800000,
		 char_9[105]=64'h0001FFFFFE000000,
		 char_9[106]=64'h0000FFFFFC000000,
		 char_9[107]=64'h00001FFFE0000000,
		 char_9[108]=64'h000003FF00000000,
		 char_9[109]=64'h0000000000000000,
		 char_9[110]=64'h0000000000000000,
		 char_9[111]=64'h0000000000000000,
		 char_9[112]=64'h0000000000000000,
		 char_9[113]=64'h0000000000000000,
		 char_9[114]=64'h0000000000000000,
		 char_9[115]=64'h0000000000000000,
		 char_9[116]=64'h0000000000000000,
		 char_9[117]=64'h0000000000000000,
		 char_9[118]=64'h0000000000000000,
		 char_9[119]=64'h0000000000000000,
		 char_9[120]=64'h0000000000000000,
		 char_9[121]=64'h0000000000000000,
		 char_9[122]=64'h0000000000000000,
		 char_9[123]=64'h0000000000000000,
		 char_9[124]=64'h0000000000000000,
		 char_9[125]=64'h0000000000000000,
		 char_9[126]=64'h0000000000000000,
		 char_9[127]=64'h0000000000000000;
 
endmodule



