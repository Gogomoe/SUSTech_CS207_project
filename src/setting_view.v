module setting_view(
    input clk,
    input rst,
    input [2:0] view,
    input [2:0] state,

    input [2:0] player_count,
    input [3:0] question_count,
    input [6:0] answer_time,
    input [6:0] win_socre,
    input [3:0] success_score,
    input [3:0] fail_score,

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

always @(
    view, state,
    player_count,
    question_count,
    answer_time,
    win_socre,
    success_score,
    fail_score) begin

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
            2: begin
                i6 = NOSHOW;
                bcd7_i = question_count;
                i7 = bcd7_o;
            end
            3: begin
                bcd6_i = answer_time / 10;
                i6 = bcd6_o;
                bcd7_i = answer_time % 10;
                i7 = bcd7_o;
            end
            4: begin
                bcd6_i = win_socre / 10;
                i6 = bcd6_o;
                bcd7_i = win_socre % 10;
                i7 = bcd7_o;
            end
            5: begin
                i6 = NOSHOW;
                bcd7_i = success_score;
                i7 = bcd7_o;
            end
            6: begin
                i6 = NOSHOW;
                bcd7_i = fail_score;
                i7 = bcd7_o;
            end
            default: begin
                bcd6_i = 0;
                bcd7_i = 0;
                i6 = NOSHOW;
                i7 = NOSHOW;
            end
        endcase
    end else begin
        i0 = NOSHOW;
        i1 = NOSHOW;
        i2 = NOSHOW;
        i3 = NOSHOW;
        i4 = NOSHOW;
        i5 = NOSHOW;
        i6 = NOSHOW;
        i7 = NOSHOW;
    end
end

endmodule