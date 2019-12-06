module top_module(
	input clk,
    input rst,
	input[23:0] sw,
    input[4:0] bt,
	output[7:0] seg_out,
	output[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);

reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;
seg_tube seg_inst(clk, i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);

reg[3:0] bcd0_i;
wire[7:0] bcd0_o;
bcd_seg bcd_0(bcd0_i, bcd0_o);

reg[3:0] bcd1_i;
wire[7:0] bcd1_o;
bcd_seg bcd_1(bcd1_i, bcd1_o);

reg[3:0] bcd6_i;
wire[7:0] bcd6_o;
bcd_seg bcd_6(bcd6_i, bcd6_o);

reg[3:0] bcd7_i;
wire[7:0] bcd7_o;
bcd_seg bcd_7(bcd7_i, bcd7_o);

parameter NOSHOW = 8'b11111111;

reg [2:0] n_player_count;
reg [3:0] n_question_count;
reg [6:0] n_answer_time;
reg [6:0] n_win_socre;
reg [3:0] n_success_score;
reg [3:0] n_fail_score;

reg [2:0] n_view;
reg [2:0] n_state;

reg [2:0] player_count;
reg [3:0] question_count;
reg [6:0] answer_time;
reg [6:0] win_socre;
reg [3:0] success_score;
reg [3:0] fail_score;

reg [2:0] view;
reg [2:0] state;

always @(view, state) begin
    if(view == 0) begin

        bcd0_i = 5;
        i0 = bcd0_o;

        bcd1_i = state;
        i1 = bcd1_o;

        i2 = NOSHOW;
        i3 = NOSHOW;
        i4 = NOSHOW;
        i5 = NOSHOW;

        case(state)
            0: begin
                i6 = NOSHOW;
                i7 = NOSHOW;
            end
            1: begin
                i6 = NOSHOW;
                bcd7_i = player_count;
                i7 = bcd7_o;
            end
        endcase

    end else if(view == 1) begin

    end
end

always @(view, state, sw) begin
    if(view == 0) begin
        if((state == 0) & sw[22]) begin
            n_state = 1;
        end
        else if(~sw[22] & ~sw[21] & ~sw[20] & ~sw[19] & ~sw[18]) begin
            n_state = 0;
        end

    end else if(view == 1) begin

    end
end

always @(posedge bt[2], posedge bt[4]) begin
    if(state == 1) begin
        if(bt[2]) begin
            n_player_count <= player_count + 1;
        end else if(bt[4]) begin
            n_player_count <= player_count - 1;
        end
    end
end


always @(posedge clk, posedge rst) begin
    if(rst) begin
        view <= 0;
        state <= 0;
        player_count <= 2;
        question_count <= 5;
        answer_time <= 10;
        win_socre <= 3;
        success_score <= 1;
        fail_score <= 1;
    end
    else begin
        view <= n_view;
        state <= n_state;
        player_count <= n_player_count;
        question_count <= n_question_count;
        answer_time <= n_answer_time;
        win_socre <= n_win_socre;
        success_score <= n_success_score;
        fail_score <= n_fail_score;
    end
end


endmodule