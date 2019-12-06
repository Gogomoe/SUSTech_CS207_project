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


reg [2:0] n_player_count;
reg [3:0] n_question_count;
reg [6:0] n_answer_time;
reg [6:0] n_win_socre;
reg [3:0] n_success_score;
reg [3:0] n_fail_score;

reg [2:0] n_view;
reg [2:0] n_state;

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
        if(bt[2] & player_count < 4) begin
            n_player_count <= player_count + 1;
        end else if(bt[4] & player_count > 2) begin
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

//        n_view <= 0;
//        n_state <= 0;
//        n_player_count <= 2;
//        n_question_count <= 5;
//        n_answer_time <= 10;
//        n_win_socre <= 3;
//        n_success_score <= 1;
//        n_fail_score <= 1;
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