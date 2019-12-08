module setting_control(
	input clk,
    input rst,
    input[23:0] sw,
    input[4:0] bt,
    input view,

    output reg[2:0] player_count,
    output reg[3:0] question_count,
    output reg[6:0] answer_time,
    output reg[6:0] win_socre,
    output reg[3:0] success_score,
    output reg[3:0] fail_score,
    output reg[2:0] state
);

//wire rst_press;
//button_jitter rst_jitter(clk, rst, rst_press);

wire up_press, down_press, left_press, right_press;
button_edge up_jitter(clk, bt[2], up_press);
button_edge down_jitter(clk, bt[4], down_press);
button_edge left_jitter(clk, bt[1], left_press);
button_edge right_jitter(clk, bt[0], right_press);

always @(posedge clk) begin
    if(rst)
        state <= 0;
    else begin
        if(view == 0) begin
            if (left_press) begin
                if(state == 0)
                    state <= 6;
                else
                    state <= state - 1;
            end
            else if (right_press) begin
                if(state == 6)
                    state <= 0;
                else
                    state <= state + 1;
            end
        end
    end
end

always @(posedge clk) begin
    if(rst) begin
        player_count <= 2;
        question_count <= 5;
        answer_time <= 10;
        win_socre <= 3;
        success_score <= 1;
        fail_score <= 1;
    end
    else begin
        if(view == 0) begin
            if (up_press) begin
                case(state)
                    1: begin
                        if(player_count < 4) player_count <= player_count + 1;
                    end
                    2: begin
                        if(question_count < 9) question_count <= question_count + 1;
                    end
                    3: begin
                        if(answer_time < 99) answer_time <= answer_time + 1;
                    end
                    4: begin
                        if(win_socre < 99) win_socre <= win_socre + 1;
                    end
                    5: begin
                        if(success_score < 9) success_score <= success_score + 1;
                    end
                    6: begin
                        if(fail_score < 9) fail_score <= fail_score + 1;
                    end
                endcase
            end
            else if (down_press) begin
                case(state)
                    1: begin
                        if(player_count > 2) player_count <= player_count - 1;
                    end
                    2: begin
                        if(question_count > 1) question_count <= question_count - 1;
                    end
                    3: begin
                        if(answer_time > 1) answer_time <= answer_time - 1;
                    end
                    4: begin
                        if(win_socre > 1) win_socre <= win_socre - 1;
                    end
                    5: begin
                        if(success_score > 1) success_score <= success_score - 1;
                    end
                    6: begin
                        if(fail_score > 1) fail_score <= fail_score - 1;
                    end
                endcase
            end
        end
    end
end

endmodule