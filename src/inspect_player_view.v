module inspect_player_view(
    input clk,
    input rst,
    input [2:0] view,

    input[4:0] bt_edge,

    input[2:0] player_count,
    input[6:0] player1_score,
    input[6:0] player2_score,
    input[6:0] player3_score,
    input[6:0] player4_score,

    output[7:0] seg_out,
    output[7:0] seg_en,
    output reg[23:0] led,
    output reg buzzer
);

wire left_press, right_press;
assign left_press = bt_edge[1];
assign right_press = bt_edge[0];

reg[2:0] state;
always @(posedge clk) begin
    if(rst || view != 3) begin
        state <= 0;
    end
    else begin
        if(state == 0) begin
            state <= 1;
        end
        if(left_press) begin
            if(state == 1)
                state <= player_count;
            else
                state <= state - 1;
        end
        else if(right_press) begin
            if(state == player_count)
                state <= 1;
            else
                state <= state + 1;
        end
    end
end

reg[3:0] bcd4_i;
wire[7:0] bcd4_o;
bcd_seg bcd_4(bcd4_i, bcd4_o);

reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;
seg_tube ipv_seg_inst(clk, i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);

reg[3:0] bcd6_i;
wire[7:0] bcd6_o;
bcd_seg bcd_6(bcd6_i, bcd6_o);

reg[3:0] bcd7_i;
wire[7:0] bcd7_o;
bcd_seg bcd_7(bcd7_i, bcd7_o);

parameter NOSHOW = 8'b11111111;

always @(*) begin
    if(view == 3) begin
        i0 = 8'b1111_1001;
        i1 = 8'b1000_1100;
        {i2, i3, i5} = {3{NOSHOW}};
        {i4, i6, i7} = {bcd4_o, bcd6_o, bcd7_o};
        bcd4_i = state;
        case(state)
            1: begin
                bcd6_i = player1_score / 10;
                bcd7_i = player1_score % 10;
            end
            2: begin
                bcd6_i = player2_score / 10;
                bcd7_i = player2_score % 10;
            end
            3: begin
                bcd6_i = player3_score / 10;
                bcd7_i = player3_score % 10;
            end
            4: begin
                bcd6_i = player4_score / 10;
                bcd7_i = player4_score % 10;
            end
        endcase
    end
end

endmodule