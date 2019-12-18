# 一、开发计划及执行记录

## a) 题目要求
[task2.pdf](task2.pdf)

## b) 任务划分
  
   江川：
   
   张湲：
    
   鲁瑞敏：

## c) 执行记录
    
   2019.12.06：确定选题、进行分工
   
   2019.12.13：模块整合、检验成果
   
   2019.12.20：完成报告

# 二、设计

## a) 需求分析

###功能
抢答器共有五个视图，除结果显示视图外，每个视图下，七段数码管左边会显示当前视图的标志

#### Set

设置视图的标志为 `S`

抢答器置于初始状态时，会默认进入`S`状态，通过 `*`来切换`S`与`C`状态

在抢答过程中，按下`*`会重新进入`S`模式，原设置不变，抢答器的`C`模式会重置

设置视图有如下状态，在状态中按 * 返回

- 1，设置参与人数（2-4，默认值为2）
- 2，设置答题题数（0-9，默认值为5）
- 3，设置抢答倒计时时间（0-99，默认值为10）
- 4，设置胜利分数（0-99，默认值为5）
- 5，设置答对一题的得分（0-10，默认值 1）
- 6，设置答错一题的扣分（0-10，默认值 1）

主持人可以右边的左右按键来切换状态，可以通过右边的上下按键以及左边小键盘来调整每个状态的数值

#### Competition

抢答视图的标志为 `C`

抢答视图有 <题数> 个模式，一开始的模式为 0

- `C<题数> A`处于就绪状态，主持人可以拨开关 `#`进入下一个模式，并将状态置为 `C<题数>b` ，同时会有蜂鸣器提醒，
- `C<题数> b`处于抢答状态，最右侧数码管显示倒计时，主持人可以按下 1，2，3，4 按钮来确定抢到题目的选手，并将状态置为 `C<题数>C`，显示选手的编号和当前分数
（若倒计时结束没有选手抢答，则显示0并进入`C<题数> C`模式，表示无人抢答）
- `C<题数> C`处于锁定状态，主持人可以按 A，B，0 评分，A为答对，B为答错，0为不计分，然后显示更新后的分数，同进进入 `C<题数+1> A` 模式

#### Inspect Player

是审视选手视图，标志为`IP`

抢答器处在`C`状态时，可以按按钮`C`，进入审视选手模式，审视选手模式可以选手的编号和分数，按`C`返回

主持人可以右边的左右按键来切换选手

#### Inspect Question

是审视问题得分视图，标志为`Iq`

抢答器处在`C`状态时，可以按按钮 `D`，进入审视得分模式，审视得分模式按题目编号可以显示该题得分状态A、B、0，按 `D` 返回

主持人可以右边的左右按键来切换题目

#### Win

答题过程中，如果有选手达到获胜分数，会提前进入结果显示模式

如果题目答完，没有玩家达到获胜分数，则默认分数最高且编号靠前的选手为获胜者并进入结果显示模式

结果显示模式会滚动显示各组的编号、分数，滚动完后显示胜利组的组号及分数

滚动显示时，最右侧的led灯会根据节拍改变，蜂鸣器会播放一段音乐

## b) 系统结构图

## c) 系统执行流程

## d) 子模块

### top_module

是根模块，将会实例化各个 view 模块、control 模块。


```verilog
module top_module(
	input clk,
    input rst,
	input[23:0] sw,
    input[4:0] bt,
    input[3:0] row,
    output[3:0] col,
	output reg[7:0] seg_out,
	output reg[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);

endmodule
```

### win_view

是某个参赛者获胜的的视图，通过该模块输入玩家的分数与胜利者的编号，该模块会在七段数码管上循环展示每个参赛者的分数，
最终会获胜者的编号和分数会停留在七段数码管的右侧，同时通过`music_player`播放音乐。

```verilog
module win_view(
	input clk,
    input rst,
    input [2:0] view,

    input[2:0] player_count,
    input[6:0] player1_score,
    input[6:0] player2_score,
    input[6:0] player3_score,
    input[6:0] player4_score,
    input[2:0] winner,

	output[7:0] seg_out,
	output[7:0] seg_en,
	output[23:0] led,
	output buzzer
);

endmodule
```

### setting_view

是设置视图，通过该模块输入玩家数量、问题数量、抢答时间、胜利时的分数、答对一题的得分，答错一题的扣分
并将他们显示在七段数码管上。

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
    output[23:0] led,
    output buzzer
);


endmodule
```

### inspect_player_view

是玩家视图，通过该模块输入玩家数及玩家的分数，可以在七段数码管上分别显示当前每个玩家已获得的分数

```verilog
module inspect_player_view(
	input clk,
    input rst,
    input [2:0] view,

    input[4:0] bt_edge,

    input[2:0] player_count,
    input[6:0] player1_score,
    input[6:0] player2_score,
    input[6:0] player3_score,
    input[6:0] player4_score,

	output[7:0] seg_out,
	output[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);

endmodule
```

### inspect_question_view

是问题视图，通过该模块输入玩家数量及每个玩家的回答情况，将每道题的得分情况展示在七段数码管上。
`player_list`是每个玩家的分数列表，`player_list[n+1,n]`为第该玩家在第n-1道题的得分情况。
其中`player_list[n+1,n]`位中`00`、`01`、`10`、`11`分别表示玩家未抢到、玩家抢到且回答正确、玩家抢到但回答错误、玩家抢到但不得分。

```verilog
module inspect_question_view(
	input clk,
    input rst,
    input [2:0] view,

    input[4:0] bt_edge,

    input[3:0]  play_count,
    input[17:0] player1_list,
    input[17:0] player2_list,
    input[17:0] player3_list,
    input[17:0] player4_list,

	output[7:0] seg_out,
	output[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);

endmodule
```

### setting_control

是设置

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

### input_process

```verilog
module input_process(
    input clk, rst,
	input[23:0] sw,
    input[4:0] bt,
    input[3:0] row,
    output[3:0] col,
    output[23:0] sw_press,
    output[23:0] sw_edge,
    output[4:0] bt_press,
    output[4:0] bt_edge,
    output[15:0] key_press,
    output[15:0] key_edge
);

endmodule
```

### key_mapping

```verilog
module key_mapping(
    input[15:0] key_in,
    output[15:0] key_out
);

endmodule
```

### key_scanner

```verilog
module key_scanner(
    input clk, rst,
    input [3:0] row,
    output reg [3:0] col,
    output [15:0] keys
);

endmodule
```

### music_player

```verilog
module music_player(
    input clk,
    input rst,
    output[23:0] led,
    output buzzer
);

endmodule
```

### seg_tube

```verilog
module seg_tube(
    input clk,
    input[7:0] i0, i1, i2, i3, i4, i5, i6, i7,
    output reg[7:0] seg, seg_en
);

endmodule
```

## e) 约束文件

# 三、测试

## a) Testbench

## b) 子模块的仿真波形及测试结果

## c) 联合调试的仿真波形及测试结果

# 四、总结

## a) 遇到的问题及解决方案

## b) 当前系统的特色以及优化方向

