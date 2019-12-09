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