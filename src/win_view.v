module win_view(
	input clk,
    input rst,
    input [2:0] view,

    input[2:0] player_count,
    input[6:0] player1_score,
    input[6:0] player2_score,
    input[6:0] player3_score,
    input[6:0] player4_score,
    input[2:0] winner,

	output[7:0] seg_out,
	output[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);

parameter WIN_STATE = 7;

reg[2:0] state;
reg[2:0] pos;
reg[4:0] ms100_pass;

reg[6:0] show_score;

wire ms_clk;
clk_div #(100_000) ms_clk_inst(clk, rst, ms_clk);
wire ms100_clk;
clk_div #(100) ms100_clk_inst(ms_clk, rst, ms100_clk);
wire ms100_edge;
edge_gen ms100_edge_inst(clk, ms100_clk, ms100_edge);

always @(posedge clk) begin
    if(rst || view != 2) begin
        state <= 0;
        pos <= 0;
        ms100_pass <= 0;
        show_score <= 0;
    end
    else begin
        if(state == 0) begin
            state <= 1;
            show_score <= player1_score;
            pos <= 0;
        end else if(state == player_count && pos == 5) begin
            state <= WIN_STATE;
            pos <= 0;
            case(winner)
                1: show_score <= player1_score;
                2: show_score <= player2_score;
                3: show_score <= player3_score;
                4: show_score <= player4_score;
            endcase
        end else if(pos == 5) begin
            case(state)
                1: show_score <= player2_score;
                2: show_score <= player3_score;
                3: show_score <= player4_score;
            endcase
            state <= state + 1;
            pos <= 0;
        end

        if(state >= 1 && state <= player_count) begin
            if(ms100_pass == 10) begin
                pos <= pos + 1;
                ms100_pass <= 0;
            end else if(ms100_edge) begin
                ms100_pass <= ms100_pass + 1;
            end
        end
    end
end

reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;
seg_tube seg_inst(clk, i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);

reg[3:0] bcd0_i;
wire[7:0] bcd0_o;
bcd_seg bcd_0(bcd0_i, bcd0_o);

reg[3:0] bcd1_i;
wire[7:0] bcd1_o;
bcd_seg bcd_1(bcd1_i, bcd1_o);

reg[3:0] bcd2_i;
wire[7:0] bcd2_o;
bcd_seg bcd_2(bcd2_i, bcd2_o);

reg[3:0] bcd3_i;
wire[7:0] bcd3_o;
bcd_seg bcd_3(bcd3_i, bcd3_o);

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
    if(view == 2) begin
        if(state == 0) begin
            {i0, i1, i2, i3, i4, i5, i6, i7} <= {8{NOSHOW}};
        end
        else if(state >= 1 && state <= player_count) begin
            bcd4_i <= state;
            bcd6_i <= show_score / 10;
            bcd7_i <= show_score % 10;
            case(pos)
                0: {i0, i1, i2, i3, i4, i5, i6, i7} <= {bcd4_o, NOSHOW, bcd6_o, bcd7_o, {4{NOSHOW}} };
                1: {i0, i1, i2, i3, i4, i5, i6, i7} <= {NOSHOW, bcd4_o, NOSHOW, bcd6_o, bcd7_o, {3{NOSHOW}} };
                2: {i0, i1, i2, i3, i4, i5, i6, i7} <= {{2{NOSHOW}}, bcd4_o, NOSHOW, bcd6_o, bcd7_o, {2{NOSHOW}} };
                3: {i0, i1, i2, i3, i4, i5, i6, i7} <= {{3{NOSHOW}}, bcd4_o, NOSHOW, bcd6_o, bcd7_o, NOSHOW };
                4: {i0, i1, i2, i3, i4, i5, i6, i7} <= {{4{NOSHOW}}, bcd4_o, NOSHOW, bcd6_o, bcd7_o};
                5: {i0, i1, i2, i3, i4, i5, i6, i7} <= {8{NOSHOW}};
            endcase
        end
        else begin
            {i0, i1, i2, i3, i5} <= {5{NOSHOW}};
            bcd4_i <= winner;
            i4 <= bcd4_o;
            bcd6_i <= show_score / 10;
            i6 <= bcd6_o;
            bcd7_i <= show_score % 10;
            i7 <= bcd7_o;
        end
    end
end


endmodule