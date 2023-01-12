module Final_Project(
	input CLK,Reset,Load,
	input reg [3:0]Data_in_ten_digit,Data_in_unit_digit,
	output reg COM,COM2,COM3,COM4,
	output reg[3:0] COMM,
	output reg[6:0] Seg,
	output reg[7:0] Data_R,Data_G,Data_B,
	output reg beeper
);
	integer N;
	reg[1:0] com;
	reg[2:0] cnt;
	reg[3:0] out,random1,random2,ten_digit,unit_digit,ten_digit_count,unit_digit_count;
	wire CLK_div,CLK_div2,CLK_div3;
	divfreq F0(CLK,CLK_div);
	divfreq F1(CLK,CLK_div2);
	divfreq F2(CLK,CLK_div3);
//初始化
	initial
		begin
			//十位數與個位數
			random1 = (5*random1 + 3)% 16;
			ten_digit = random1 % 10;
			random2 = (5*(random2+2) + 3) % 16;
			unit_digit = random2 % 10;
			//7段顯示器
			Seg = 7'b0000001;
			COM = 1'b0;
			//點矩陣
			cnt = 0;
			Data_R = 8'b11111111;
			Data_G = 8'b11111111;
			Data_B = 8'b11111111;
			COMM = 4'b1000;
			//蜂鳴聲
			beeper = 0;
		end
	//8X8 of YN
	parameter logic [7:0] N_Char [7:0] =
		 '{8'b00000000,
		   8'b11111101,
		   8'b11111011,
		   8'b11110111,
		   8'b11101111,
		   8'b11011111,
		   8'b10111111,
		   8'b00000000};
	parameter logic [7:0] Y_Char [7:0] =
		 '{8'b01111111,
		   8'b10111111,
		   8'b11011111,
		   8'b11100000,
		   8'b11100000,
		   8'b11011111,
		   8'b10111111,
		   8'b01111111};
//十位數與個位數設定-遊戲開始
	always@(CLK_div3)
		begin
			if(Reset == 1)
				begin
					random1 = (5*random1 + 3)% 16;
					ten_digit = random1 % 10;
					random2 = (5*(random2+2) + 3) % 16;
					unit_digit = random2 % 10;
				end
		end
//7段顯示器的顯示
	always@(posedge CLK)
		begin
			if(Reset == 1)
				ten_digit_count = 4'b0000;
			else if(Load == 1)
				ten_digit_count = Data_in_ten_digit;
			else
				ten_digit_count = ten_digit_count;
		end
	always@(posedge CLK)
		begin
			if(Reset == 1)
				unit_digit_count = 4'b0000;
			else if(Load == 1)
				unit_digit_count = Data_in_unit_digit;
			else
				unit_digit_count = unit_digit_count;
		end
	always@(posedge CLK_div3)
		begin
			if(Reset)
				begin
					if(com==2'b11)
						com=2'b00;
					else
						com=com+1;
					case(com)
						2'b00:
						begin
							COM=0;
							COM2=1;
							COM3=1;
							COM4=1;
							out = 4'b0000;
						end
						2'b01:
						begin
							COM=1;
							COM2=0;
							COM3=1;
							COM4=1;
							out = 4'b0000;
						end
						2'b10:
						begin
							COM=1;
							COM2=1;
							COM3=0;
							COM4=1;
							out = 4'b1001;
						end
						2'b11:
						begin
							COM=1;
							COM2=1;
							COM3=1;
							COM4=0;
							out = 4'b1001;
						end
					endcase
				end
			else
				begin
					if(com==2'b11)
						com=2'b00;
					else
						com=com+1;
					case(com)
						2'b00:
						begin
							COM=0;
							COM2=1;
							COM3=1;
							COM4=1;
							if((ten_digit_count < ten_digit) ||((ten_digit_count == ten_digit) && (unit_digit_count < unit_digit)))
								out = ten_digit_count;
							else
								out = 4'b0000;
						end
						2'b01:
						begin
							COM=1;
							COM2=0;
							COM3=1;
							COM4=1;
							if((ten_digit_count < ten_digit) ||((ten_digit_count == ten_digit) && (unit_digit_count < unit_digit)))
								out = unit_digit_count;
							else
								out = 4'b0000;
						end
						2'b10:
						begin
							COM=1;
							COM2=1;
							COM3=0;
							COM4=1;
							if((ten_digit_count > ten_digit) ||((ten_digit_count == ten_digit) && (unit_digit_count > unit_digit)))
								out = ten_digit_count;
							else
								out = 4'b1001;
						end
						2'b11:
						begin
							COM=1;
							COM2=1;
							COM3=1;
							COM4=0;
							if((ten_digit_count > ten_digit) ||((ten_digit_count == ten_digit) && (unit_digit_count > unit_digit)))
								out = unit_digit_count;
							else
								out = 4'b1001;
						end
					endcase
				end
		case({out})
			4'b0000:Seg = 7'b0000001;
			4'b0001:Seg = 7'b1001111;
			4'b0010:Seg = 7'b0010010;
			4'b0011:Seg = 7'b0000110;
			4'b0100:Seg = 7'b1001100;
			4'b0101:Seg = 7'b0100100;
			4'b0110:Seg = 7'b0100000;
			4'b0111:Seg = 7'b0001111;
			4'b1000:Seg = 7'b0000000;
			4'b1001:Seg = 7'b0000100;
			default:Seg = 7'b0000001;
		endcase
	end
//點矩陣的顯示
	always@(posedge CLK_div)
		begin
			if(cnt >= 7)
				cnt = 0;
			else
				cnt = cnt + 1;
			COMM = {1'b1, cnt};
			if((ten_digit_count == ten_digit) && (unit_digit_count == unit_digit))
				begin
					Data_R = 8'b11111111;
					Data_G = Y_Char[cnt];
					beeper = 1;
				end
			else
				begin
					Data_G = 8'b11111111;
					Data_R = N_Char[cnt];
					beeper = 0;
				end
		end
endmodule
//除頻器
module divfreq(input CLK,output reg CLK_div);
	reg[24:0] Count;
	always@(posedge CLK)
		begin
			if(Count > 25000)
				begin
					Count <= 25'b0;
					CLK_div <= ~CLK_div;
				end
			else
				Count <= Count + 1'b1;
		end
endmodule

module divfreq2(input CLK,output reg CLK_div2);
	reg[24:0] Count;
	always@(posedge CLK)
		begin
			if(Count > 2500)
				begin
					Count <= 25'b0;
					CLK_div2 <= ~CLK_div2;
				end
			else
				Count <= Count + 1'b1;
		end
endmodule

module divfreq3(input CLK,output reg CLK_div3);
	reg[24:0] Count;
	always@(posedge CLK)
		begin
			if(Count > 25000000)
				begin
					Count <= 25'b0;
					CLK_div3 <= ~CLK_div3;
				end
			else
				Count <= Count + 1'b1;
		end
endmodule
