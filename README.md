# 题目要求

[task2.pdf](task2.pdf)

# 视图

每个视图下，七段数码管左边第一个位置显示当前视图的标志，第二个位置是视图当前状态

### Home

主视图的标志为 H

主视图下可有两种操作

- 按A进入 [设置视图](#Set) 
- 按B进入 [抢答视图](#Competition)

### Set

设置视图的标志为 S，按 * 返回 [主视图](#Home)

设置视图有如下状态，在状态中按 * 返回

- 1，设置参与人数（2-4，默认值为2）
- 2，设置答题题数（0-9，默认值为5）
- 3，设置抢答倒计时时间（0-99，默认值为10）
- 4，设置胜利分数（0-99，默认值为5）
- 5，设置胜利得分（0-10，默认值 1）
- 6，设置失败扣分（0-10，默认值 1）

### Competition

抢答视图的标志为 C，按 * 返回 [主视图](#Home)，按 # 重置状态、模式重新开始抢答

抢答视图有 <题数> 个模式，一开始的模式为 0

有一个状态 C
- C0 处于就绪状态，主持人可以拨开关 B1 进入下一个模式，并将状态置为 C1，同时会有蜂鸣器提醒，显示倒计时
- C1 处于抢答状态，选手可以按下 1，2，3，4 按钮将状态置为 C2，并显示选手的编号和分数
- C2 处于锁定状态，主持人可以按 A，B 评分，A为答对，B为答错，然后显示更新后的分数，同进进入 C0 模式

处在 C0 状态时，可以按按钮 C，进入审视选手模式，审视选手模式按选手编号可以显示其编号和分数，按 * 返回

处在 C0 状态时，可以按按钮 D，进入审视得分模式，审视得分模式按题目编号可以显示该题得分情况，按 * 返回

题目答完后，进入结果显示模式，滚动显示各组的编号、分数，滚动完后显示胜利组的组号

# 模块

### RAM

储存数据的模块，声明如下

### top_module

是根模块，将会实例化各个 view 模块、control 模块

```verilog
module top_module(
	input clk,
    input rst,
	input[23:0] sw,
    input[4:0] bt,
	output reg[7:0] seg_out,
	output reg[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);

endmodule
```

### setting_view

```verilog
module setting_view(
	input clk,
    input rst,

    input [2:0] player_count,
    input [3:0] question_count,
    input [6:0] answer_time,
    input [6:0] win_socre,
    input [3:0] success_score,
    input [3:0] fail_score,
    input [2:0] view,
    input [2:0] state,

	output[7:0] seg_out,
	output[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);


endmodule
```

### setting_view

```verilog
module setting_view(
	input pow,
	input clk,
	input[22:0] sw,
    input[4:0] bt,
	output reg[7:0] seg_out,
	output reg[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer,
	output reg write, 
	output reg [3:0] RAddr, WAddr,
	input [15:0] ram,
	output reg [15:0] data,
	output reg exit
);

endmodule
```

### setting_control

```verilog
module setting_control(
	input clk,
    input rst,
    input[23:0] sw,
    input[4:0] bt,

    output reg[2:0] player_count,
    output reg[3:0] question_count,
    output reg[6:0] answer_time,
    output reg[6:0] win_socre,
    output reg[3:0] success_score,
    output reg[3:0] fail_score,
    output reg[2:0] view,
    output reg[2:0] state
);

endmodule
```