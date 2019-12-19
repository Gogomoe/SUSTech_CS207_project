module inspect_question_view(
    input clk,
    input rst,
    input [2:0] view,

    input[4:0] bt_edge,

    input[3:0]  play_count,
    input[17:0] player1_list,
    input[17:0] player2_list,
    input[17:0] player3_list,
    input[17:0] player4_list,

    output[7:0] seg_out,
    output[7:0] seg_en,
    output reg[23:0] led,
    output reg buzzer
);

wire left_press, right_press;
assign left_press = bt_edge[1];
assign right_press = bt_edge[0];

reg[3:0] state;
always @(posedge clk) begin
    if(rst || view != 4) begin
        state <= 0;
    end
    else begin
        if(state == 0) begin
            state <= 1;
        end
        if(left_press) begin
            if(state == 1)
                state <= play_count;
            else
                state <= state - 1;
        end
        else if(right_press) begin
            if(state == play_count)
                state <= 1;
            else
                state <= state + 1;
        end
    end
end

reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;
seg_tube ipv_seg_inst(clk, i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);

reg[3:0] bcd2_i;
wire[7:0] bcd2_o;
bcd_seg bcd_2(bcd2_i, bcd2_o);

reg[3:0] bcd7_i;
wire[7:0] bcd7_o;
bcd_seg bcd_7(bcd7_i, bcd7_o);

parameter NOSHOW = 8'b11111111;

reg[1:0] p1, p2, p3, p4;
always @(state) begin
    case(state)
        1: begin
            p1 = player1_list[1:0];
            p2 = player2_list[1:0];
            p3 = player3_list[1:0];
            p4 = player4_list[1:0];
        end
        2: begin
            p1 = player1_list[3:2];
            p2 = player2_list[3:2];
            p3 = player3_list[3:2];
            p4 = player4_list[3:2];
        end
        3: begin
            p1 = player1_list[5:4];
            p2 = player2_list[5:4];
            p3 = player3_list[5:4];
            p4 = player4_list[5:4];
        end
        4: begin
            p1 = player1_list[7:6];
            p2 = player2_list[7:6];
            p3 = player3_list[7:6];
            p4 = player4_list[7:6];
        end
        5: begin
            p1 = player1_list[9:8];
            p2 = player2_list[9:8];
            p3 = player3_list[9:8];
            p4 = player4_list[9:8];
        end
        6: begin
            p1 = player1_list[11:10];
            p2 = player2_list[11:10];
            p3 = player3_list[11:10];
            p4 = player4_list[11:10];
        end
        7: begin
            p1 = player1_list[13:12];
            p2 = player2_list[13:12];
            p3 = player3_list[13:12];
            p4 = player4_list[13:12];
        end
        8: begin
            p1 = player1_list[15:14];
            p2 = player2_list[15:14];
            p3 = player3_list[15:14];
            p4 = player4_list[15:14];
        end
        9: begin
            p1 = player1_list[17:16];
            p2 = player2_list[17:16];
            p3 = player3_list[17:16];
            p4 = player4_list[17:16];
        end

    endcase
end

always @(view, state) begin
    if(view == 4) begin
        i0 = 8'b1111_1001;
        i1 = 8'b1001_1000;
        bcd2_i = state;
        i2 = bcd2_o;
        i3 = NOSHOW;
        {i4, i5, i6, i7} = {4{NOSHOW}};

        if(p1 != 0) begin
            case(p1)
                2'b01: bcd7_i = 10;
                2'b10: bcd7_i = 11;
                2'b11: bcd7_i = 0;
            endcase
            i7 = bcd7_o;
            {i4, i5, i6} = {3{NOSHOW}};
        end else if(p2 != 0) begin
            case(p2)
                2'b01: bcd7_i = 10;
                2'b10: bcd7_i = 11;
                2'b11: bcd7_i = 0;
            endcase
            i6 = bcd7_o;
            {i4, i5, i7} = {3{NOSHOW}};
        end else if(p3 != 0) begin
            case(p3)
                2'b01: bcd7_i = 10;
                2'b10: bcd7_i = 11;
                2'b11: bcd7_i = 0;
            endcase
            i5 = bcd7_o;
            {i4, i6, i7} = {3{NOSHOW}};
        end else if(p4 != 0) begin
            case(p4)
                2'b01: bcd7_i = 10;
                2'b10: bcd7_i = 11;
                2'b11: bcd7_i = 0;
            endcase
            i4 = bcd7_o;
            {i5, i6, i7} = {3{NOSHOW}};
        end
    end

end

endmodule