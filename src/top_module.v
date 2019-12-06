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


wire[2:0] player_count;
wire[3:0] question_count;
wire[6:0] answer_time;
wire[6:0] win_socre;
wire[3:0] success_score;
wire[3:0] fail_score;
wire[2:0] view;
wire[2:0] state;

setting_control sc_inst(
    clk, rst,
    sw,
    bt,

    player_count,
    question_count,
    answer_time,
    win_socre,
    success_score,
    fail_score,
    view,
    state
);

wire[7:0] sv_seg_out;
wire[7:0] sv_seg_en;
wire[23:0] sv_led;
wire sv_buzzer;

setting_view sv_inst(
    clk, rst,
    player_count,
    question_count,
    answer_time,
    win_socre,
    success_score,
    fail_score,
    view,
    state,

    sv_seg_out,
    sv_seg_en,
    sv_led,
    sv_buzzer
);

always @(view, state) begin
    if(view == 0) begin
        seg_out = sv_seg_out;
        seg_en = sv_seg_en;
        led = sv_led;
        buzzer = sv_buzzer;
    end else if(view == 1) begin

    end
end

endmodule