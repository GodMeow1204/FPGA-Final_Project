# FPGA-Final_Project
### Authors: 110321061 110321062

#### Input/Output unit:<br>
* 8X8 LED點矩陣，用來顯示答對與答錯(Y/N)。<br>
* 七段顯示器，用來顯示範圍。<br>
* 指撥開關，用來輸入(左為十位數，右為個位數)。<br>
* 按鈕，用來輸入Reset(重置)與Load(讀入數字)。<br>
#### 功能說明:<br>
先將指撥開關調至想猜的數字(左十位數右個位數,BCD)，然後按下Load後讀入並判別是否與隨機產生的數字相同，相同則答對，不同則答錯。<br>
#### 程式模組說明:<br>
module Final_Project(
	input CLK,Reset,Load,//Reset與Load接到4-bit SW<br>
	input reg[3:0]Data_in_ten_digit,Data_in_unit_digit,//控制輸入的數(指撥開關)<br>
	output reg COM,COM2,COM3,COM4,/四個七段顯示器的切換<br>
	output reg[3:0] COMM,//8X8LED點矩陣(S2,S1,S0,EN)<br>
	output reg[6:0] Seg,//七段顯示器的顯示<br>
	output reg[7:0] Data_R,Data_G,Data_B,//8X8LED點矩陣的RGB<br>
	output reg beeper//蜂鳴聲<br>
);<br>
#### 注意事項:<br>
* 未完成功能:用LED陣列顯示能猜的次數(當前生命數)，歸零時遊戲結束。<br>
* 此程式碼經過demo，也許有些地方經過修改有些小bug。<br>
* 待修正功能(半成品):七段顯示器顯示之範圍，此程式碼只能恆顯示0099，並根據輸入數與隨機數的大小判別左右邊的顯示，並沒辦法真正做到顯示範圍。<br>
EX(期望成品):0099->1099->1080<br>
EX(目前半成品):0099->1099->0080<br>
* Demo完並清點完器材回家以後才寫的Github，忘記提前拍照與錄影，請見諒，I'm sorry!(檔案內應該會包含當時使用的PIN角，可作為參考)<br>
* Reset與Load的按鈕位**一定要分開各用一條線接，否則很容易出現線材內部問題**，建議可以更改為用指撥開關控制輸入，避免按鈕回彈問題。<br>
* 隨機數的設計可以不必像程式碼內將十位數與個位數分開做，可以做完直接mod 100，再除以10做輸出。
