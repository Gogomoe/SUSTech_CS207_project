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

wire[23:0] sw_press;
wire[23:0] sw_edge;
wire[4:0] bt_press;
wire[4:0] bt_edge;
wire[15:0] key_press;
wire[15:0] key_edge;

input_process input_process_inst(
    clk, rst,
    sw,
    bt,
    row,
    col,
    sw_press,
    sw_edge,
    bt_press,
    bt_edge,
    key_press,
    key_edge
);

reg[2:0] view;
wire[2:0] o_view;
assign o_view = view;

wire[2:0] player_count;
wire[3:0] question_count;
wire[6:0] answer_time;
wire[6:0] win_socre;
wire[3:0] success_score;
wire[3:0] fail_score;
wire[2:0] sc_state;

setting_control sc_inst(
    clk, rst,
    sw_press,
    sw_edge,
    bt_press,
    bt_edge,
    key_press,
    key_edge,

    o_view,

    player_count,
    question_count,
    answer_time,
    win_socre,
    success_score,
    fail_score,
    sc_state
);

wire[7:0] sv_seg_out;
wire[7:0] sv_seg_en;
wire[23:0] sv_led;
wire sv_buzzer;

setting_view sv_inst(
    clk, rst,
    o_view,
    sc_state,

    player_count,
    question_count,
    answer_time,
    win_socre,
    success_score,
    fail_score,

    sv_seg_out,
    sv_seg_en,
    sv_led,
    sv_buzzer
);

wire comprtition_rst;

wire[3:0] play_count;
wire[2:0]  cc_state;
wire[17:0] time_remain;
wire[6:0]  player1_score;
wire[6:0]  player2_score;
wire[6:0]  player3_score;
wire[6:0]  player4_score;
wire[17:0] player1_list;
wire[17:0] player2_list;
wire[17:0] player3_list;
wire[17:0] player4_list;
wire[2:0] select_player;
wire[2:0] winner;

competition_control cc_inst(
    clk, comprtition_rst,
    sw_press,
    sw_edge,
    bt_press,
    bt_edge,
    key_press,
    key_edge,

    o_view,

    player_count,
    question_count,
    answer_time,
    win_socre,
    success_score,
    fail_score,

    play_count,
    cc_state,
    time_remain,
    player1_score,
    player2_score,
    player3_score,
    player4_score,
    player1_list,
    player2_list,
    player3_list,
    player4_list,
    select_player,
    winner
);

wire[7:0] cv_seg_out;
wire[7:0] cv_seg_en;
wire[23:0] cv_led;
wire cv_buzzer;

competition_view cv_inst(
    clk, rst,
    o_view,

    play_count,
    cc_state,
    time_remain,
    player1_score,
    player2_score,
    player3_score,
    player4_score,
    player1_list,
    player2_list,
    player3_list,
    player4_list,
    select_player,
    winner,

    cv_seg_out,
    cv_seg_en,
    cv_led,
    cv_buzzer
);

wire[7:0] wv_seg_out;
wire[7:0] wv_seg_en;
wire[23:0] wv_led;
wire wv_buzzer;

win_view win_inst(
    clk, rst,
    o_view,

    player_count,
    player1_score,
    player2_score,
    player3_score,
    player4_score,
    winner,

    wv_seg_out,
    wv_seg_en,
    wv_led,
    wv_buzzer
);

always @(view) begin
    case(view)
        0: begin
            seg_out = sv_seg_out;
            seg_en = sv_seg_en;
            led = sv_led;
            buzzer = sv_buzzer;
        end
        1: begin
            seg_out = cv_seg_out;
            seg_en = cv_seg_en;
            led = cv_led;
            buzzer = cv_buzzer;
        end
        2: begin
            seg_out = wv_seg_out;
            seg_en = wv_seg_en;
            led = wv_led;
            buzzer = wv_buzzer;
        end
    endcase
end

assign comprtition_rst = rst || view == 0;

always @(posedge clk) begin
    if(rst || (view == 1 && key_edge[15]) || (view == 2 && key_edge[15])) begin
        view <= 0;
    end else if(view == 0 && key_edge[15]) begin
        view <= 1;
    end else if(view == 1 && winner != 0) begin
        view <= 2;
    end
end

endmodule