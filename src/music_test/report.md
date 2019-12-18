# 报告
<!--[task2.pdf](task2.pdf)-->

# Modules

每个视图下，七段数码管左边第一个位置显示当前视图的标志，第二个位置是视图当前状态

### Button Jitter Remover
在此工程中，我们需要大量用到按键，所以按键防抖动很关键。为了确认按键确实被按下了，我们
使用了一个计数器来计数2*10^5个时钟周期，如果按键的状态在这么多时钟周期内保持不变，那么我们认为这是一次有效的按压，
根据此来改变but_press的状态。
```verilog
`timescale 1ns / 1ps

// this module tries to elimiate the jitter in button pressing
// use 20ms as a counter

module button_jitter(
    input clk,
    input but_in,
    output but_out
);


reg [1:0] record = 2'b00;
wire change_detect;
reg [16:0] cnt;
reg out;

always @(posedge clk)
    record <= {record[0],but_in};

assign change_detect = record[0] ^ record[1];

always @(posedge clk)
    if(change_detect==1)
        cnt <= 0;
    else
        cnt <= cnt + 1;

always @(posedge clk)
    if(cnt == 10_0000) begin
        out <= record[0];
    end

assign but_out = out;

endmodule
```
### button_edge

```verilog
`timescale 1ns / 1ps

// this module make press button edge

module button_edge(
    input clk,
    input but_in,
    output but_press,
    output but_edge
);

button_jitter jitter(clk, but_in, but_press);

reg [1:0] record = 2'b00;

always @(posedge clk)
    record <= {record[0], but_press};

assign but_edge = record[0] & ~record[1];

endmodule
```
### competition_control
比赛控制模块是最重要的模块之一
```verilog
module competition_control(
	input clk,
    input rst,
    input[23:0] sw_press,
    input[23:0] sw_edge,
    input[4:0] bt_press,
    input[4:0] bt_edge,
    input[15:0] key_press,
    input[15:0] key_edge,

    input[2:0] view,

    input [2:0] player_count,
    input [3:0] question_count,
    input [6:0] answer_time,
    input [6:0] win_socre,
    input [3:0] success_score,
    input [3:0] fail_score,

    output reg[3:0]  play_count,
    output reg[2:0]  state,

    output reg[17:0] time_remain,
    output reg[6:0]  player1_score,
    output reg[6:0]  player2_score,
    output reg[6:0]  player3_score,
    output reg[6:0]  player4_score,
    output reg[17:0] player1_list,
    output reg[17:0] player2_list,
    output reg[17:0] player3_list,
    output reg[17:0] player4_list,
    output reg[2:0]  select_player,
    output reg[2:0]  winner
);

wire ms_clk;
reg clock_end;
clk_div #(100_000) ms_clk_inst(clk, rst, ms_clk);

always @(posedge clk) begin
    if(rst || view == 0) begin
        play_count <= 0;
        state <= 0;
        player1_score <= 0;
        player2_score <= 0;
        player3_score <= 0;
        player4_score <= 0;
        player1_list <= 0;
        player2_list <= 0;
        player3_list <= 0;
        player4_list <= 0;
        winner <= 0;
        select_player <= 0;
    end
    else begin
        if(view == 1) begin
            case(state)
                0: begin
                    if(key_edge[14]) begin
                        if(play_count == question_count) begin
                            if(player1_score >= player2_score && player1_score >= player3_score && player1_score >= player4_score)
                                winner = 1;
                            else if(player2_score >= player1_score && player2_score >= player3_score && player2_score >= player4_score)
                                winner = 2;
                            else if(player3_score >= player1_score && player3_score >= player2_score && player3_score >= player4_score)
                                winner = 3;
                            else if(player4_score >= player1_score && player4_score >= player2_score && player4_score >= player3_score)
                                winner = 4;
                        end else if(player1_score >= win_socre) begin
                            winner = 1;
                        end else if(player2_score >= win_socre) begin
                            winner = 2;
                        end else if(player3_score >= win_socre) begin
                            winner = 3;
                        end else if(player4_score >= win_socre) begin
                            winner = 4;
                        end else begin
                            play_count <= play_count + 1;
                            state <= 1;
                            select_player <= 0;
                        end
                    end
                end
                1: begin
                    if(clock_end) begin
                        select_player <= 0;
                        state <= 2;
                    end
                    case(key_edge[4:1])
                        4'b1000: begin
                            if(player_count >= 4) begin
                                select_player <= 4;
                                state <= 2;
                            end
                        end
                        4'b0100: begin
                            if(player_count >= 3) begin
                                select_player <= 3;
                                state <= 2;
                            end
                        end
                        4'b0010: begin
                            select_player <= 2;
                            state <= 2;
                        end
                        4'b0001: begin
                            select_player <= 1;
                            state <= 2;
                        end
                    endcase
                end
                2: begin
                    case({key_edge[10], key_edge[11], key_edge[0]})
                        3'b100: begin // success
                            case(select_player)
                                1: begin
                                    player1_list <= player1_list | (18'd1 << (play_count - 1) * 2);
                                    player1_score <= player1_score + success_score;
                                end
                                2: begin
                                    player2_list <= player2_list | (18'd1 << (play_count - 1) * 2);
                                    player2_score <= player2_score + success_score;
                                end
                                3: begin
                                    player3_list <= player3_list | (18'd1 << (play_count - 1) * 2);
                                    player3_score <= player3_score + success_score;
                                end
                                4: begin
                                    player4_list <= player4_list | (18'd1 << (play_count - 1) * 2);
                                    player4_score <= player4_score + success_score;
                                end
                            endcase
                        end
                        3'b010: begin // fail
                            case(select_player)
                                1: begin
                                    player1_list <= player1_list | (18'd2 << (play_count - 1) * 2);
                                    if(player1_score - fail_score > player1_score)
                                        player1_score <= 0;
                                    else
                                        player1_score <= player1_score - fail_score;
                                end
                                2: begin
                                    player2_list <= player2_list | (18'd2 << (play_count - 1) * 2);
                                    if(player2_score - fail_score > player2_score)
                                        player2_score <= 0;
                                    else
                                        player2_score <= player2_score - fail_score;
                                end
                                3: begin
                                    player3_list <= player3_list | (18'd2 << (play_count - 1) * 2);
                                    if(player3_score - fail_score > player3_score)
                                        player3_score <= 0;
                                    else
                                        player3_score <= player3_score - fail_score;
                                end
                                4: begin
                                    player4_list <= player4_list | (18'd2 << (play_count - 1) * 2);
                                    if(player4_score - fail_score > player4_score)
                                        player4_score <= 0;
                                    else
                                        player4_score <= player4_score - fail_score;
                                end
                            endcase
                        end
                        3'b001: begin // no score
                            case(select_player)
                                1: begin
                                    player1_list <= player1_list | (18'd3 << (play_count - 1) * 2);
                                end
                                2: begin
                                    player2_list <= player2_list | (18'd3 << (play_count - 1) * 2);
                                end
                                3: begin
                                    player3_list <= player3_list | (18'd3 << (play_count - 1) * 2);
                                end
                                4: begin
                                    player4_list <= player4_list | (18'd3 << (play_count - 1) * 2);
                                end
                            endcase
                        end
                    endcase
                    if(key_edge[10] + key_edge[11] + key_edge[0] == 1) begin
                        state <= 0;
                    end
                end
            endcase
        end
    end
end

always @(posedge ms_clk) begin
    if(rst || view != 1 || state != 1) begin
        time_remain <= 0;
        clock_end <= 0;
    end
    else if(state == 1) begin
        case(time_remain)
            0 : begin
                time_remain <= answer_time * 1000;
                clock_end <= 0;
            end
            10 : clock_end <= 1;
            default : time_remain <= time_remain - 1;
        endcase
    end
end

endmodule
```
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
- C0 处于就绪状态，主持人可以拨开关 # 进入下一个模式，并将状态置为 C1，同时会有蜂鸣器提醒，显示倒计时
- C1 处于抢答状态，选手可以按下 1，2，3，4 按钮将状态置为 C2，并显示选手的编号和分数
- C2 处于锁定状态，主持人可以按 A，B 评分，A为答对，B为答错，然后显示更新后的分数，同进进入 C0 模式

处在 C0 状态时，可以按按钮 C，进入审视选手模式，审视选手模式按选手编号可以显示其编号和分数，按 * 返回

处在 C0 状态时，可以按按钮 D，进入审视得分模式，审视得分模式按题目编号可以显示该题得分情况，按 * 返回

题目答完后，进入结果显示模式，滚动显示各组的编号、分数，滚动完后显示胜利组的组号

# 模块

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