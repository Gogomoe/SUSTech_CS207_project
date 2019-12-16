module competition_view(
	input clk,
    input rst,
    input [2:0] view,

    input[3:0]  play_count,
    input[2:0]  state,

    input[17:0] time_remain,
    input[6:0]  player1_score,
    input[6:0]  player2_score,
    input[6:0]  player3_score,
    input[6:0]  player4_score,
    input[17:0] player1_list,
    input[17:0] player2_list,
    input[17:0] player3_list,
    input[17:0] player4_list,
    input[2:0]  select_player,
    input[2:0]  winner,

	output[7:0] seg_out,
	output[7:0] seg_en,
	output[23:0] led,
	output buzzer
);

reg[2:0] last_state;
reg set_player;

alert_player alert_player_inst(clk, rst, set_player, buzzer);

always @(posedge clk) begin
    if(set_player == 1) begin
        set_player <= 0;
    end
    if(view == 1) begin
        if((last_state == 0 && state == 1) || (last_state == 1 && state == 2)) begin
            set_player <= 1;
        end
        last_state <= state;
    end
end

reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;
seg_tube seg_inst(clk, i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);

reg[3:0] bcd1_i;
wire[7:0] bcd1_o;
bcd_seg bcd_1(bcd1_i, bcd1_o);

reg[3:0] bcd2_i;
wire[7:0] bcd2_o;
bcd_seg bcd_2(bcd2_i, bcd2_o);

reg[3:0] bcd4_i;
wire[7:0] bcd4_o;
bcd_seg bcd_4(bcd4_i, bcd4_o);

reg[3:0] bcd5_i;
wire[7:0] bcd5_o;
bcd_seg bcd_5(bcd5_i, bcd5_o);

reg[3:0] bcd6_i;
wire[7:0] bcd6_o;
bcd_seg bcd_6(bcd6_i, bcd6_o);

reg[3:0] bcd7_i;
wire[7:0] bcd7_o;
bcd_seg bcd_7(bcd7_i, bcd7_o);

parameter NOSHOW = 8'b11111111;

always @(*) begin
    if(view == 1) begin

        i0 = 8'b11000110;

        bcd1_i = play_count;
        i1 = bcd1_o;

        bcd2_i = state + 10;
        i2 = bcd2_o;

        i3 = NOSHOW;

        case(state)
            0: begin
                i5 = NOSHOW;
                if(play_count == 0) begin
                    i4 = NOSHOW;
                    i6 = NOSHOW;
                    i7 = NOSHOW;
                end
                else begin
                    case(select_player)
                        0: begin
                            bcd4_i = 0;
                            i4 = bcd4_o;
                            i6 = NOSHOW;
                            i7 = NOSHOW;
                        end
                        1: begin
                            bcd4_i = 1;
                            i4 = bcd4_o;
                            bcd6_i = player1_score / 10;
                            i6 = bcd6_o;
                            bcd7_i = player1_score % 10;
                            i7 = bcd7_o;
                        end
                        2: begin
                            bcd4_i = 2;
                            i4 = bcd4_o;
                            bcd6_i = player2_score / 10;
                            i6 = bcd6_o;
                            bcd7_i = player2_score % 10;
                            i7 = bcd7_o;
                        end
                        3: begin
                            bcd4_i = 3;
                            i4 = bcd4_o;
                            bcd6_i = player3_score / 10;
                            i6 = bcd6_o;
                            bcd7_i = player3_score % 10;
                            i7 = bcd7_o;
                        end
                        4: begin
                            bcd4_i = 4;
                            i4 = bcd4_o;
                            bcd6_i = player4_score / 10;
                            i6 = bcd6_o;
                            bcd7_i = player4_score % 10;
                            i7 = bcd7_o;
                        end
                    endcase
                end

            end
            1: begin
                i4 = NOSHOW;
                i5 = NOSHOW;
                bcd6_i = (time_remain / 1000) / 10;
                i6 = bcd6_o;
                bcd7_i = (time_remain / 1000) % 10;
                i7 = bcd7_o;
            end
            2: begin
                bcd4_i = select_player;
                i4 = bcd4_o;

                i5 = NOSHOW;
                i6 = NOSHOW;
                i7 = NOSHOW;
            end
        endcase
    end
end

endmodule