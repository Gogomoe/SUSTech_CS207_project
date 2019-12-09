module setting_control(
	input clk,
    input rst,
    input[23:0] sw_press,
    input[23:0] sw_edge,
    input[4:0] bt_press,
    input[4:0] bt_edge,
    input[15:0] key_press,
    input[15:0] key_edge,

    input[2:0] view,

    output reg[2:0] player_count,
    output reg[3:0] question_count,
    output reg[6:0] answer_time,
    output reg[6:0] win_score,
    output reg[3:0] success_score,
    output reg[3:0] fail_score,
    output reg[2:0] state
);

wire up_press, down_press, left_press, right_press;
assign up_press = bt_edge[2];
assign down_press = bt_edge[4];
assign left_press = bt_edge[1];
assign right_press = bt_edge[0];

reg[2:0] last_state;
wire state_change = last_state != state;

reg[3:0] cursor;

always @(posedge clk) begin
    if(rst) begin
        state <= 0;
        last_state <= 0;
    end else begin
        if(view == 0) begin
            last_state <= state;
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
        win_score <= 3;
        success_score <= 1;
        fail_score <= 1;
    end
    else begin
        if(view == 0) begin
            if(state_change)
                cursor <= 1;
            case(state)
                1: begin
                    if(up_press && player_count < 4) player_count <= player_count + 1;
                    else if(down_press && player_count > 2) player_count <= player_count - 1;
                    else begin
                        case(key_edge[4:2])
                            3'b100 : player_count <= 4;
                            3'b010 : player_count <= 3;
                            3'b001 : player_count <= 2;
                        endcase
                    end
                end
                2: begin
                    if(up_press && question_count < 9) question_count <= question_count + 1;
                    else if(down_press && question_count > 1) question_count <= question_count - 1;
                    else begin
                        case(key_edge[9:1])
                            9'b100_000_000 : question_count <= 9;
                            9'b010_000_000 : question_count <= 8;
                            9'b001_000_000 : question_count <= 7;
                            9'b000_100_000 : question_count <= 6;
                            9'b000_010_000 : question_count <= 5;
                            9'b000_001_000 : question_count <= 4;
                            9'b000_000_100 : question_count <= 3;
                            9'b000_000_010 : question_count <= 2;
                            9'b000_000_001 : question_count <= 1;
                        endcase
                    end
                end
                3: begin
                    if(up_press && answer_time < 99) answer_time <= answer_time + 1;
                    else if(down_press && answer_time > 1) answer_time <= answer_time - 1;
                    else begin
                        if(cursor == 1) begin
                            case(key_edge[9:0])
                                10'b100_000_000_0 : answer_time <= 90 + answer_time % 10;
                                10'b010_000_000_0 : answer_time <= 80 + answer_time % 10;
                                10'b001_000_000_0 : answer_time <= 70 + answer_time % 10;
                                10'b000_100_000_0 : answer_time <= 60 + answer_time % 10;
                                10'b000_010_000_0 : answer_time <= 50 + answer_time % 10;
                                10'b000_001_000_0 : answer_time <= 40 + answer_time % 10;
                                10'b000_000_100_0 : answer_time <= 30 + answer_time % 10;
                                10'b000_000_010_0 : answer_time <= 20 + answer_time % 10;
                                10'b000_000_001_0 : answer_time <= 10 + answer_time % 10;
                                10'b000_000_000_1 : answer_time <= 0 + answer_time % 10;
                            endcase
                            if(|key_edge[9:0]) cursor <= 0;
                        end
                        if(cursor == 0) begin
                            case(key_edge[9:0])
                                10'b100_000_000_0 : answer_time <= 9 + (answer_time / 10) * 10;
                                10'b010_000_000_0 : answer_time <= 8 + (answer_time / 10) * 10;
                                10'b001_000_000_0 : answer_time <= 7 + (answer_time / 10) * 10;
                                10'b000_100_000_0 : answer_time <= 6 + (answer_time / 10) * 10;
                                10'b000_010_000_0 : answer_time <= 5 + (answer_time / 10) * 10;
                                10'b000_001_000_0 : answer_time <= 4 + (answer_time / 10) * 10;
                                10'b000_000_100_0 : answer_time <= 3 + (answer_time / 10) * 10;
                                10'b000_000_010_0 : answer_time <= 2 + (answer_time / 10) * 10;
                                10'b000_000_001_0 : answer_time <= 1 + (answer_time / 10) * 10;
                                10'b000_000_000_1 : answer_time <= 0 + (answer_time / 10) * 10;
                            endcase
                            if(|key_edge[9:0]) cursor <= 1;
                        end
                    end
                end
                4: begin
                    if(up_press && win_score < 99) win_score <= win_score + 1;
                    else if(down_press && win_score > 1) win_score <= win_score - 1;
                    else begin
                        if(cursor == 1) begin
                            case(key_edge[9:0])
                                10'b100_000_000_0 : win_score <= 90 + win_score % 10;
                                10'b010_000_000_0 : win_score <= 80 + win_score % 10;
                                10'b001_000_000_0 : win_score <= 70 + win_score % 10;
                                10'b000_100_000_0 : win_score <= 60 + win_score % 10;
                                10'b000_010_000_0 : win_score <= 50 + win_score % 10;
                                10'b000_001_000_0 : win_score <= 40 + win_score % 10;
                                10'b000_000_100_0 : win_score <= 30 + win_score % 10;
                                10'b000_000_010_0 : win_score <= 20 + win_score % 10;
                                10'b000_000_001_0 : win_score <= 10 + win_score % 10;
                                10'b000_000_000_1 : win_score <= 0 + win_score % 10;
                            endcase
                            if(|key_edge[9:0]) cursor <= 0;
                        end
                        if(cursor == 0) begin
                            case(key_edge[9:0])
                                10'b100_000_000_0 : win_score <= 9 + (win_score / 10) * 10;
                                10'b010_000_000_0 : win_score <= 8 + (win_score / 10) * 10;
                                10'b001_000_000_0 : win_score <= 7 + (win_score / 10) * 10;
                                10'b000_100_000_0 : win_score <= 6 + (win_score / 10) * 10;
                                10'b000_010_000_0 : win_score <= 5 + (win_score / 10) * 10;
                                10'b000_001_000_0 : win_score <= 4 + (win_score / 10) * 10;
                                10'b000_000_100_0 : win_score <= 3 + (win_score / 10) * 10;
                                10'b000_000_010_0 : win_score <= 2 + (win_score / 10) * 10;
                                10'b000_000_001_0 : win_score <= 1 + (win_score / 10) * 10;
                                10'b000_000_000_1 : win_score <= 0 + (win_score / 10) * 10;
                            endcase
                            if(|key_edge[9:0]) cursor <= 1;
                        end
                    end
                end
                5: begin
                    if(up_press && success_score < 9) success_score <= success_score + 1;
                    else if(down_press && success_score > 1) success_score <= success_score - 1;
                    else begin
                        case(key_edge[9:1])
                            9'b100_000_000 : success_score <= 9;
                            9'b010_000_000 : success_score <= 8;
                            9'b001_000_000 : success_score <= 7;
                            9'b000_100_000 : success_score <= 6;
                            9'b000_010_000 : success_score <= 5;
                            9'b000_001_000 : success_score <= 4;
                            9'b000_000_100 : success_score <= 3;
                            9'b000_000_010 : success_score <= 2;
                            9'b000_000_001 : success_score <= 1;
                        endcase
                    end
                end
                6: begin
                    if(up_press && fail_score < 9) fail_score <= fail_score + 1;
                    else if(down_press && fail_score > 1) fail_score <= fail_score - 1;
                    else begin
                        case(key_edge[9:1])
                            9'b100_000_000 : fail_score <= 9;
                            9'b010_000_000 : fail_score <= 8;
                            9'b001_000_000 : fail_score <= 7;
                            9'b000_100_000 : fail_score <= 6;
                            9'b000_010_000 : fail_score <= 5;
                            9'b000_001_000 : fail_score <= 4;
                            9'b000_000_100 : fail_score <= 3;
                            9'b000_000_010 : fail_score <= 2;
                            9'b000_000_001 : fail_score <= 1;
                        endcase
                    end
                end
            endcase
        end
    end
end

endmodule