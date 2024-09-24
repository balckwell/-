module vga_state(
    input        sys_clk,
    input        sys_rstn,
    input        key,
    output  reg [3:0] state
);

localparam S0 = 4'b0000; // 初始化状态
localparam S1 = 4'b0001; 
localparam S2 = 4'b0010; 
localparam S3 = 4'b0011;
localparam S4 = 4'b0100;
localparam S5 = 4'b0101; 
localparam S6 = 4'b0110; 
localparam S7 = 4'b0111;  
localparam S8 = 4'b1000;
localparam S9 = 4'b1001;
localparam S10 = 4'b1010;

reg             key_r;
reg    [3:0]    curr_state;
reg    [3:0]    next_state;

// 输入数据打拍
always @(posedge sys_clk) 
		key_r <= key;

//-------- 三段式状态机 --------//
// 第一段（时序逻辑，用于描述状态寄存器）
always @(posedge sys_clk or negedge sys_rstn) begin
    if(!sys_rstn)
        curr_state <= curr_state; //初始化状态
    else
        curr_state <= next_state;
end

// 第二段（组合逻辑，用于状态转移条件判断）
always @(*) begin
	next_state = S0;
	case(curr_state)
		S0 :
			if(key_r == 1'b1)
				next_state = S1;
			else
				next_state = S0;
		S1 :
			if(key_r == 1'b1)
				next_state = S2;
			else
				next_state = S1;
		S2 :
			if(key_r == 1'b1)
				next_state = S3;
			else
				next_state = S2;
		S3 :
			if(key_r == 1'b1)
				next_state = S4;
			else
				next_state = S3;
		S4 :
			if(key_r == 1'b1)
				next_state = S5;
			else
				next_state = S4;
		S5 :
			if(key_r == 1'b1)
				next_state = S6;
			else
				next_state = S5;
		S6 :
			if(key_r == 1'b1)
				next_state = S7;
			else
				next_state = S6;
		S7 :
			if(key_r == 1'b1)
				next_state = S8;
			else
				next_state = S7;
		S8 :
			if(key_r == 1'b1)
				next_state = S9;
			else
				next_state = S8;
		S9 :
			if(key_r == 1'b1)
				next_state = S10;
			else
				next_state = S9;
		S10 :
			if(key_r == 1'b1)
				next_state = S0;
			else
				next_state = S10;
		default: state <= S0;
    endcase
end

// 第三段（时序逻辑，用于描述输出）
always @(posedge sys_clk or negedge sys_rstn) begin
    if(!sys_rstn)
					  state <= S0;
    else
        case(curr_state)
            S0 : state <= S0;
            S1 : state <= S1;
            S2 : state <= S2;
            S3 : state <= S3;
				S4 : state <= S4;
				S5 : state <= S5;
				S6 : state <= S6;
				S7 : state <= S7;
				S8 : state <= S8;
				S9 : state <= S9;
				S10 : state <= S10;
            default: state <= S0;
        endcase
end

endmodule
