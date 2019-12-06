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
    sw,
    bt,
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

wire[2:0] cc_state;

competition_control cc_inst(
    clk, rst,
    sw,
    bt,
    o_view,

    cc_state
);

wire[7:0] cv_seg_out;
wire[7:0] cv_seg_en;
wire[23:0] cv_led;
wire cv_buzzer;

competition_view cv_inst(
    clk, rst,
    o_view,
    cc_state,

    cv_seg_out,
    cv_seg_en,
    cv_led,
    cv_buzzer
);

always @(view) begin
    if(view == 0) begin
        seg_out = sv_seg_out;
        seg_en = sv_seg_en;
        led = sv_led;
        buzzer = sv_buzzer;
    end else if(view == 1) begin
        seg_out = cv_seg_out;
        seg_en = cv_seg_en;
        led = cv_led;
        buzzer = cv_buzzer;
    end
end

always @(rst, sw) begin
    if(rst) begin
        view = 0;
    end else begin
        if(view == 0 && sw[23]) begin
            view = 1;
        end
    end
end

endmodule